import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          16.verticalSpace,
          const CustomText(
            color: AppColors.darkTextPrimary,
            text: 'Ask me anything!',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          16.verticalSpace,
          const CustomText(
            text: 'Type your question below and I\'ll answer.',
            color: AppColors.darkTextPrimary,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
