import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../cache/cache_manager.dart';
import '../network/api_config.dart';
import '../../modules/auth/model/user_model.dart';

class AuthService extends GetxService {
  final CacheManager _cacheManager = CacheManager();
  final RxnString _accessToken = RxnString();
  final RxnString _refreshToken = RxnString();
  final RxBool _isFirstTime = true.obs;
  final Rxn<UserModel> _currentUser = Rxn<UserModel>();

  String? get token => _accessToken.value;
  String? get refreshToken => _refreshToken.value;
  bool get isAuthenticated => _accessToken.value != null;
  RxnString get tokenNotifier => _accessToken;
  bool get isFirstTime => _isFirstTime.value;
  UserModel? get currentUser => _currentUser.value;
  Rxn<UserModel> get currentUserRx => _currentUser;

  Future<AuthService> init() async {
    _accessToken.value = await _cacheManager.getAccessToken();
    _refreshToken.value = await _cacheManager.getRefreshToken();
    _isFirstTime.value = await _cacheManager.isFirstTime();
    final userData = await _cacheManager.getUserData();
    if (userData != null) {
      _currentUser.value = UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
    }
    return this;
  }

  Future<void> login({required String accessToken, required String refreshToken}) async {
    await _cacheManager.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    _accessToken.value = accessToken;
    _refreshToken.value = refreshToken;
  }

  void saveUser(UserModel user) {
    _currentUser.value = user;
    _cacheManager.saveUserData(jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    // Call backend logout (best-effort — don't block if it fails)
    try {
      final token = _accessToken.value;
      if (token != null) {
        await Dio().post(
          '${ApiConfig.baseUrl}/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
        );
      }
    } catch (_) {}

    // Clear Google session so account picker shows next time
    await GoogleSignIn.instance.signOut();

    await _cacheManager.clearTokens();
    _accessToken.value = null;
    _refreshToken.value = null;
    _currentUser.value = null;
  }

  // Returns true=deleted, null=session expired (go to login), false=other error
  Future<bool?> deleteAccount() async {
    final token = _accessToken.value;
    if (token == null) return null;
    try {
      await Dio().delete(
        '${ApiConfig.baseUrl}/auth/account',
        options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await GoogleSignIn.instance.signOut();
        await _cacheManager.clearTokens();
        _accessToken.value = null;
        _refreshToken.value = null;
        _currentUser.value = null;
        return null;
      }
      return false;
    } catch (_) {
      return false;
    }
    await GoogleSignIn.instance.signOut();
    await _cacheManager.clearTokens();
    _accessToken.value = null;
    _refreshToken.value = null;
    _currentUser.value = null;
    return true;
  }

  Future<void> completeOnboarding() async {
    await _cacheManager.setNotFirstTime();
    _isFirstTime.value = false;
  }

  Future<bool> refreshAuthToken() async {
    try {
      if (_refreshToken.value == null) return false;

      final dio = Dio();
      final response = await dio.post(
        '${ApiConfig.baseUrl}/auth/refresh',
        data: {'refresh_token': _refreshToken.value},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String;
        final newRefreshToken = _refreshToken.value!;
        await login(accessToken: newAccessToken, refreshToken: newRefreshToken);
        return true;
      }
    } catch (e) {
      Get.log('Token refresh failed: $e');
      await logout();
    }
    return false;
  }
}
