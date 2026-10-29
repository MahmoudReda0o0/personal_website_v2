import 'package:flutter/material.dart';

/// Global navigator key, attached to [MaterialApp] in main.dart.
/// Lets non-widget code (e.g. providers) access a context for dialogs.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
