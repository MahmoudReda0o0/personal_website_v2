import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_keys.dart';
import 'package:mivo/core/model/ai_questions.dart';
import 'package:mivo/core/model/personal_info.dart';
import 'package:mivo/core/model/setting_model.dart';
import 'package:mivo/core/model/social_media.dart';
import 'package:mivo/feature/screen/widgets/show_question_dialog.dart';
import 'package:mivo/feature/supabase_data/s_database.dart';
import 'package:mivo/feature/supabase_data/s_function.dart';

class AppProvider extends ChangeNotifier {
  final database = SupabaseDatabase.instance;
  SupabaseFunction supabaseFunction = SupabaseFunction();

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
    isLoading = true;
    notifyListeners();
    final data = await database.getQuestions();
    if (data.isNotEmpty) {
      questions = data.reversed.toList();
      log('${data[0].question}', name: 'questions_data');
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteQuestion(int id) async {
    isLoading = true;
    notifyListeners();
    final bool result = await supabaseFunction.deleteQuestion(id);
    if (result) {
      await getQuestionsData();
    }
    isLoading = false;
    notifyListeners();

    final context = navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    if (result) {
      openQuestionDialog(context, this);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete the question. Sign in again and retry.'),
        ),
      );
    }
  }

  Future<dynamic> openQuestionDialog(BuildContext context, AppProvider data) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Questions'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.questions.length,
            itemBuilder: (context, index) {
              return ShowQuestionDialog(questions: data.questions[index]);
            },
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () => Navigator.pop(context),
        //     child: const Text('Close'),
        //   ),
        // ],
      ),
    );
  }
}
