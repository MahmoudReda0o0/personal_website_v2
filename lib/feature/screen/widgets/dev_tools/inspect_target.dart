import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/provider/dev_mode_provider.dart';
import 'package:mivo/feature/screen/widgets/dev_tools/inspect_catalog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Wraps a part of the page so Inspect mode can outline it with its widget
/// name; tapping it then explains how it's built instead of using it.
///
/// The child always stays in the same place in the tree, so turning the
/// inspector on or off never resets its state (chat, games).
class InspectTarget extends StatefulWidget {
  const InspectTarget({super.key, required this.info, required this.child});

  final InspectInfo info;
  final Widget child;

  @override
  State<InspectTarget> createState() => _InspectTargetState();
}

class _InspectTargetState extends State<InspectTarget> {
  bool _hover = false;

  bool _inspecting(BuildContext context) {
    try {
      return context.select<DevModeProvider, bool>((d) => d.inspecting);
    } on ProviderNotFoundException {
      return false; // Used outside the website screen: plain child.
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspecting = _inspecting(context);
    if (!inspecting && _hover) _hover = false;

    return MouseRegion(
      cursor: inspecting ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) {
        if (inspecting) setState(() => _hover = true);
      },
      onExit: (_) {
        if (_hover) setState(() => _hover = false);
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          widget.child,
          if (inspecting) ...[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showInspectSheet(context, widget.info),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  decoration: BoxDecoration(
                    color: DevStyle.inspectBlue.withValues(
                      alpha: _hover ? 0.16 : 0.05,
                    ),
                    border: Border.all(
                      color: DevStyle.inspectBlue,
                      width: _hover ? 2 : 1,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  color: DevStyle.inspectBlue,
                  child: Text(
                    widget.info.widget,
                    style: const TextStyle(
                      fontFamily: DevStyle.mono,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: DevStyle.inspectInk,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bottom sheet: widget name, file, what it does, and a link to the code.
Future<void> showInspectSheet(BuildContext context, InspectInfo info) {
  final isArabic = context.read<MivoAiProvider>().visitorLang == 'ar';
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      final description = info.describe(isArabic ? 'ar' : 'en');
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.widgets_outlined,
                    color: DevStyle.inspectBlue,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      info.widget,
                      style: TextStyle(
                        fontFamily: DevStyle.mono,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                info.file,
                style: TextStyle(
                  fontFamily: DevStyle.mono,
                  fontSize: 11.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: scheme.onSurface,
                ),
              ),
              if (info.tags.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in info.tags)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: DevStyle.inspectBlue.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontFamily: DevStyle.mono,
                            fontSize: 11.5,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(info.sourceUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.code_rounded, size: 18),
                  label: Text(
                    isArabic ? 'شوف الكود على GitHub' : 'View source on GitHub',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
