import '../constants/app_strings.dart';

/// Pure, reusable form validators. No UI, no state — easy to unit test.
class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _phone = RegExp(r'^\+?[0-9\s-]{7,15}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppStrings.emailRequired;
    if (!_email.hasMatch(v)) return AppStrings.emailInvalid;
    return null;
  }

  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppStrings.phoneRequired;
    if (!_phone.hasMatch(v)) return AppStrings.phoneInvalid;
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AppStrings.passwordRequired;
    if (v.length < 6) return AppStrings.passwordTooShort;
    return null;
  }
}
