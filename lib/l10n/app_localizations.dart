import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Wazza3'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Distribution Sales Rep'**
  String get tagline;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Wazza3'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'PHONE NUMBER'**
  String get phoneLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+20 100 000 0000'**
  String get phoneHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signInCta.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInCta;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'MOBILE NUMBER'**
  String get mobileNumberLabel;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'5X XXX XXXX'**
  String get mobileNumberHint;

  /// No description provided for @otpHelper.
  ///
  /// In en, this message translates to:
  /// **'An OTP will be sent to verify your number'**
  String get otpHelper;

  /// No description provided for @sendOtpCta.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtpCta;

  /// No description provided for @termsSignIn.
  ///
  /// In en, this message translates to:
  /// **'By signing in you agree to the Terms of Service'**
  String get termsSignIn;

  /// No description provided for @termsContinue.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Terms of Service'**
  String get termsContinue;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @addNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get addNewCustomer;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get typeLabel;

  /// No description provided for @retail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get retail;

  /// No description provided for @horeca.
  ///
  /// In en, this message translates to:
  /// **'Horeca'**
  String get horeca;

  /// No description provided for @wholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get wholesale;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @todaysRoute.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Route'**
  String get todaysRoute;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewAllUpcomingStops.
  ///
  /// In en, this message translates to:
  /// **'View all {count} upcoming stops →'**
  String viewAllUpcomingStops(int count);

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String units(String count);

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String amountDue(String amount);

  /// No description provided for @previousOrders.
  ///
  /// In en, this message translates to:
  /// **'Previous Orders'**
  String get previousOrders;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get viewMore;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @quantitiesLoaded.
  ///
  /// In en, this message translates to:
  /// **'Quantities loaded successfully!'**
  String get quantitiesLoaded;

  /// No description provided for @phoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully!'**
  String get phoneVerified;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to {email}'**
  String resetLinkSent(String email);

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @inventoryTab.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTab;

  /// No description provided for @walletTab.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @addAnotherProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Another Product'**
  String get addAnotherProduct;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address *'**
  String get address;

  /// No description provided for @areaZone.
  ///
  /// In en, this message translates to:
  /// **'Area / Zone'**
  String get areaZone;

  /// No description provided for @askForBackEntranceParkOnSideStreet.
  ///
  /// In en, this message translates to:
  /// **'Ask for back entrance. Park on side street.'**
  String get askForBackEntranceParkOnSideStreet;

  /// No description provided for @awaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Approval'**
  String get awaitingApproval;

  /// No description provided for @awaitingDelivery.
  ///
  /// In en, this message translates to:
  /// **'Awaiting delivery'**
  String get awaitingDelivery;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name *'**
  String get businessName;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER'**
  String get customer;

  /// No description provided for @customerType.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER TYPE'**
  String get customerType;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @collectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Collection progress'**
  String get collectionProgress;

  /// No description provided for @collectionsWallet.
  ///
  /// In en, this message translates to:
  /// **'Collections & Wallet'**
  String get collectionsWallet;

  /// No description provided for @completeLocationVerificationAndPhotoToUnlockTheRemainingFields.
  ///
  /// In en, this message translates to:
  /// **'Complete location verification and photo to unlock the remaining fields.'**
  String get completeLocationVerificationAndPhotoToUnlockTheRemainingFields;

  /// No description provided for @completeTheChecklistToStartYourSession.
  ///
  /// In en, this message translates to:
  /// **'Complete the checklist to start your session'**
  String get completeTheChecklistToStartYourSession;

  /// No description provided for @confirmQuantitiesLoaded.
  ///
  /// In en, this message translates to:
  /// **'Confirm Quantities Loaded'**
  String get confirmQuantitiesLoaded;

  /// No description provided for @createSalesOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Sales Order'**
  String get createSalesOrder;

  /// No description provided for @customerAdded.
  ///
  /// In en, this message translates to:
  /// **'Customer Added!'**
  String get customerAdded;

  /// No description provided for @doLinesStops.
  ///
  /// In en, this message translates to:
  /// **'DO Lines / Stops'**
  String get doLinesStops;

  /// No description provided for @downtown.
  ///
  /// In en, this message translates to:
  /// **'Downtown'**
  String get downtown;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'FINANCIAL SUMMARY'**
  String get financialSummary;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @financialCustodyInvoices.
  ///
  /// In en, this message translates to:
  /// **'Financial custody & invoices'**
  String get financialCustodyInvoices;

  /// No description provided for @fullRoute.
  ///
  /// In en, this message translates to:
  /// **'Full Route'**
  String get fullRoute;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening 👋'**
  String get goodEvening;

  /// No description provided for @goodEvening2.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get goodEvening2;

  /// No description provided for @goodsLoadedOnYourTruck.
  ///
  /// In en, this message translates to:
  /// **'Goods loaded on your truck'**
  String get goodsLoadedOnYourTruck;

  /// No description provided for @goodsToDeliver.
  ///
  /// In en, this message translates to:
  /// **'Goods to Deliver'**
  String get goodsToDeliver;

  /// No description provided for @handleJuiceCartonsCarefullyFragileColdChainMaintained.
  ///
  /// In en, this message translates to:
  /// **'Handle juice cartons carefully – fragile. Cold chain maintained.'**
  String get handleJuiceCartonsCarefullyFragileColdChainMaintained;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'INVOICES'**
  String get invoices;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @invoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Invoice Total'**
  String get invoiceTotal;

  /// No description provided for @loadingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Loading in progress…'**
  String get loadingInProgress;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @navigateToTheStopToBegin.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the stop to begin'**
  String get navigateToTheStopToBegin;

  /// No description provided for @newOrderDraft.
  ///
  /// In en, this message translates to:
  /// **'New Order Draft'**
  String get newOrderDraft;

  /// No description provided for @noDetailsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No details available'**
  String get noDetailsAvailable;

  /// No description provided for @noStopsCompletedYet.
  ///
  /// In en, this message translates to:
  /// **'No stops completed yet'**
  String get noStopsCompletedYet;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'ORDER SUMMARY'**
  String get orderSummary;

  /// No description provided for @offload.
  ///
  /// In en, this message translates to:
  /// **'Offload'**
  String get offload;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order Created!'**
  String get orderCreated;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @physicalCustody.
  ///
  /// In en, this message translates to:
  /// **'PHYSICAL CUSTODY'**
  String get physicalCustody;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTS'**
  String get products;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @preRouteChecklist.
  ///
  /// In en, this message translates to:
  /// **'Pre-Route Checklist'**
  String get preRouteChecklist;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @salesOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'SALES ORDER DETAILS'**
  String get salesOrderDetails;

  /// No description provided for @skusQuantities.
  ///
  /// In en, this message translates to:
  /// **'SKUS & QUANTITIES'**
  String get skusQuantities;

  /// No description provided for @step1VerifyLocation.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 — VERIFY LOCATION'**
  String get step1VerifyLocation;

  /// No description provided for @step2ShopPhoto.
  ///
  /// In en, this message translates to:
  /// **'STEP 2 — SHOP PHOTO'**
  String get step2ShopPhoto;

  /// No description provided for @saveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get saveCustomer;

  /// No description provided for @selectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select product...'**
  String get selectProduct;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @startDaySession.
  ///
  /// In en, this message translates to:
  /// **'Start Day Session'**
  String get startDaySession;

  /// No description provided for @totalCollected.
  ///
  /// In en, this message translates to:
  /// **'TOTAL COLLECTED'**
  String get totalCollected;

  /// No description provided for @takeAPhotoOfTheShop.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the shop'**
  String get takeAPhotoOfTheShop;

  /// No description provided for @tapToCaptureCurrentLocationPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture current location photo'**
  String get tapToCaptureCurrentLocationPhoto;

  /// No description provided for @tapToSelectACustomer.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a customer'**
  String get tapToSelectACustomer;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalCustody.
  ///
  /// In en, this message translates to:
  /// **'Total Custody'**
  String get totalCustody;

  /// No description provided for @totalInvoice.
  ///
  /// In en, this message translates to:
  /// **'Total Invoice'**
  String get totalInvoice;

  /// No description provided for @totalInvoiced.
  ///
  /// In en, this message translates to:
  /// **'Total Invoiced'**
  String get totalInvoiced;

  /// No description provided for @truckLoad.
  ///
  /// In en, this message translates to:
  /// **'Truck Load'**
  String get truckLoad;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @verificationStepsCompletedYouCanNowFillInTheStoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Verification steps completed! You can now fill in the store details.'**
  String get verificationStepsCompletedYouCanNowFillInTheStoreDetails;

  /// No description provided for @verifyCustomerLocation.
  ///
  /// In en, this message translates to:
  /// **'Verify Customer Location'**
  String get verifyCustomerLocation;

  /// No description provided for @viewDo.
  ///
  /// In en, this message translates to:
  /// **'View DO'**
  String get viewDo;

  /// No description provided for @viewSalesOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'View Sales Order Details'**
  String get viewSalesOrderDetails;

  /// No description provided for @virtualWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Virtual Warehouse'**
  String get virtualWarehouse;

  /// No description provided for @wazza3Distribution.
  ///
  /// In en, this message translates to:
  /// **'WAZZA3 DISTRIBUTION'**
  String get wazza3Distribution;

  /// No description provided for @wazza3V10.
  ///
  /// In en, this message translates to:
  /// **'WAZZA3 · v1.0'**
  String get wazza3V10;

  /// No description provided for @warehouseIsLoadingYourTruckConfirmWhenDone.
  ///
  /// In en, this message translates to:
  /// **'Warehouse is loading your truck. Confirm when done.'**
  String get warehouseIsLoadingYourTruckConfirmWhenDone;

  /// No description provided for @goodEvening3.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening3;

  /// No description provided for @num0OfRouteCollected.
  ///
  /// In en, this message translates to:
  /// **'0% of route collected'**
  String get num0OfRouteCollected;

  /// No description provided for @num2Lines116Units.
  ///
  /// In en, this message translates to:
  /// **'2 lines · 116 units'**
  String get num2Lines116Units;

  /// No description provided for @num4UpcomingStops.
  ///
  /// In en, this message translates to:
  /// **'4 upcoming stops'**
  String get num4UpcomingStops;

  /// No description provided for @num5Skus.
  ///
  /// In en, this message translates to:
  /// **'5 SKUs'**
  String get num5Skus;

  /// No description provided for @salesRep.
  ///
  /// In en, this message translates to:
  /// **'Sales Rep'**
  String get salesRep;

  /// No description provided for @idRep042.
  ///
  /// In en, this message translates to:
  /// **'ID: REP-042'**
  String get idRep042;

  /// No description provided for @assignedTruck.
  ///
  /// In en, this message translates to:
  /// **'Assigned Truck'**
  String get assignedTruck;

  /// No description provided for @truckA101.
  ///
  /// In en, this message translates to:
  /// **'Truck A-101'**
  String get truckA101;

  /// No description provided for @territory.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get territory;

  /// No description provided for @northDistrict.
  ///
  /// In en, this message translates to:
  /// **'North District'**
  String get northDistrict;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @endSessionLogout.
  ///
  /// In en, this message translates to:
  /// **'End Session & Logout'**
  String get endSessionLogout;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get newCustomer;

  /// No description provided for @custody.
  ///
  /// In en, this message translates to:
  /// **'Custody'**
  String get custody;

  /// No description provided for @itemsOnTruck.
  ///
  /// In en, this message translates to:
  /// **'items on truck'**
  String get itemsOnTruck;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @doneCount.
  ///
  /// In en, this message translates to:
  /// **'{count} done'**
  String doneCount(String count);

  /// No description provided for @leftCount.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String leftCount(String count);

  /// No description provided for @ofAmount.
  ///
  /// In en, this message translates to:
  /// **'of {amount}'**
  String ofAmount(String amount);

  /// No description provided for @cashAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} cash'**
  String cashAmount(String amount);

  /// No description provided for @chkAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} chk'**
  String chkAmount(String amount);

  /// No description provided for @ofStopsCount.
  ///
  /// In en, this message translates to:
  /// **'of {count} stops'**
  String ofStopsCount(String count);

  /// No description provided for @upcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingTab;

  /// No description provided for @mapTab.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTab;

  /// No description provided for @completedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTab;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @availableToOffer.
  ///
  /// In en, this message translates to:
  /// **'Available to Offer'**
  String get availableToOffer;

  /// No description provided for @valueAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} value'**
  String valueAmount(String amount);

  /// No description provided for @remainingOfLoaded.
  ///
  /// In en, this message translates to:
  /// **'{remaining} remaining of {loaded} loaded'**
  String remainingOfLoaded(String remaining, String loaded);

  /// No description provided for @ctns.
  ///
  /// In en, this message translates to:
  /// **'Ctns'**
  String get ctns;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get sku;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @checks.
  ///
  /// In en, this message translates to:
  /// **'Checks'**
  String get checks;

  /// No description provided for @physicalNotesHeld.
  ///
  /// In en, this message translates to:
  /// **'Physical notes held'**
  String get physicalNotesHeld;

  /// No description provided for @checksInCustody.
  ///
  /// In en, this message translates to:
  /// **'Checks in custody'**
  String get checksInCustody;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @fullyPaid.
  ///
  /// In en, this message translates to:
  /// **'Fully paid ✓'**
  String get fullyPaid;

  /// No description provided for @dueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due {amount}'**
  String dueAmount(String amount);

  /// No description provided for @collectedPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% collected'**
  String collectedPercent(String percent);

  /// No description provided for @amountCollected.
  ///
  /// In en, this message translates to:
  /// **'{amount} collected'**
  String amountCollected(String amount);

  /// No description provided for @soNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'SO NUMBER'**
  String get soNumberLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'DATE'**
  String get dateLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusLabel;

  /// No description provided for @invoiceRefLabel.
  ///
  /// In en, this message translates to:
  /// **'INVOICE REF'**
  String get invoiceRefLabel;

  /// No description provided for @checklistTruckLoaded.
  ///
  /// In en, this message translates to:
  /// **'Truck loaded and sealed'**
  String get checklistTruckLoaded;

  /// No description provided for @checklistRouteSheet.
  ///
  /// In en, this message translates to:
  /// **'Route sheet reviewed'**
  String get checklistRouteSheet;

  /// No description provided for @checklistPhoneCharged.
  ///
  /// In en, this message translates to:
  /// **'Phone & devices charged'**
  String get checklistPhoneCharged;

  /// No description provided for @checklistColdChain.
  ///
  /// In en, this message translates to:
  /// **'Cold chain items checked'**
  String get checklistColdChain;

  /// No description provided for @firstStopEta.
  ///
  /// In en, this message translates to:
  /// **'First stop ETA: {time}'**
  String firstStopEta(String time);

  /// No description provided for @readyToStartRoute.
  ///
  /// In en, this message translates to:
  /// **'Ready to start your day\'s route?'**
  String get readyToStartRoute;

  /// No description provided for @todaysDo.
  ///
  /// In en, this message translates to:
  /// **'Today\'s distribution order'**
  String get todaysDo;

  /// No description provided for @stopsLabel.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stopsLabel;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @valueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueLabel;

  /// No description provided for @unitsLoadedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} units loaded'**
  String unitsLoadedCount(String count);

  /// No description provided for @mockDateShort.
  ///
  /// In en, this message translates to:
  /// **'Wednesday, Jun 24, 2026'**
  String get mockDateShort;

  /// No description provided for @loaded.
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get loaded;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @doLineCount.
  ///
  /// In en, this message translates to:
  /// **'DO-2025 / Line {line}'**
  String doLineCount(String line);

  /// No description provided for @unitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String unitsCount(String count);

  /// No description provided for @sosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} SOs'**
  String sosCount(String count);

  /// No description provided for @stopAlert1.
  ///
  /// In en, this message translates to:
  /// **'Ask for back entrance. Park on side street.'**
  String get stopAlert1;

  /// No description provided for @stopAlert2.
  ///
  /// In en, this message translates to:
  /// **'Ring bell at gate. Contact: Mr. Sam.'**
  String get stopAlert2;

  /// No description provided for @stopAlert3.
  ///
  /// In en, this message translates to:
  /// **'Deliver to kitchen entrance. Avoid main entrance. Ask for Chef Marco.'**
  String get stopAlert3;

  /// No description provided for @stopAlert4.
  ///
  /// In en, this message translates to:
  /// **'Large delivery. Forklift available on site. Check in at security gate.'**
  String get stopAlert4;

  /// No description provided for @quantityOffloaded.
  ///
  /// In en, this message translates to:
  /// **'Quantity Offloaded'**
  String get quantityOffloaded;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @offloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully offloaded {count} units of {itemName}'**
  String offloadSuccess(String count, String itemName);

  /// No description provided for @etaWithTime.
  ///
  /// In en, this message translates to:
  /// **'ETA {time}'**
  String etaWithTime(String time);

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
