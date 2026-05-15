enum ApiEnvironment { dev, staging, prod }

class ApiConfig {
  static ApiEnvironment environment = ApiEnvironment.dev;

  static String get baseUrl {
    switch (environment) {
      case ApiEnvironment.dev:
        return 'http://192.168.0.108:8000/api/v1';
      case ApiEnvironment.staging:
        return 'http://192.168.0.108:8000/api/v1';
      case ApiEnvironment.prod:
        return 'http://192.168.0.108:8000/api/v1';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
