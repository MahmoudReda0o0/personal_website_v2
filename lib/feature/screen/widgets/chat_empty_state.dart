import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/screen/widgets/suggestion_chips.dart';
import 'package:provider/provider.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.onQuestionTap});

  /// Sends a starter question straight to Mivo.
  final ValueChanged<String> onQuestionTap;

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<MivoAiProvider>();
    final isArabic = ai.visitorLang == 'ar';

    // Scrollable so nothing overflows the fixed-height chat box.
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 44,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          10.verticalSpace,
          const CustomText(
            color: AppColors.darkTextPrimary,
            text: 'Ask me anything!',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          8.verticalSpace,
          CustomText(
            text: isArabic
                ? 'اكتب سؤالك، أو اختار سؤال جاهز:'
                : 'Type your question, or tap one to start:',
            color: AppColors.darkTextPrimary,
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
          14.verticalSpace,
          // Edge-to-edge row, so chips scroll under the screen edge.
          SuggestionChips(
            questions: ai.starterQuestions,
            enabled: !ai.isLoading,
            onTap: onQuestionTap,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            center: true,
          ),
        ],
      ),
    );
  }
}
