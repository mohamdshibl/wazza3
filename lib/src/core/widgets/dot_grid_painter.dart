import 'package:flutter/material.dart';

/// A custom painter that draws a subtle dot grid overlay for gradient headers.
class DotGridPainter extends CustomPainter {
  const DotGridPainter({this.dotColor = const Color(0x12FFFFFF), this.spacing = 20.0});

  final Color dotColor;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotGridPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor || oldDelegate.spacing != spacing;
  }
}
