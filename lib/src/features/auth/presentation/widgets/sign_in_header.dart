import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_spacing.dart';
import '../../../../core/widgets/glow_overlay.dart';
import 'brand_logo.dart';

/// Brand hero header.
///
/// Three stacked layers (bottom → top):
///   1. Red gradient background        ([_gradient])
///   2. Decorative overlays            (radial [GlowOverlay] + low-opacity image)
///   3. Foreground content             ([BrandLogo])
///
/// Bottom-anchored & horizontally centered (CSS `items-center justify-end`).
class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  static const Decoration _gradient =
      BoxDecoration(gradient: AppColors.brandGradient);

  static const double _imageOpacity = 0.30;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _gradient,
      child: Stack(
        children: [
          // ── Layer 2a: radial glow (top-centered light) ──
          const Positioned.fill(child: GlowOverlay()),

          // ── Layer 2b: low-opacity background image ──
          Positioned.fill(
            child: Opacity(
              opacity: _imageOpacity,
              child: Image.asset(
                AppAssets.headerBackground,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Layer 3: foreground content ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxxl, // px-8
              AppSpacing.giant, // pt-12
              AppSpacing.xxxl,
              AppSpacing.huge, // pb-10
            ),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: BrandLogo(),
            ),
          ),
        ],
      ),
    );
  }
}
