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
  String get distributionOrders => 'Distribution Orders';

  @override
  String completedOrdersCount(String count) {
    return '$count completed orders';
  }

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

  @override
  String get homeTab => 'Home';

  @override
  String get inventoryTab => 'Inventory';

  @override
  String get walletTab => 'Wallet';

  @override
  String get profileTab => 'Profile';

  @override
  String get addAnotherProduct => 'Add Another Product';

  @override
  String get address => 'Address *';

  @override
  String get areaZone => 'Area / Zone';

  @override
  String get askForBackEntranceParkOnSideStreet =>
      'Ask for back entrance. Park on side street.';

  @override
  String get awaitingApproval => 'Awaiting Approval';

  @override
  String get awaitingDelivery => 'Awaiting delivery';

  @override
  String get back => 'Back';

  @override
  String get businessName => 'Business Name *';

  @override
  String get customer => 'CUSTOMER';

  @override
  String get customerType => 'CUSTOMER TYPE';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get collected => 'Collected';

  @override
  String get collectionProgress => 'Collection progress';

  @override
  String get collectionsWallet => 'Collections & Wallet';

  @override
  String get completeLocationVerificationAndPhotoToUnlockTheRemainingFields =>
      'Complete location verification and photo to unlock the remaining fields.';

  @override
  String get completeTheChecklistToStartYourSession =>
      'Complete the checklist to start your session';

  @override
  String get confirmQuantitiesLoaded => 'Confirm Quantities Loaded';

  @override
  String get createSalesOrder => 'Create Sales Order';

  @override
  String get customerAdded => 'Customer Added!';

  @override
  String get doLinesStops => 'DO Lines / Stops';

  @override
  String get downtown => 'Downtown';

  @override
  String get driver => 'Driver';

  @override
  String get due => 'Due';

  @override
  String get financialSummary => 'FINANCIAL SUMMARY';

  @override
  String get finance => 'Finance';

  @override
  String get financialCustodyInvoices => 'Financial custody & invoices';

  @override
  String get fullRoute => 'Full Route';

  @override
  String get goodEvening => 'Good Evening 👋';

  @override
  String get goodEvening2 => 'Good Evening,';

  @override
  String get goodsLoadedOnYourTruck => 'Goods loaded on your truck';

  @override
  String get goodsToDeliver => 'Goods to Deliver';

  @override
  String get handleJuiceCartonsCarefullyFragileColdChainMaintained =>
      'Handle juice cartons carefully – fragile. Cold chain maintained.';

  @override
  String get invoices => 'INVOICES';

  @override
  String get invoice => 'Invoice';

  @override
  String get invoiceTotal => 'Invoice Total';

  @override
  String get loadingInProgress => 'Loading in progress…';

  @override
  String get navigate => 'Navigate';

  @override
  String get navigateToTheStopToBegin => 'Navigate to the stop to begin';

  @override
  String get newOrderDraft => 'New Order Draft';

  @override
  String get noDetailsAvailable => 'No details available';

  @override
  String get noStopsCompletedYet => 'No stops completed yet';

  @override
  String get orderSummary => 'ORDER SUMMARY';

  @override
  String get offload => 'Offload';

  @override
  String get orderCreated => 'Order Created!';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get physicalCustody => 'PHYSICAL CUSTODY';

  @override
  String get products => 'PRODUCTS';

  @override
  String get paid => 'Paid';

  @override
  String get pending => 'Pending';

  @override
  String get preRouteChecklist => 'Pre-Route Checklist';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get salesOrderDetails => 'SALES ORDER DETAILS';

  @override
  String get skusQuantities => 'SKUS & QUANTITIES';

  @override
  String get step1VerifyLocation => 'STEP 1 — VERIFY LOCATION';

  @override
  String get step2ShopPhoto => 'STEP 2 — SHOP PHOTO';

  @override
  String get saveCustomer => 'Save Customer';

  @override
  String get selectProduct => 'Select product...';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get startDaySession => 'Start Day Session';

  @override
  String get totalCollected => 'TOTAL COLLECTED';

  @override
  String get takeAPhotoOfTheShop => 'Take a photo of the shop';

  @override
  String get tapToCaptureCurrentLocationPhoto =>
      'Tap to capture current location photo';

  @override
  String get tapToSelectACustomer => 'Tap to select a customer';

  @override
  String get total => 'Total';

  @override
  String get totalCustody => 'Total Custody';

  @override
  String get totalInvoice => 'Total Invoice';

  @override
  String get totalInvoiced => 'Total Invoiced';

  @override
  String get truckLoad => 'Truck Load';

  @override
  String get verification => 'Verification';

  @override
  String get verificationStepsCompletedYouCanNowFillInTheStoreDetails =>
      'Verification steps completed! You can now fill in the store details.';

  @override
  String get verifyCustomerLocation => 'Verify Customer Location';

  @override
  String get viewDo => 'View DO';

  @override
  String get viewSalesOrderDetails => 'View Sales Order Details';

  @override
  String get virtualWarehouse => 'Virtual Warehouse';

  @override
  String get wazza3Distribution => 'WAZZA3 DISTRIBUTION';

  @override
  String get wazza3V10 => 'WAZZA3 · v1.0';

  @override
  String get warehouseIsLoadingYourTruckConfirmWhenDone =>
      'Warehouse is loading your truck. Confirm when done.';

  @override
  String get goodEvening3 => 'Good Evening';

  @override
  String get num0OfRouteCollected => '0% of route collected';

  @override
  String get num2Lines116Units => '2 lines · 116 units';

  @override
  String get num4UpcomingStops => '4 upcoming stops';

  @override
  String get num5Skus => '5 SKUs';

  @override
  String get salesRep => 'Sales Rep';

  @override
  String get idRep042 => 'ID: REP-042';

  @override
  String get assignedTruck => 'Assigned Truck';

  @override
  String get truckA101 => 'Truck A-101';

  @override
  String get territory => 'Territory';

  @override
  String get northDistrict => 'North District';

  @override
  String get role => 'Role';

  @override
  String get appSettings => 'App Settings';

  @override
  String get endSessionLogout => 'End Session & Logout';

  @override
  String get newOrder => 'New Order';

  @override
  String get newCustomer => 'New Customer';

  @override
  String get custody => 'Custody';

  @override
  String get itemsOnTruck => 'items on truck';

  @override
  String get stops => 'Stops';

  @override
  String doneCount(String count) {
    return '$count done';
  }

  @override
  String leftCount(String count) {
    return '$count left';
  }

  @override
  String ofAmount(String amount) {
    return 'of $amount';
  }

  @override
  String cashAmount(String amount) {
    return '$amount cash';
  }

  @override
  String chkAmount(String amount) {
    return '$amount chk';
  }

  @override
  String ofStopsCount(String count) {
    return 'of $count stops';
  }

  @override
  String get upcomingTab => 'Upcoming';

  @override
  String get mapTab => 'Map';

  @override
  String get completedTab => 'Completed';

  @override
  String get available => 'Available';

  @override
  String get availableToOffer => 'Available to Offer';

  @override
  String valueAmount(String amount) {
    return '$amount value';
  }

  @override
  String remainingOfLoaded(String remaining, String loaded) {
    return '$remaining remaining of $loaded loaded';
  }

  @override
  String get ctns => 'Ctns';

  @override
  String get sku => 'SKU';

  @override
  String get cash => 'Cash';

  @override
  String get checks => 'Checks';

  @override
  String get physicalNotesHeld => 'Physical notes held';

  @override
  String get checksInCustody => 'Checks in custody';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get fullyPaid => 'Fully paid ✓';

  @override
  String dueAmount(String amount) {
    return 'Due $amount';
  }

  @override
  String collectedPercent(String percent) {
    return '$percent% collected';
  }

  @override
  String amountCollected(String amount) {
    return '$amount collected';
  }

  @override
  String get soNumberLabel => 'SO NUMBER';

  @override
  String get dateLabel => 'DATE';

  @override
  String get statusLabel => 'STATUS';

  @override
  String get invoiceRefLabel => 'INVOICE REF';

  @override
  String get checklistTruckLoaded => 'Truck loaded and sealed';

  @override
  String get checklistRouteSheet => 'Route sheet reviewed';

  @override
  String get checklistPhoneCharged => 'Phone & devices charged';

  @override
  String get checklistColdChain => 'Cold chain items checked';

  @override
  String firstStopEta(String time) {
    return 'First stop ETA: $time';
  }

  @override
  String get readyToStartRoute => 'Ready to start your day\'s route?';

  @override
  String get todaysDo => 'Today\'s distribution order';

  @override
  String get stopsLabel => 'Stops';

  @override
  String get itemsLabel => 'Items';

  @override
  String get valueLabel => 'Value';

  @override
  String unitsLoadedCount(String count) {
    return '$count units loaded';
  }

  @override
  String get mockDateShort => 'Wednesday, Jun 24, 2026';

  @override
  String get loaded => 'Loaded';

  @override
  String get loading => 'Loading';

  @override
  String doLineCount(String line) {
    return 'DO-2025 / Line $line';
  }

  @override
  String unitsCount(String count) {
    return '$count units';
  }

  @override
  String sosCount(String count) {
    return '$count SOs';
  }

  @override
  String get stopAlert1 => 'Ask for back entrance. Park on side street.';

  @override
  String get stopAlert2 => 'Ring bell at gate. Contact: Mr. Sam.';

  @override
  String get stopAlert3 =>
      'Deliver to kitchen entrance. Avoid main entrance. Ask for Chef Marco.';

  @override
  String get stopAlert4 =>
      'Large delivery. Forklift available on site. Check in at security gate.';

  @override
  String get quantityOffloaded => 'Quantity Offloaded';

  @override
  String get confirm => 'Confirm';

  @override
  String offloadSuccess(String count, String itemName) {
    return 'Successfully offloaded $count units of $itemName';
  }

  @override
  String etaWithTime(String time) {
    return 'ETA $time';
  }

  @override
  String get view => 'View';
}
