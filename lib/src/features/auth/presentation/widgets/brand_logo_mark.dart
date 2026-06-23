import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';

/// The Wazza3 vector logo mark.
///
/// Renders the SVG at its design aspect ratio (565×408 → 180×130). The SVG
/// scales crisply at any size; defaults match the original header.
class BrandLogoMark extends StatelessWidget {
  const BrandLogoMark({
    super.key,
    this.width = 180,
    this.height = 130,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logo,
      width: width,
      height: height,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => SizedBox(width: width, height: height),
    );
  }
}
