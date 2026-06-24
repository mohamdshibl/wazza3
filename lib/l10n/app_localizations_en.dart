// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Wazza3';

  @override
  String get tagline => 'Distribution Sales Rep';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInSubtitle => 'Welcome back to Wazza3';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get emailLabel => 'EMAIL ADDRESS';

  @override
  String get phoneLabel => 'PHONE NUMBER';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get phoneHint => '+20 100 000 0000';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signInCta => 'Sign In';

  @override
  String get mobileNumberLabel => 'MOBILE NUMBER';

  @override
  String get mobileNumberHint => '5X XXX XXXX';

  @override
  String get otpHelper => 'An OTP will be sent to verify your number';

  @override
  String get sendOtpCta => 'Send OTP';

  @override
  String get termsSignIn => 'By signing in you agree to the Terms of Service';

  @override
  String get termsContinue => 'By continuing you agree to the Terms of Service';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Enter a valid phone number';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get addNewCustomer => 'Add New Customer';

  @override
  String get typeLabel => 'Type:';

  @override
  String get retail => 'Retail';

  @override
  String get horeca => 'Horeca';

  @override
  String get wholesale => 'Wholesale';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get todaysRoute => 'Today\'s Route';

  @override
  String get viewAll => 'View All';

  @override
  String viewAllUpcomingStops(int count) {
    return 'View all $count upcoming stops →';
  }

  @override
  String units(String count) {
    return '$count units';
  }

  @override
  String amountDue(String amount) {
    return '$amount due';
  }

  @override
  String get previousOrders => 'Previous Orders';

  @override
  String get viewMore => 'View more';

  @override
  String get done => 'Done';

  @override
  String get quantitiesLoaded => 'Quantities loaded successfully!';

  @override
  String get phoneVerified => 'Phone number verified successfully!';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String resetLinkSent(String email) {
    return 'Reset link sent to $email';
  }
}
