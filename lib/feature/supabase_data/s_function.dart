import 'dart:convert';
import 'dart:developer';

import 'package:personal_website_v2/core/model/ai_chat_model.dart';
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

  Future<void> getJsonSkills() async {
    final response = await functions.invoke('get_skills_json', body: {});
    log(name: 'function_response', response.data.toString());
  }

  // Invoke a function named 'hello-world'
}
