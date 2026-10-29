import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:provider/provider.dart';

/// Title and hint shown above the question field.
class ChatIntro extends StatelessWidget {
  const ChatIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.select<MivoAiProvider, bool>(
      (ai) => ai.visitorLang == 'ar',
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          8.verticalSpace,
          const CustomText(
            color: AppColors.darkTextPrimary,
            text: 'Ask me anything!',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          6.verticalSpace,
          CustomText(
            text: isArabic
                ? 'اكتب سؤالك، أو اختار سؤال من تحت:'
                : 'Type your question, or pick one below:',
            color: AppColors.darkTextPrimary,
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
