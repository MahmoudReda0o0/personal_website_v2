import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/app/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.bold = false,
    this.overflow,
    this.textAlign,
    this.maxLines,
    this.style,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool bold;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style ??
          TextStyle(
            color: color ?? AppColors.lightTextPrimary,
            fontSize: bold ? 20 : fontSize ?? 16,
            fontWeight: bold ? FontWeight.bold : fontWeight ?? FontWeight.w500,
            overflow: overflow,
          ),
    );
  }
}
