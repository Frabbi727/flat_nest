enum ApiEnvironment { dev, staging, prod }

class ApiConfig {
  static ApiEnvironment environment = ApiEnvironment.dev;

  static String get baseUrl {
    switch (environment) {
      case ApiEnvironment.dev:
      return 'http://10.44.66.202:8000/api/v1'; // Office
     //   return 'http://10.144.25.202:8000/api/v1';
       //  return 'http://92.168.0.108:8000/api/v1';
      case ApiEnvironment.staging:
        return 'http://10.144.25.202:8000/api/v1';
      case ApiEnvironment.prod:
        return 'http://10.144.25.202:8000/api/v1';
    }
  }

  // Origin only (no /api/v1) — used to resolve relative storage URLs
  static String get storageBaseUrl {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
