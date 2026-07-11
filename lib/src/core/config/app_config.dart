/// Environment / app-wide configuration. Real values would come from
/// `--dart-define` or a flavor config; kept minimal here.
class AppConfig {
  AppConfig._();

  static const String baseUrl = 'https://nxodoo-dms-test-33973661.dev.odoo.com';
  static const String db = 'nxodoo-dms-test-33973661';
  static const Duration requestTimeout = Duration(seconds: 20);
}
