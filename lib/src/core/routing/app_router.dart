import 'package:flutter/material.dart';

import '../../features/auth/presentation/sign_in_screen.dart';
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
      default:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
    }
  }
}
