import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
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
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _askQuestion() {
    final text = _questionController.text.trim();
    if (text.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<MivoAiProvider>().askMivoV2(text).then((_) {
      _questionController.clear();
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    ),
                  ),
                  WebsiteInputSection(
                    controller: _questionController,
                    onSend: _askQuestion,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
