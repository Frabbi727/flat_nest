enum ApiEnvironment { dev, staging, prod }

class ApiConfig {
  static ApiEnvironment environment = ApiEnvironment.dev;

  static String get baseUrl {
    switch (environment) {
      case ApiEnvironment.dev:
      // return 'https://flatnest.techrealify.com/api/v1'; // live
      return 'http://192.168.0.138:8000/api/v1'; // ulon basha
     // return 'http://10.44.66.202:8000/api/v1'; // Office
      //  return 'http://10.150.84.202:8000/api/v1'; // mobile hotspot
       //  return 'http://92.168.0.108:8000/api/v1';
      case ApiEnvironment.staging:
        return 'https://flatnest.techrealify.com/api/v1';
      case ApiEnvironment.prod:
        return 'https://flatnest.techrealify.com/api/v1';
    }
  }

  // Origin only (no /api/v1) — used to resolve relative storage URLs
  static String get storageBaseUrl {
    final uri = Uri.parse(baseUrl);
    final isDefaultPort = (uri.scheme == 'https' && uri.port == 443) ||
        (uri.scheme == 'http' && uri.port == 80);
    return isDefaultPort
        ? '${uri.scheme}://${uri.host}'
        : '${uri.scheme}://${uri.host}:${uri.port}';
  }

  /// Resolves an avatar URL that may be absolute or relative.
  static String resolveAvatarUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final base = storageBaseUrl;
    return url.startsWith('/') ? '$base$url' : '$base/$url';
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
