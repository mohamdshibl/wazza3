import 'package:flutter/material.dart';

import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/orders/presentation/new_order_draft_screen.dart';
import '../../features/customers/presentation/add_customer_screen.dart';
import 'app_routes.dart';

/// Centralized route generation. Swap for go_router as the app grows.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
      case AppRoutes.otpVerification:
        final phoneNumber = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phoneNumber),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DriverDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.newOrderDraft:
        return MaterialPageRoute(
          builder: (_) => const NewOrderDraftScreen(),
          settings: settings,
        );
      case AppRoutes.addCustomer:
        return MaterialPageRoute(
          builder: (_) => const AddCustomerScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
    }
  }
}
