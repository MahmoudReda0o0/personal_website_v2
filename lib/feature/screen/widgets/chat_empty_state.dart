import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';
import 'package:mivo/core/model/custom_link.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:provider/provider.dart';

/// Title and hint shown above the question field. When the visitor came
/// from a personal link, a greeting with their name (and the message you
/// wrote for them) comes first.
class ChatIntro extends StatelessWidget {
  const ChatIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<MivoAiProvider>();
    final isArabic = ai.visitorLang == 'ar';
    final greeting = ai.greeting;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          8.verticalSpace,
          if (greeting != null) ...[
            _LinkGreetingCard(greeting: greeting, isArabic: isArabic),
            14.verticalSpace,
          ],
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

class _LinkGreetingCard extends StatelessWidget {
  const _LinkGreetingCard({required this.greeting, required this.isArabic});

  final LinkGreeting greeting;
  final bool isArabic;

  static final _arabic = RegExp(r'[؀-ۿ]');

  TextDirection _dir(String s) =>
      _arabic.hasMatch(s) ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = isArabic
        ? 'أهلاً ${greeting.name} 👋'
        : 'Hi ${greeting.name} 👋';

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 560.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.45)),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              color: AppColors.darkTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (greeting.description != null) ...[
            8.verticalSpace,
            Text(
              greeting.description!,
              textAlign: TextAlign.center,
              textDirection: _dir(greeting.description!),
              style: const TextStyle(
                color: AppColors.darkTextSecondary,
                fontSize: 15,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
