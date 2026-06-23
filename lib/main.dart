import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/core/constants/app_strings.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/routing/app_routes.dart';
import 'src/core/style/app_theme.dart';
import 'src/features/auth/logic/controllers/auth_cubit.dart';

void main() {
  runApp(const Wazza3App());
}

class Wazza3App extends StatelessWidget {
  const Wazza3App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
