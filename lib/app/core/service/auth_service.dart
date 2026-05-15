import 'package:get/get.dart';
import '../cache/cache_manager.dart';

class AuthService extends GetxService {
  final CacheManager _cacheManager = CacheManager();
  final RxnString _token = RxnString();

  String? get token => _token.value;
  bool get isAuthenticated => _token.value != null;

  Future<AuthService> init() async {
    _token.value = await _cacheManager.getToken();
    return this;
  }

  Future<void> login(String token) async {
    await _cacheManager.saveToken(token);
    _token.value = token;
  }

  Future<void> logout() async {
    await _cacheManager.removeToken();
    _token.value = null;
  }
}
