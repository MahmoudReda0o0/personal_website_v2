import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/game_section.dart';
import 'package:mivo/feature/screen/widgets/mivo_image_widget.dart';
import 'package:mivo/feature/screen/widgets/website_chat_section.dart';
import 'package:mivo/feature/screen/widgets/website_header.dart';
import 'package:mivo/feature/screen/widgets/website_input_section.dart';
import 'package:provider/provider.dart';

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  /// Shows the new question and the start of Mivo's answer. The answer is
  /// read top-down; the follow-up chips sit right after it.
  void _scrollToAnswerStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Sends the typed question.
  void _askQuestion() => _send(_questionController.text);

  /// Shared by the text box and the suggestion chips.
  void _send(String question) {
    final text = question.trim();
    final ai = context.read<MivoAiProvider>();
    if (text.isEmpty || ai.isLoading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _questionController.clear();
    ai.askMivoV2(text).then((_) {
      if (mounted) _scrollToAnswerStart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WebsiteHeader(),
              16.verticalSpace,
              const MivoImageWidget(),
              SizedBox(
                height: 350.h,
                child: Column(
                  children: [
                    Expanded(
                      child: WebsiteChatSection(
                        scrollController: _scrollController,
                        onQuestionTap: _send,
                      ),
                    ),
                    WebsiteInputSection(
                      controller: _questionController,
                      onSend: _askQuestion,
                    ),
                  ],
                ),
              ),
              GameSection(),
            ],
          ),
        ),
      ),
    );
  }
}
