import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tappable ready-made questions in one horizontally scrollable row.
/// Tapping one sends it to Mivo right away.
///
/// A single row keeps the small chat box readable on phones and never cuts
/// a long question off. Mouse dragging is enabled so it also scrolls on
/// desktop browsers.
class SuggestionChips extends StatelessWidget {
  const SuggestionChips({
    super.key,
    required this.questions,
    required this.onTap,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.center = false,
  });

  final List<String> questions;
  final ValueChanged<String> onTap;
  final bool enabled;
  final EdgeInsets padding;

  /// Center the row when it fits (it still scrolls when it doesn't).
  final bool center;

  static final _arabic = RegExp(r'[؀-ۿ]');

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
        scrollbars: false,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: (constraints.maxWidth - padding.horizontal).clamp(
              0.0,
              double.infinity,
            ),
          ),
          child: Row(
          mainAxisAlignment: center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            for (final q in questions)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: ActionChip(
                  onPressed: enabled ? () => onTap(q) : null,
                  avatar: Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: scheme.primary,
                  ),
                  label: Text(
                    q,
                    textDirection: _arabic.hasMatch(q)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  labelStyle: TextStyle(fontSize: 13, color: scheme.onSurface),
                  backgroundColor: scheme.primary.withValues(alpha: 0.10),
                  side: BorderSide(
                    color: scheme.primary.withValues(alpha: 0.45),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        ),
      ),
      ),
    );
  }
}
