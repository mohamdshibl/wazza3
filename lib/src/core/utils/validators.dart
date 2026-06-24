import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Pure, reusable form validators. No UI, no state — easy to unit test.
class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _phone = RegExp(r'^\+?[0-9\s-]{7,15}$');

  static String? email(BuildContext context, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppLocalizations.of(context)!.emailRequired;
    if (!_email.hasMatch(v)) return AppLocalizations.of(context)!.emailInvalid;
    return null;
  }

  static String? phone(BuildContext context, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppLocalizations.of(context)!.phoneRequired;
    if (!_phone.hasMatch(v)) return AppLocalizations.of(context)!.phoneInvalid;
    return null;
  }

  static String? password(BuildContext context, String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
    if (v.length < 6) return AppLocalizations.of(context)!.passwordTooShort;
    return null;
  }
}
