import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mivo/core/model/ai_questions.dart';
import 'package:mivo/core/model/personal_info.dart';
import 'package:mivo/core/model/setting_model.dart';
import 'package:mivo/core/model/social_media.dart';
import 'package:mivo/feature/supabase_data/s_database.dart';

class AppProvider extends ChangeNotifier {
  final database = SupabaseDatabase.instance;
  bool isLoading = false;
  List<SocialMedia> socialData = <SocialMedia>[];
  MyInfoModel personalInfo = MyInfoModel.defaultMyInfo();
  SettingModel setting = SettingModel.defaultSetting();
  List<QuestionModel> questions = <QuestionModel>[];

  /// Single entry point for all app startup logic.
  ///
  /// Called once from [InitScreen] before the first screen is shown.
  Future<void> initializeApp() async {
    // Web-only version check would go here, e.g.:
    //   if (kIsWeb) await checkWebVersion();
    // (no such method exists in the codebase yet — add it here when needed.)
    await getInitData();
  }

  Future<void> getInitData() async {
    await Future.wait([getMyInfoData(), getSettingData()]);
  }

  Future<void> getMyInfoData() async {
    final data = await database.getMyInfo();
    if (data != null) {
      personalInfo = data;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getSettingData() async {
    final data = await database.getSettings();
    if (data != null) {
      setting = data;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getQuestionsData() async {
    final data = await database.getQuestions();
    if (data.isNotEmpty) {
      questions = data;
      log('${data[0].question}', name: 'questions_data');
      notifyListeners();
    }
    notifyListeners();
  }
}
