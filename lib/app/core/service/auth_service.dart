import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../cache/cache_manager.dart';
import '../network/api_config.dart';

class AuthService extends GetxService {
  final CacheManager _cacheManager = CacheManager();
  final RxnString _accessToken = RxnString();
  final RxnString _refreshToken = RxnString();
  final RxBool _isFirstTime = true.obs;

  String? get token => _accessToken.value;
  String? get refreshToken => _refreshToken.value;
  bool get isAuthenticated => _accessToken.value != null;
  bool get isFirstTime => _isFirstTime.value;

  Future<AuthService> init() async {
    _accessToken.value = await _cacheManager.getAccessToken();
    _refreshToken.value = await _cacheManager.getRefreshToken();
    _isFirstTime.value = await _cacheManager.isFirstTime();
    return this;
  }

  Future<void> login({required String accessToken, required String refreshToken}) async {
    await _cacheManager.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    _accessToken.value = accessToken;
    _refreshToken.value = refreshToken;
  }

  Future<void> logout() async {
    await _cacheManager.clearTokens();
    _accessToken.value = null;
    _refreshToken.value = null;
  }

  Future<void> completeOnboarding() async {
    await _cacheManager.setNotFirstTime();
    _isFirstTime.value = false;
  }

  /// Mechanism to refresh token when expired
  Future<bool> refreshAuthToken() async {
    try {
      if (_refreshToken.value == null) return false;

      // We use a clean Dio instance to avoid interceptor loops
      final dio = Dio(); 
      final response = await dio.post(
        '${ApiConfig.baseUrl}/v1/auth/refresh',
        data: {'refresh_token': _refreshToken.value},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        
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
