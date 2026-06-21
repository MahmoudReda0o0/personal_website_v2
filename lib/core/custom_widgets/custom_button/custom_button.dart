import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/app/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.height,
    this.textColor,
    this.textSize,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double? height;
  final Color? textColor;
  final double? textSize;
  final bool isLoading;
  final bool isDisabled;
  final bool isOutlined;
  final Widget? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final bool disabled = isLoading || isDisabled;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: disabled ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          side: BorderSide(color: disabled ? Colors.grey : (color ?? AppColors.primary)),
          minimumSize: Size(width ?? double.infinity, height ?? 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: textSize ?? 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: _buildChild(),
      );
    }

    return ElevatedButton(
      onPressed: disabled ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: textColor ?? Colors.white,
        disabledBackgroundColor: (color ?? AppColors.primary).withValues(alpha: 0.4),
        disabledForegroundColor: (textColor ?? Colors.white).withValues(alpha: 0.6),
        minimumSize: Size(width ?? double.infinity, height ?? 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: textSize ?? 16.sp,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Colors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
