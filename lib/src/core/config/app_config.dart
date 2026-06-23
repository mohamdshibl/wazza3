/// Environment / app-wide configuration. Real values would come from
/// `--dart-define` or a flavor config; kept minimal here.
class AppConfig {
  AppConfig._();

  static const String baseUrl = 'https://api.wazza3.example';
  static const Duration requestTimeout = Duration(seconds: 20);
}
