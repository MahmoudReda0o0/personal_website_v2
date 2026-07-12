import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Transform.scale(
                    scale: value,
                    child: const CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
