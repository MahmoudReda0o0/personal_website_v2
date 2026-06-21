import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/app/app_colors.dart';
import 'package:personal_website_v2/core/app/app_image.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_image/custom_image.dart';

import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text_field/custom_text_field.dart';
import 'package:personal_website_v2/feature/provider/ai_provider.dart';
import 'package:personal_website_v2/feature/provider/app_provider.dart';
import 'package:personal_website_v2/feature/screen/widgets/mivo_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      context.read<AppProvider>().getInitData();
    });
  }

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
            _buildHeader(context),
            16.verticalSpace,
            MivoImageWidget(),
            SizedBox(
              height: 350.h,
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<MivoAiProvider>(
                      builder: (context, ai, _) {
                        if (ai.answer.isEmpty && !ai.isLoading) {
                          return _buildEmptyState(context);
                        }
                        return _buildChatContent(context, ai);
                      },
                    ),
                  ),

                  _buildInputArea(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.personalInfo.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data.personalInfo.job,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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

  Widget _buildChatContent(BuildContext context, MivoAiProvider ai) {
    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      children: [
        if (ai.question.isNotEmpty)
          _buildMessageBubble(context, text: ai.question, isUser: true),
        if (ai.answer.isNotEmpty) ...[
          16.verticalSpace,
          _buildMessageBubble(context, text: ai.answer, isUser: false),
        ],
        if (ai.isLoading) ...[SizedBox(height: 8.h), _buildTypingIndicator()],
      ],
    );
  }

  Widget _buildMessageBubble(
    BuildContext context, {
    required String text,
    required bool isUser,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.8.sw),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: isUser
            ? CustomText(text: text, color: Colors.white, fontSize: 14)
            : Linkify(
                text: text,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                linkStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                onOpen: (link) async {
                  await launchUrl(
                    Uri.parse(link.url),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1.0),
              duration: Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Transform.scale(
                    scale: value,
                    child: const CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Consumer<MivoAiProvider>(
      builder: (context, ai, _) {
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _questionController,
                  hintText: 'Type your question...',
                  enabled: !ai.isLoading,
                  onSubmitted: (_) => _askQuestion(),
                  textInputAction: TextInputAction.send,
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                height: 48.h,
                width: 48.h,
                child: ElevatedButton(
                  onPressed: ai.isLoading ? null : _askQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: ai.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 22),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
