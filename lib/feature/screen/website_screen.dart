import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_theme.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/provider/dev_mode_provider.dart';
import 'package:mivo/feature/screen/widgets/chat_empty_state.dart';
import 'package:mivo/feature/screen/widgets/dev_tools/dev_tools_layer.dart';
import 'package:mivo/feature/screen/widgets/dev_tools/inspect_catalog.dart';
import 'package:mivo/feature/screen/widgets/dev_tools/inspect_target.dart';
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
///
/// On top sit the "Flutter dev tools" (hot reload, inspect); each section is
/// wrapped in an [InspectTarget] so the inspector can explain it.
class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  final TextEditingController _questionController = TextEditingController();
  final DevModeProvider _devMode = DevModeProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ai = context.read<MivoAiProvider>();
      ai.loadStarterQuestions();
      ai.loadCustomLink();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _devMode.dispose();
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

    final page = Scaffold(
      body: DevToolsLayer(
        onRestart: () {
          if (!ai.isLoading) _questionController.clear();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const InspectTarget(
                  info: InspectCatalog.header,
                  child: WebsiteHeader(),
                ),
                16.verticalSpace,
                const InspectTarget(
                  info: InspectCatalog.mivo,
                  child: MivoImageWidget(),
                ),
                const InspectTarget(
                  info: InspectCatalog.intro,
                  child: ChatIntro(),
                ),
                12.verticalSpace,
                InspectTarget(
                  info: InspectCatalog.input,
                  child: WebsiteInputSection(
                    controller: _questionController,
                    onSend: _askQuestion,
                  ),
                ),
                if (!ai.isLoading && chips.isNotEmpty) ...[
                  InspectTarget(
                    info: InspectCatalog.chips,
                    child: SuggestionChips(
                      questions: chips,
                      onTap: _askSuggestion,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                  8.verticalSpace,
                ],
                const InspectTarget(
                  info: InspectCatalog.chat,
                  child: WebsiteChatSection(),
                ),
                24.verticalSpace,
                const GameSection(),
                // Room so the floating dev toolbar never covers the end.
                72.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );

    // The website is always dark: its texts and game cards are designed for
    // it, and following a light-mode device made some text invisible.
    // Hot reload swaps the accent; AnimatedTheme morphs the colours while
    // every bit of state (chat, games) stays as it was.
    return ChangeNotifierProvider.value(
      value: _devMode,
      child: Consumer<DevModeProvider>(
        builder: (context, dev, child) => AnimatedTheme(
          data: _themeFor(dev.accentIndex),
          duration: const Duration(milliseconds: 450),
          child: child!,
        ),
        child: page,
      ),
    );
  }

  final Map<int, ThemeData> _themes = {};

  ThemeData _themeFor(int accentIndex) => _themes.putIfAbsent(accentIndex, () {
    final dark = AppTheme.dark;
    if (accentIndex == 0) return dark;
    return dark.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: DevModeProvider.accents[accentIndex],
        brightness: Brightness.dark,
      ),
    );
  });
}
