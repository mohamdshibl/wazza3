/// Asset path constants.
///
/// The designer's exported images should be dropped into these paths and
/// declared under `flutter > assets` in `pubspec.yaml`. Until then, the
/// widgets that consume them fall back gracefully (see `errorBuilder`s),
/// so the app stays runnable.
class AppAssets {
  AppAssets._();

  static const String _root = 'assets';

  /// Brand logo mark (vector).
  static const String logo = '$_root/logo.svg';

  /// Trucks photo used as the low-opacity header overlay.
  static const String headerBackground = '$_root/cars.png';
}
