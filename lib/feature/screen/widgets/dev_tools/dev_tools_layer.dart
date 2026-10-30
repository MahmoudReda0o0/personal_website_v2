import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:mivo/feature/provider/dev_mode_provider.dart';
import 'package:provider/provider.dart';

/// Puts the "Flutter dev tools" on top of the website:
/// - a small toolbar (⚡ Hot reload, Inspect) in the bottom corner,
/// - a quick flash and a `flutter run` style terminal toast on reload,
/// - a banner while Inspect mode is on,
/// - the same keys as `flutter run`: r = hot reload, R = hot restart,
///   i = inspect (ignored while typing in a text field).
class DevToolsLayer extends StatefulWidget {
  const DevToolsLayer({super.key, required this.child, this.onRestart});

  final Widget child;

  /// Called on hot restart, to clear page state such as the question field.
  final VoidCallback? onRestart;

  @override
  State<DevToolsLayer> createState() => _DevToolsLayerState();
}

class _DevToolsLayerState extends State<DevToolsLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  List<String> _report = const [];
  int _shownLines = 0;
  bool _toastVisible = false;
  Timer? _lineTimer;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _lineTimer?.cancel();
    _hideTimer?.cancel();
    _flash.dispose();
    super.dispose();
  }

  // ------------------------------ actions ------------------------------

  void _hotReload() {
    final report = context.read<DevModeProvider>().hotReload();
    _play(report, strength: 0.28);
  }

  void _hotRestart() {
    final report = context.read<DevModeProvider>().hotRestart();
    context.read<MivoAiProvider>().resetConversation();
    widget.onRestart?.call();
    _play(report, strength: 0.45);
  }

  void _toggleInspect() => context.read<DevModeProvider>().toggleInspect();

  void _play(List<String> report, {required double strength}) {
    _flashStrength = strength;
    _flash.forward(from: 0);
    _lineTimer?.cancel();
    _hideTimer?.cancel();
    setState(() {
      _report = report;
      _shownLines = 1;
      _toastVisible = true;
    });
    // Second line lands a moment later, like the real CLI output.
    _lineTimer = Timer(const Duration(milliseconds: 320), () {
      if (mounted) setState(() => _shownLines = _report.length);
    });
    _hideTimer = Timer(const Duration(milliseconds: 3600), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  double _flashStrength = 0.28;

  // ----------------------------- keyboard ------------------------------

  bool get _isTyping {
    final ctx = FocusManager.instance.primaryFocus?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText ||
        ctx.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent || !mounted) return false;
    final keys = HardwareKeyboard.instance;
    if (keys.isControlPressed || keys.isMetaPressed || keys.isAltPressed) {
      return false; // Leave browser shortcuts (Ctrl+R etc.) alone.
    }
    if (_isTyping) return false;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.keyR) {
      if (keys.isShiftPressed) {
        _hotRestart();
      } else {
        _hotReload();
      }
      return true;
    }
    if (key == LogicalKeyboardKey.keyI) {
      _toggleInspect();
      return true;
    }
    if (key == LogicalKeyboardKey.escape &&
        context.read<DevModeProvider>().inspecting) {
      context.read<DevModeProvider>().stopInspecting();
      return true;
    }
    return false;
  }

  // ------------------------------- build -------------------------------

  @override
  Widget build(BuildContext context) {
    final inspecting = context.select<DevModeProvider, bool>(
      (d) => d.inspecting,
    );
    final isArabic = context.select<MivoAiProvider, bool>(
      (ai) => ai.visitorLang == 'ar',
    );

    return Stack(
      // Fill the body like the page did before, so overlays sit at the
      // screen edges even when the content is short.
      fit: StackFit.expand,
      children: [
        widget.child,

        // Reload flash.
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _flash,
              builder: (context, _) {
                final t = _flash.value;
                // Quick rise, slower fade.
                final opacity = t < 0.25 ? t / 0.25 : 1 - (t - 0.25) / 0.75;
                return ColoredBox(
                  color: Colors.white.withValues(
                    alpha: _flash.isAnimating ? opacity * _flashStrength : 0,
                  ),
                );
              },
            ),
          ),
        ),

        // Inspect banner, above the toolbar so it never covers the header.
        Positioned(
          bottom: 66,
          left: 12,
          right: 12,
          child: SafeArea(
            top: false,
            child: AnimatedSlide(
              offset: inspecting ? Offset.zero : const Offset(0, 0.6),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: inspecting ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: !inspecting,
                  child: Center(
                    child: _InspectBanner(
                      isArabic: isArabic,
                      onClose: () =>
                          context.read<DevModeProvider>().stopInspecting(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Terminal toast (moves up while the inspect banner is showing).
        AnimatedPositioned(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          left: 12,
          right: 12,
          bottom: inspecting ? 124 : 68,
          child: SafeArea(
            top: false,
            child: IgnorePointer(
              child: AnimatedSlide(
                offset: _toastVisible ? Offset.zero : const Offset(0, 0.4),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: _toastVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Center(
                    child: _TerminalToast(
                      lines: _report.take(_shownLines).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Toolbar.
        Positioned(
          right: 12,
          bottom: 12,
          child: SafeArea(
            top: false,
            child: _DevToolbar(
              inspecting: inspecting,
              onReload: _hotReload,
              onInspect: _toggleInspect,
            ),
          ),
        ),
      ],
    );
  }
}

class _DevToolbar extends StatelessWidget {
  const _DevToolbar({
    required this.inspecting,
    required this.onReload,
    required this.onInspect,
  });

  final bool inspecting;
  final VoidCallback onReload;
  final VoidCallback onInspect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DevStyle.terminalBg.withValues(alpha: 0.92),
      shape: StadiumBorder(
        side: BorderSide(color: DevStyle.terminalBorder),
      ),
      elevation: 6,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToolButton(
              icon: Icons.bolt_rounded,
              iconColor: const Color(0xFFFFC93D),
              label: 'Hot reload',
              tooltip: 'Hot reload (r) · Hot restart (R)',
              onTap: onReload,
            ),
            Container(
              width: 1,
              height: 20,
              color: DevStyle.terminalBorder,
            ),
            _ToolButton(
              icon: Icons.highlight_alt_rounded,
              iconColor: DevStyle.inspectBlue,
              label: 'Inspect',
              tooltip: 'Inspect widgets (i)',
              active: inspecting,
              onTap: onInspect,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: active
                ? DevStyle.inspectBlue.withValues(alpha: 0.22)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: DevStyle.mono,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: DevStyle.terminalText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TerminalToast extends StatelessWidget {
  const _TerminalToast({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 560),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: DevStyle.terminalBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DevStyle.terminalBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 4),
              child: Text(
                lines[i],
                style: TextStyle(
                  fontFamily: DevStyle.mono,
                  fontSize: 12,
                  height: 1.4,
                  color: i == 0 ? DevStyle.terminalDim : DevStyle.terminalText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InspectBanner extends StatelessWidget {
  const _InspectBanner({required this.isArabic, required this.onClose});

  final bool isArabic;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DevStyle.inspectBlue,
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.highlight_alt_rounded,
              size: 18,
              color: DevStyle.inspectInk,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isArabic
                    ? 'Inspect mode · دوس على أي جزء تشوفه معمول إزاي'
                    : 'Inspect mode · Tap any part to see how it’s built',
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: DevStyle.inspectInk,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Exit inspect mode (Esc)',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close, size: 18, color: DevStyle.inspectInk),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
