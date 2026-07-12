import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_image.dart';
import 'package:mivo/feature/supabase_data/s_function.dart';

enum MivoState { loading, success, error, typing, sad, thinking }

class MivoAiProvider extends ChangeNotifier {
  String question = '';
  String answer = '';
  bool isLoading = false;
  SupabaseFunction supabaseFunction = SupabaseFunction();
  MivoState mivoState = MivoState.loading;
  String mivoImage = AppImage.m_success;

  Future<void> askMivoV2(String question) async {
    answer = '';
    isLoading = true;
    updateMivoState(MivoState.loading);
    notifyListeners();
    final response = await supabaseFunction.askMivoV2(question);
    answer = response;
    await addQuestion(question, response);
    isLoading = false;
    updateMivoState(MivoState.success);
    notifyListeners();
  }

  Future<void> addQuestion(String question, String answer) async {
    await supabaseFunction.addQuestion(question, answer);
  }

  updateMivoState(MivoState state) {
    mivoState = state;
    mivoImage = "${AppImage.imageMivoUrl}/${mivoState.name.toLowerCase()}.png";
    log('Mivo_Image: $mivoImage');
    notifyListeners();
  }
}
