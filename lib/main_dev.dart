import 'app/core/network/api_config.dart';
import 'main.dart' as app;

void main() {
  ApiConfig.environment = ApiEnvironment.dev;
  app.main();
}
