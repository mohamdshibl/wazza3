// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'وزع';

  @override
  String get tagline => 'مندوب مبيعات التوزيع';

  @override
  String get signInTitle => 'تسجيل الدخول';

  @override
  String get signInSubtitle => 'مرحباً بك مجدداً في وزع';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get emailLabel => 'عنوان البريد الإلكتروني';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get phoneHint => '+20 100 000 0000';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signInCta => 'تسجيل الدخول';

  @override
  String get mobileNumberLabel => 'رقم الجوال';

  @override
  String get mobileNumberHint => '5X XXX XXXX';

  @override
  String get otpHelper => 'سيتم إرسال رمز تحقق لتأكيد رقمك';

  @override
  String get sendOtpCta => 'إرسال رمز التحقق';

  @override
  String get termsSignIn => 'بتسجيل الدخول، أنت توافق على شروط الخدمة';

  @override
  String get termsContinue => 'بالمتابعة، أنت توافق على شروط الخدمة';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريد إلكتروني صحيح';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get phoneInvalid => 'أدخل رقم هاتف صحيح';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get genericError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get addNewCustomer => 'إضافة عميل جديد';

  @override
  String get typeLabel => 'النوع:';

  @override
  String get retail => 'تجزئة';

  @override
  String get horeca => 'هوريكا';

  @override
  String get wholesale => 'جملة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get todaysRoute => 'مسار اليوم';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String viewAllUpcomingStops(int count) {
    return 'عرض جميع المحطات القادمة ($count) →';
  }

  @override
  String units(String count) {
    return '$count وحدة';
  }

  @override
  String amountDue(String amount) {
    return '$amount مستحقة';
  }

  @override
  String get previousOrders => 'الطلبات السابقة';

  @override
  String get viewMore => 'عرض المزيد';

  @override
  String get done => 'تم';

  @override
  String get quantitiesLoaded => 'تم تحميل الكميات بنجاح!';

  @override
  String get phoneVerified => 'تم التحقق من رقم الهاتف بنجاح!';

  @override
  String get enterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String resetLinkSent(String email) {
    return 'تم إرسال رابط إعادة التعيين إلى $email';
  }
}
