import 'package:flutter/material.dart';
import 'package:personal_website_v2/feature/supabase_data/s_function.dart';

class MivoAiProvider extends ChangeNotifier {
  String question = '';
  String answer = '';
  bool isLoading = false;
  SupabaseFunction supabaseFunction = SupabaseFunction();
  Future<void> askMivo(String question) async {
    answer = '';
    isLoading = true;
    notifyListeners();
    final response = await supabaseFunction.askMivo(question);
    answer = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> askMivoV2(String question) async {
    answer = '';
    isLoading = true;
    notifyListeners();
    final response = await supabaseFunction.askMivoV2(question);
    answer = response;
    isLoading = false;
    notifyListeners();
  }
}
