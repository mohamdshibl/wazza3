/// Environment / app-wide configuration. Real values would come from
/// `--dart-define` or a flavor config; kept minimal here.
class AppConfig {
  AppConfig._();

  static const String baseUrl = 'https://nxodoo-wazza-test-38630620.dev.odoo.com';
  static const String db = 'nxodoo-wazza-test-38630620';
  static const Duration requestTimeout = Duration(seconds: 20);
}

