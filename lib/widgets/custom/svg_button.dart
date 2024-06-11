import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  const SvgButton({
    super.key,
    this.fit = BoxFit.cover,
    required this.imagePath,
    this.width,
    this.height,
    required this.onTap,
    this.padding = EdgeInsets.zero,
  });

  final String imagePath;
  final BoxFit fit;
  final double? width;
  final EdgeInsets padding;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          imagePath,
          fit: fit,
          width: width,
        ),
      ),
    );
  }
}
