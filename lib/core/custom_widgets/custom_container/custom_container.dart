import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.useDefaultShadow = false,
    this.boxShadow,
    this.margin,
    this.width,
    this.height,
  });

  final Widget child;
  final Color? color;
  final double? borderRadius;
  final Color? borderColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool useDefaultShadow;
  final BoxShadow? boxShadow;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 16,
        vertical: verticalPadding ?? 12,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: Border.all(color: borderColor ?? Colors.transparent),
        boxShadow: boxShadow != null
            ? [boxShadow!]
            : useDefaultShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
      ),
      child: child,
    );
  }
}
