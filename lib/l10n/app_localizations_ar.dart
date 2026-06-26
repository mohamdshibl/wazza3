// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Wazza3';

  @override
  String get tagline => 'مندوب مبيعات التوزيع';

  @override
  String get signInTitle => 'تسجيل الدخول';

  @override
  String get signInSubtitle => 'مرحباً بك مجدداً في Wazza3';

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
    return 'مستحق $amount';
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

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get inventoryTab => 'المخزون';

  @override
  String get walletTab => 'المحفظة';

  @override
  String get profileTab => 'الملف الشخصي';

  @override
  String get addAnotherProduct => 'إضافة منتج آخر';

  @override
  String get address => 'العنوان *';

  @override
  String get areaZone => 'المنطقة / النطاق';

  @override
  String get askForBackEntranceParkOnSideStreet =>
      'اسأل عن المدخل الخلفي. أوقف السيارة في الشارع الجانبي.';

  @override
  String get awaitingApproval => 'بانتظار الموافقة';

  @override
  String get awaitingDelivery => 'بانتظار التوصيل';

  @override
  String get back => 'رجوع';

  @override
  String get businessName => 'اسم النشاط التجاري *';

  @override
  String get customer => 'العميل';

  @override
  String get customerType => 'نوع العميل';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get collected => 'تم التحصيل';

  @override
  String get collectionProgress => 'تقدم التحصيل';

  @override
  String get collectionsWallet => 'التحصيلات والمحفظة';

  @override
  String get completeLocationVerificationAndPhotoToUnlockTheRemainingFields =>
      'أكمل التحقق من الموقع والصورة لفتح الحقول المتبقية.';

  @override
  String get completeTheChecklistToStartYourSession =>
      'أكمل القائمة لبدء جلستك';

  @override
  String get confirmQuantitiesLoaded => 'تأكيد الكميات المحملة';

  @override
  String get createSalesOrder => 'إنشاء أمر بيع';

  @override
  String get customerAdded => 'تمت إضافة العميل!';

  @override
  String get doLinesStops => 'خطوط أمر التوزيع / المحطات';

  @override
  String get downtown => 'وسط المدينة';

  @override
  String get driver => 'السائق';

  @override
  String get due => 'مستحق';

  @override
  String get financialSummary => 'الملخص المالي';

  @override
  String get finance => 'المالية';

  @override
  String get financialCustodyInvoices => 'العهدة المالية والفواتير';

  @override
  String get fullRoute => 'المسار الكامل';

  @override
  String get goodEvening => 'مساء الخير 👋';

  @override
  String get goodEvening2 => 'مساء الخير،';

  @override
  String get goodsLoadedOnYourTruck => 'البضائع المحملة على شاحنتك';

  @override
  String get goodsToDeliver => 'البضائع المراد توصيلها';

  @override
  String get handleJuiceCartonsCarefullyFragileColdChainMaintained =>
      'تعامل مع كراتين العصير بعناية - قابلة للكسر. تم الحفاظ على سلسلة التبريد.';

  @override
  String get invoices => 'الفواتير';

  @override
  String get invoice => 'فاتورة';

  @override
  String get invoiceTotal => 'إجمالي الفاتورة';

  @override
  String get loadingInProgress => 'جاري التحميل...';

  @override
  String get navigate => 'تنقل';

  @override
  String get navigateToTheStopToBegin => 'تنقل إلى المحطة للبدء';

  @override
  String get newOrderDraft => 'مسودة طلب جديد';

  @override
  String get noDetailsAvailable => 'لا تتوفر تفاصيل';

  @override
  String get noStopsCompletedYet => 'لم يتم إنجاز أي محطات بعد';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get offload => 'تفريغ';

  @override
  String get orderCreated => 'تم إنشاء الطلب!';

  @override
  String get outstanding => 'معلق';

  @override
  String get physicalCustody => 'العهدة المادية';

  @override
  String get products => 'المنتجات';

  @override
  String get paid => 'مدفوع';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get preRouteChecklist => 'قائمة التحقق قبل المسار';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get salesOrderDetails => 'تفاصيل أمر البيع';

  @override
  String get skusQuantities => 'المنتجات والكميات';

  @override
  String get step1VerifyLocation => 'الخطوة 1 — التحقق من الموقع';

  @override
  String get step2ShopPhoto => 'الخطوة 2 — صورة المتجر';

  @override
  String get saveCustomer => 'حفظ العميل';

  @override
  String get selectProduct => 'اختر منتج...';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get startDaySession => 'بدء جلسة اليوم';

  @override
  String get totalCollected => 'إجمالي المحصل';

  @override
  String get takeAPhotoOfTheShop => 'التقط صورة للمتجر';

  @override
  String get tapToCaptureCurrentLocationPhoto =>
      'انقر لالتقاط صورة للموقع الحالي';

  @override
  String get tapToSelectACustomer => 'انقر لاختيار عميل';

  @override
  String get total => 'المجموع';

  @override
  String get totalCustody => 'إجمالي العهدة';

  @override
  String get totalInvoice => 'إجمالي الفاتورة';

  @override
  String get totalInvoiced => 'إجمالي المفوتر';

  @override
  String get truckLoad => 'حمولة الشاحنة';

  @override
  String get verification => 'التحقق';

  @override
  String get verificationStepsCompletedYouCanNowFillInTheStoreDetails =>
      'اكتملت خطوات التحقق! يمكنك الآن ملء تفاصيل المتجر.';

  @override
  String get verifyCustomerLocation => 'التحقق من موقع العميل';

  @override
  String get viewDo => 'عرض أمر التوزيع';

  @override
  String get viewSalesOrderDetails => 'عرض تفاصيل أمر البيع';

  @override
  String get virtualWarehouse => 'المستودع الافتراضي';

  @override
  String get wazza3Distribution => 'WAZZA3 DISTRIBUTION';

  @override
  String get wazza3V10 => 'WAZZA3 · v1.0';

  @override
  String get warehouseIsLoadingYourTruckConfirmWhenDone =>
      'المستودع يقوم بتحميل شاحنتك. قم بالتأكيد عند الانتهاء.';

  @override
  String get goodEvening3 => 'مساء الخير';

  @override
  String get num0OfRouteCollected => '0% من المسار تم تحصيله';

  @override
  String get num2Lines116Units => '2 خطوط · 116 وحدة';

  @override
  String get num4UpcomingStops => '4 محطات قادمة';

  @override
  String get num5Skus => '5 منتجات';

  @override
  String get salesRep => 'مندوب مبيعات';

  @override
  String get idRep042 => 'المعرف: REP-042';

  @override
  String get assignedTruck => 'الشاحنة المعينة';

  @override
  String get truckA101 => 'شاحنة A-101';

  @override
  String get territory => 'المنطقة';

  @override
  String get northDistrict => 'المنطقة الشمالية';

  @override
  String get role => 'الدور';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get endSessionLogout => 'إنهاء الجلسة وتسجيل الخروج';

  @override
  String get newOrder => 'طلب جديد';

  @override
  String get newCustomer => 'عميل جديد';

  @override
  String get custody => 'العهدة';

  @override
  String get itemsOnTruck => 'عنصر على الشاحنة';

  @override
  String get stops => 'المحطات';

  @override
  String doneCount(String count) {
    return '$count منجزة';
  }

  @override
  String leftCount(String count) {
    return '$count متبقية';
  }

  @override
  String ofAmount(String amount) {
    return 'من $amount';
  }

  @override
  String cashAmount(String amount) {
    return '$amount نقداً';
  }

  @override
  String chkAmount(String amount) {
    return '$amount شيك';
  }

  @override
  String ofStopsCount(String count) {
    return 'من $count محطات';
  }

  @override
  String get upcomingTab => 'القادمة';

  @override
  String get mapTab => 'الخريطة';

  @override
  String get completedTab => 'المكتملة';

  @override
  String get available => 'متاح';

  @override
  String get availableToOffer => 'متاح للبيع';

  @override
  String valueAmount(String amount) {
    return 'بقيمة $amount';
  }

  @override
  String remainingOfLoaded(String remaining, String loaded) {
    return 'متبقي $remaining من $loaded محملة';
  }

  @override
  String get ctns => 'كرتونة';

  @override
  String get sku => 'SKU';

  @override
  String get cash => 'نقد';

  @override
  String get checks => 'شيكات';

  @override
  String get physicalNotesHeld => 'السيولة النقدية المتوفرة';

  @override
  String get checksInCustody => 'شيكات في العهدة';

  @override
  String get unpaid => 'غير مدفوع';

  @override
  String get fullyPaid => 'مدفوعة بالكامل ✓';

  @override
  String dueAmount(String amount) {
    return 'مستحقة $amount';
  }

  @override
  String collectedPercent(String percent) {
    return '$percent% تم تحصيله';
  }

  @override
  String amountCollected(String amount) {
    return '$amount تم تحصيله';
  }

  @override
  String get soNumberLabel => 'رقم أمر البيع';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get invoiceRefLabel => 'مرجع الفاتورة';

  @override
  String get checklistTruckLoaded => 'تم تحميل الشاحنة وإغلاقها';

  @override
  String get checklistRouteSheet => 'تمت مراجعة خط السير';

  @override
  String get checklistPhoneCharged => 'تم شحن الهاتف والأجهزة';

  @override
  String get checklistColdChain => 'تم التحقق من عناصر سلسلة التبريد';

  @override
  String firstStopEta(String time) {
    return 'وقت الوصول المقدر للمحطة الأولى: $time';
  }

  @override
  String get readyToStartRoute => 'هل أنت مستعد لبدء خط سير اليوم؟';

  @override
  String get todaysDo => 'أمر التوزيع اليوم';

  @override
  String get stopsLabel => 'نقاط التوقف';

  @override
  String get itemsLabel => 'العناصر';

  @override
  String get valueLabel => 'القيمة';

  @override
  String unitsLoadedCount(String count) {
    return '$count وحدة محملة';
  }

  @override
  String get mockDateShort => 'الأربعاء، ٢٤ يونيو ٢٠٢٦';

  @override
  String get loaded => 'تم التحميل';

  @override
  String get loading => 'جاري التحميل';

  @override
  String doLineCount(String line) {
    return 'أمر التوزيع ٢٠٢٥ / بند $line';
  }

  @override
  String unitsCount(String count) {
    return '$count وحدة';
  }

  @override
  String sosCount(String count) {
    return '$count أمر بيع';
  }

  @override
  String get stopAlert1 =>
      'اطلب الدخول من الباب الخلفي. توقف في الشارع الجانبي.';

  @override
  String get stopAlert2 => 'دق الجرس عند البوابة. جهة الاتصال: السيد سام.';

  @override
  String get stopAlert3 =>
      'التسليم لمدخل المطبخ. تجنب المدخل الرئيسي. اطلب الشيف ماركو.';

  @override
  String get stopAlert4 =>
      'تسليم شحنة كبيرة. الرافعة الشوكية متوفرة في الموقع. سجل الدخول عند بوابة الأمن.';

  @override
  String get quantityOffloaded => 'الكمية المفرغة';

  @override
  String get confirm => 'تأكيد';

  @override
  String offloadSuccess(String count, String itemName) {
    return 'تم تفريغ $count وحدة من $itemName بنجاح';
  }

  @override
  String etaWithTime(String time) {
    return 'وقت الوصول المقدر $time';
  }
}
