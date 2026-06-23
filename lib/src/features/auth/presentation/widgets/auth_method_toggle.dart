import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_controller.dart';

/// Email / Phone selector wired to the controller. Thin adapter over the
/// reusable [SegmentedToggle].
class AuthMethodToggle extends ConsumerWidget {
  const AuthMethodToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(
      signInControllerProvider.select((s) => s.method),
    );

    return SegmentedToggle<AuthMethod>(
      selected: method,
      onChanged: ref.read(signInControllerProvider.notifier).selectMethod,
      items: const [
        SegmentedItem(value: AuthMethod.email, label: AppStrings.email),
        SegmentedItem(value: AuthMethod.phone, label: AppStrings.phone),
      ],
    );
  }
}
