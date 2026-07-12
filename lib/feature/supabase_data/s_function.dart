import 'dart:developer';
import 'package:mivo/core/model/ai_questions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  // Get a reference to the functions client
  final functions = Supabase.instance.client.functions;
  Future<void> testApi() async {
    final response = await functions.invoke(
      'hello-world',
      body: {'name': 'Mahmoud'},
    );
    log(name: 'function_response', response.data.toString());
  }

  Future<void> getGoogleAiKey() async {
    final response = await functions.invoke('get_google_ai_api_key', body: {});
    log(name: 'function_response', response.data.toString());
  }

  Future<String> askMivo(String question) async {
    final response = await functions.invoke(
      'ask_mivo',
      body: {'question': question},
    );
    log(
      name: 'ask_mivo_response',
      'Q: $question \nA: ${response.data['answer']}',
    );
    return response.data['answer'];
  }

  Future<String> askMivoV2(String question) async {
    final response = await functions.invoke(
      'ask_mivo_v2',
      body: {'question': question},
    );
    log(
      name: 'ask_mivo_v2_response',
      'Q: $question \nA: ${response.data['answer']}',
    );
    return response.data['answer'];
  }

  Future<bool> addQuestion(String question, String answer) async {
    final response = await functions.invoke(
      'add_mivo_question',
      body: {'question': question, 'answer': answer},
    );
    if (response.status == 200) {
      return true;
    }

    return false;
  }

  Future<void> getJsonSkills() async {
    final response = await functions.invoke('get_skills_json', body: {});
    log(name: 'function_response', response.data.toString());
  }

  // Invoke a function named 'hello-world'
}
