/// UI copy in one place (i18n-ready: swap for a localization layer later).
class AppStrings {
  AppStrings._();

  static const String appName = 'Wazza3';
  static const String tagline = 'Distribution Sales Rep';

  // Sign in
  static const String signInTitle = 'Sign in';
  static const String signInSubtitle = 'Welcome back to Wazza3';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String emailLabel = 'EMAIL ADDRESS';
  static const String phoneLabel = 'PHONE NUMBER';
  static const String emailHint = 'you@example.com';
  static const String phoneHint = '+20 100 000 0000';
  static const String passwordLabel = 'PASSWORD';
  static const String passwordHint = '••••••••';
  static const String forgotPassword = 'Forgot password?';
  static const String signInCta = 'Sign In';

  // Phone / OTP flow
  static const String mobileNumberLabel = 'MOBILE NUMBER';
  static const String mobileNumberHint = '5X XXX XXXX';
  static const String otpHelper = 'An OTP will be sent to verify your number';
  static const String sendOtpCta = 'Send OTP';

  // Footer (varies by method)
  static const String termsSignIn =
      'By signing in you agree to the Terms of Service';
  static const String termsContinue =
      'By continuing you agree to the Terms of Service';

  // Validation
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email address';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Enter a valid phone number';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // Errors
  static const String genericError = 'Something went wrong. Please try again.';
}
