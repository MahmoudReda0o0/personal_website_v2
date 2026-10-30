import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mivo/core/app/website_theme.dart';

/// The website's "Flutter dev tools", a nod to `flutter run`:
/// - Hot reload (⚡ or the `r` key): swaps the accent colour while keeping
///   all state (chat, games), just like a real hot reload.
/// - Hot restart (`R`): back to the original look with a fresh chat.
/// - Inspect (`i`): outlines the widgets; tap one to see how it's built.
class DevModeProvider extends ChangeNotifier {
  /// Accent pairs a hot reload cycles through. Index 0 is the site's own.
  static const List<AccentPair> accents = WebsiteTheme.accents;

  /// Fixed so the numbers look like the same app reloading each time.
  static const int libraryCount = 1287;

  final Random _random = Random();

  int accentIndex = 0;
  AccentPair get accent => accents[accentIndex];

  bool inspecting = false;

  /// Next accent; returns the `flutter run` style report to show.
  List<String> hotReload() {
    accentIndex = (accentIndex + 1) % accents.length;
    notifyListeners();
    final compile = 14 + _random.nextInt(18);
    final reload = 22 + _random.nextInt(34);
    final reassemble = 16 + _random.nextInt(28);
    final total = compile + reload + reassemble;
    return [
      'Performing hot reload...',
      'Reloaded 1 of $libraryCount libraries in ${total}ms '
          '(compile: $compile ms, reload: $reload ms, '
          'reassemble: $reassemble ms).',
    ];
  }

  /// Original accent, inspector off; returns the report to show.
  List<String> hotRestart() {
    accentIndex = 0;
    inspecting = false;
    notifyListeners();
    final ms = 640 + _random.nextInt(520);
    final formatted = ms >= 1000
        ? '${ms ~/ 1000},${(ms % 1000).toString().padLeft(3, '0')}'
        : '$ms';
    return ['Performing hot restart...', 'Restarted application in ${formatted}ms.'];
  }

  void toggleInspect() {
    inspecting = !inspecting;
    notifyListeners();
  }

  void stopInspecting() {
    if (!inspecting) return;
    inspecting = false;
    notifyListeners();
  }
}

/// Shared styling for the dev tools.
class DevStyle {
  DevStyle._();

  /// Bundled JetBrains Mono (assets/fonts, SIL Open Font License).
  static const String mono = 'JetBrainsMono';

  /// Flutter's light blue, used for inspector outlines and labels.
  static const Color inspectBlue = Color(0xFF13B9FD);
  static const Color inspectInk = Color(0xFF00243D);

  /// Terminal colours for the reload toast.
  static const Color terminalBg = Color(0xFF0D1117);
  static const Color terminalBorder = Color(0xFF30363D);
  static const Color terminalText = Color(0xFFC9D1D9);
  static const Color terminalDim = Color(0xFF8B949E);
}
