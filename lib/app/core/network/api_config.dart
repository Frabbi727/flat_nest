enum ApiEnvironment { dev, staging, prod }

class ApiConfig {
  static ApiEnvironment environment = ApiEnvironment.dev;

  static String get baseUrl {
    switch (environment) {
      case ApiEnvironment.dev:
        return 'https://dev-api.flatnest.com';
      case ApiEnvironment.staging:
        return 'https://staging-api.flatnest.com';
      case ApiEnvironment.prod:
        return 'https://api.flatnest.com';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
