import 'package:flutter/material.dart';

/// A non-interactive radial light glow, typically used as a decorative
/// overlay on a colored surface (mirrors CSS `radial-gradient`).
///
/// Reusable across any hero/header. Wrap in [Positioned.fill] inside a
/// [Stack]. Marked `const` so it never triggers a rebuild on its own.
class GlowOverlay extends StatelessWidget {
  const GlowOverlay({
    super.key,
    this.color = Colors.white,
    this.center = Alignment.topCenter,
    this.intensity = 0.15,
    this.radius = 1.0,
    this.fadeStop = 0.65,
  });

  /// Glow color (alpha is applied via [intensity]).
  final Color color;

  /// Origin of the glow (`at 50% 0%` → [Alignment.topCenter]).
  final AlignmentGeometry center;

  /// Peak opacity at the [center].
  final double intensity;

  /// Radial gradient radius.
  final double radius;

  /// Stop at which the glow fully fades to transparent.
  final double fadeStop;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: center,
            radius: radius,
            colors: [
              color.withValues(alpha: intensity),
              color.withValues(alpha: 0),
            ],
            stops: [0.0, fadeStop],
          ),
        ),
      ),
    );
  }
}
