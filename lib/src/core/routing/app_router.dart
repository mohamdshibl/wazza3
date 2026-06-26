import 'package:flutter/material.dart';

import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/orders/presentation/new_order_draft_screen.dart';
import '../../features/customers/presentation/add_customer_screen.dart';
import '../../features/home/presentation/stop_details_screen.dart';
import '../../features/home/presentation/sales_order_details_screen.dart';
import '../../features/home/presentation/session_start_screen.dart';
import '../../features/home/presentation/do_details_screen.dart';
import '../../features/home/presentation/widgets/home_view.dart';
import '../../features/home/presentation/previous_orders_screen.dart';
import '../../features/home/presentation/completed_do_details_screen.dart';
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
      case AppRoutes.resetPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
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
      case AppRoutes.stopDetails:
        final stopData = settings.arguments as StopData;
        return MaterialPageRoute(
          builder: (_) => StopDetailsScreen(stopData: stopData),
          settings: settings,
        );
      case AppRoutes.salesOrderDetails:
        final stopData = settings.arguments as StopData;
        return MaterialPageRoute(
          builder: (_) => SalesOrderDetailsScreen(stopData: stopData),
          settings: settings,
        );
      case AppRoutes.sessionStart:
        return MaterialPageRoute(
          builder: (_) => const SessionStartScreen(),
          settings: settings,
        );
      case AppRoutes.doDetails:
        return MaterialPageRoute(
          builder: (_) => const DoDetailsScreen(),
          settings: settings,
        );
      case AppRoutes.previousOrders:
        return MaterialPageRoute(
          builder: (_) => const PreviousOrdersScreen(),
          settings: settings,
        );
      case AppRoutes.completedDoDetails:
        return MaterialPageRoute(
          builder: (_) => const CompletedDoDetailsScreen(),
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
