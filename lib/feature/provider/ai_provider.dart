import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_image.dart';
import 'package:mivo/core/model/custom_link.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mivo/feature/supabase_data/s_database.dart';
import 'package:mivo/feature/supabase_data/s_function.dart';

enum MivoState { loading, success, error, typing, sad, thinking }

class MivoAiProvider extends ChangeNotifier {
  String question = '';
  String answer = '';
  bool isLoading = false;
  SupabaseFunction supabaseFunction = SupabaseFunction();
  MivoState mivoState = MivoState.loading;
  String mivoImage = AppImage.m_success;

  /// Follow-up questions returned with the latest answer.
  List<String> suggestions = <String>[];

  /// Ready-made questions shown before the visitor asks anything.
  List<String> starterQuestions = <String>[];

  /// Used when the table is empty or unreachable, so chips always show.
  static const Map<String, List<String>> _fallbackStarters = {
    'en': [
      'What is his strongest project?',
      'Does he have payment integration experience?',
      'Which state management does he use?',
      'Is he open to remote work?',
      'How can I contact him?',
    ],
    'ar': [
      'إيه أقوى مشروع عمله؟',
      'عنده خبرة في بوابات الدفع؟',
      'بيستخدم State Management إيه؟',
      'متاح يشتغل ريموت؟',
      'أتواصل معاه إزاي؟',
    ],
  };

  /// 'ar' for Arabic browsers, 'en' for everyone else.
  String get visitorLang =>
      PlatformDispatcher.instance.locale.languageCode == 'ar' ? 'ar' : 'en';

  // ---------------------- Personal link (?c=code) ----------------------

  /// Code from the address bar when the visitor came from a personal link.
  String? linkCode;

  /// Who the link was made for; null on the plain site link.
  LinkGreeting? greeting;

  /// Reads ?c= from the address, shows the greeting and records the open.
  /// Website only; does nothing without a code or for a bad one.
  Future<void> loadCustomLink() async {
    if (!kIsWeb) return;
    final code = Uri.base.queryParameters['c']?.trim().toLowerCase();
    if (code == null || code.isEmpty) return;
    try {
      final result = await SupabaseDatabase.instance.openCustomLink(
        code,
        lang: visitorLang,
        visitorId: await _visitorId(),
      );
      if (result == null) return;
      linkCode = code;
      greeting = result;
      notifyListeners();
    } catch (e) {
      log('custom_link_error: $e');
    }
  }

  /// Random id kept in this browser, so refreshes count as one open per day.
  static Future<String?> _visitorId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('mivo_visitor_id');
      if (id == null) {
        final rnd = Random.secure();
        id = List.generate(
          16,
          (_) => rnd.nextInt(256).toRadixString(16).padLeft(2, '0'),
        ).join();
        await prefs.setString('mivo_visitor_id', id);
      }
      return id;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadStarterQuestions() async {
    final lang = visitorLang;
    starterQuestions = _fallbackStarters[lang]!;
    notifyListeners();
    try {
      final fromDb = await SupabaseDatabase.instance.getSuggestedQuestions(
        lang,
      );
      if (fromDb.isNotEmpty) {
        starterQuestions = fromDb;
        notifyListeners();
      }
    } catch (e) {
      log('starter_questions_error: $e');
    }
  }

  Future<void> askMivoV2(String question) async {
    final text = question.trim();
    if (text.isEmpty || isLoading) return;

    this.question = text;
    answer = '';
    suggestions = <String>[];
    isLoading = true;
    updateMivoState(MivoState.loading);
    notifyListeners();

    try {
      final reply = await supabaseFunction.askMivoV2(text, linkCode: linkCode);
      answer = reply.answer;
      suggestions = reply.suggestions;
      isLoading = false;
      updateMivoState(MivoState.success);
      notifyListeners();
      // Saving the Q&A must not delay showing the answer.
      unawaited(addQuestion(text, reply.answer));
    } catch (e) {
      log('ask_mivo_v2_error: $e');
      answer = _isArabic(text)
          ? 'معلش، حصلت مشكلة وأنا بفكر 😅 جرّب تسأل تاني بعد ثواني.'
          : 'Sorry, I had trouble thinking just now 😅 Please try again in a few seconds.';
      suggestions = <String>[text];
      isLoading = false;
      updateMivoState(MivoState.sad);
      notifyListeners();
    }
  }

  Future<void> addQuestion(String question, String answer) async {
    try {
      await supabaseFunction.addQuestion(question, answer, linkCode: linkCode);
    } catch (e) {
      log('add_question_error: $e');
    }
  }

  static bool _isArabic(String s) => RegExp(r'[؀-ۿ]').hasMatch(s);

  void updateMivoState(MivoState state) {
    mivoState = state;
    mivoImage = "${AppImage.imageMivoUrl}/${mivoState.name.toLowerCase()}.png";
    log('Mivo_Image: $mivoImage');
    notifyListeners();
  }
}
