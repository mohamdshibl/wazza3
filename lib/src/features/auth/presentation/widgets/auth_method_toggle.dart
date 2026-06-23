import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_cubit.dart';

/// Email / Phone selector wired to the Cubit. Thin adapter over the
/// reusable [SegmentedToggle].
class AuthMethodToggle extends StatelessWidget {
  const AuthMethodToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final method = context.watch<SignInCubit>().state.method;

    return SegmentedToggle<AuthMethod>(
      selected: method,
      onChanged: (val) => context.read<SignInCubit>().selectMethod(val),
      items: const [
        SegmentedItem(value: AuthMethod.email, label: AppStrings.email),
        SegmentedItem(value: AuthMethod.phone, label: AppStrings.phone),
      ],
    );
  }
}
