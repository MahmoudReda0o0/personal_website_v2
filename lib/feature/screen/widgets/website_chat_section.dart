import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/screen/widgets/message_bubble.dart';
import 'package:mivo/feature/screen/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';

/// The visitor's question and Mivo's answer, shown under the question field
/// and the suggestion chips. Grows with the answer; the page scrolls.
class WebsiteChatSection extends StatelessWidget {
  const WebsiteChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MivoAiProvider>(
      builder: (context, ai, _) {
        if (ai.question.isEmpty && ai.answer.isEmpty && !ai.isLoading) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (ai.question.isNotEmpty)
                MessageBubble(text: ai.question, isUser: true),
              if (ai.answer.isNotEmpty) ...[
                12.verticalSpace,
                MessageBubble(text: ai.answer, isUser: false),
              ],
              if (ai.isLoading) ...[
                8.verticalSpace,
                const TypingIndicator(),
              ],
            ],
          ),
        );
      },
    );
  }
}
