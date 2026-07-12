import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/screen/widgets/chat_empty_state.dart';
import 'package:mivo/feature/screen/widgets/message_bubble.dart';
import 'package:mivo/feature/screen/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';

class WebsiteChatSection extends StatelessWidget {
  const WebsiteChatSection({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<MivoAiProvider>(
      builder: (context, ai, _) {
        if (ai.answer.isEmpty && !ai.isLoading) {
          return const ChatEmptyState();
        }
        return ListView(
          controller: scrollController,
          padding: EdgeInsets.all(16.w),
          children: [
            if (ai.question.isNotEmpty)
              MessageBubble(text: ai.question, isUser: true),
            if (ai.answer.isNotEmpty) ...[
              16.verticalSpace,
              MessageBubble(text: ai.answer, isUser: false),
            ],
            if (ai.isLoading) ...[
              SizedBox(height: 8.h),
              const TypingIndicator(),
            ],
          ],
        );
      },
    );
  }
}
