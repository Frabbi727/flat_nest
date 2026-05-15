import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheManager {
  final _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _userDataKey = 'user_data';

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _isLoggedInKey, value: 'true');
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _isLoggedInKey);
    return value == 'true';
  }

  Future<bool> isFirstTime() async {
    final value = await _storage.read(key: _isFirstTimeKey);
    return value == null; // It's first time if the key hasn't been set yet
  }

  Future<void> setNotFirstTime() async {
    await _storage.write(key: _isFirstTimeKey, value: 'false');
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.write(key: _isLoggedInKey, value: 'false');
  }

  Future<void> saveUserData(String jsonData) async {
    await _storage.write(key: _userDataKey, value: jsonData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
