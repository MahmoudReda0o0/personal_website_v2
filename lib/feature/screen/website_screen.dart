import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/screen/widgets/chat_empty_state.dart';
import 'package:mivo/feature/screen/widgets/mini_games/game_section.dart';
import 'package:mivo/feature/screen/widgets/mivo_image_widget.dart';
import 'package:mivo/feature/screen/widgets/suggestion_chips.dart';
import 'package:mivo/feature/screen/widgets/website_chat_section.dart';
import 'package:mivo/feature/screen/widgets/website_header.dart';
import 'package:mivo/feature/screen/widgets/website_input_section.dart';
import 'package:provider/provider.dart';

/// Layout, top to bottom:
/// header → Mivo → intro → question field → suggestion chips → Q&A → games.
/// The chips sit right under the field and work exactly like typing a
/// question there and pressing send.
class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MivoAiProvider>().loadStarterQuestions();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  /// Sends whatever is in the question field.
  Future<void> _askQuestion() async {
    final text = _questionController.text.trim();
    final ai = context.read<MivoAiProvider>();
    if (text.isEmpty || ai.isLoading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    // The question stays in the field while Mivo thinks, then clears.
    await ai.askMivoV2(text);
    if (mounted) _questionController.clear();
  }

  /// A chip behaves like the visitor typed it into the field and sent it.
  void _askSuggestion(String question) {
    if (context.read<MivoAiProvider>().isLoading) return;
    _questionController.text = question;
    _askQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<MivoAiProvider>();
    final hasConversation = ai.answer.isNotEmpty || ai.isLoading;
    // Starter questions first; after an answer, its follow-ups.
    final chips = hasConversation ? ai.suggestions : ai.starterQuestions;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WebsiteHeader(),
              16.verticalSpace,
              const MivoImageWidget(),
              const ChatIntro(),
              12.verticalSpace,
              WebsiteInputSection(
                controller: _questionController,
                onSend: _askQuestion,
              ),
              if (!ai.isLoading && chips.isNotEmpty) ...[
                SuggestionChips(
                  questions: chips,
                  onTap: _askSuggestion,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                8.verticalSpace,
              ],
              const WebsiteChatSection(),
              24.verticalSpace,
              GameSection(),
            ],
          ),
        ),
      ),
    );
  }
}
