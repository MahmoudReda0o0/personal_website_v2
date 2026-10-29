import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tappable ready-made questions. Tapping one sends it to Mivo right away.
class SuggestionChips extends StatelessWidget {
  const SuggestionChips({
    super.key,
    required this.questions,
    required this.onTap,
    this.enabled = true,
    this.alignment = WrapAlignment.center,
  });

  final List<String> questions;
  final ValueChanged<String> onTap;
  final bool enabled;
  final WrapAlignment alignment;

  static final _arabic = RegExp(r'[؀-ۿ]');

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      alignment: alignment,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final q in questions)
          ActionChip(
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
            side: BorderSide(color: scheme.primary.withValues(alpha: 0.45)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}
