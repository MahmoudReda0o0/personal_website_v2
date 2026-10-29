import 'dart:developer';
import 'package:mivo/core/model/ai_chat_model.dart';
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

  /// Returns Mivo's answer plus 2-3 follow-up suggestions.
  /// Throws if the function fails (e.g. the AI service is overloaded).
  /// [linkCode] is the personal link code (?c=...) when the visitor came
  /// from one, so Mivo knows their name.
  Future<AiChatModel> askMivoV2(String question, {String? linkCode}) async {
    final response = await functions.invoke(
      'ask_mivo_v2',
      body: {'question': question, if (linkCode != null) 'link_code': linkCode},
    );
    final reply = AiChatModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
    log(
      name: 'ask_mivo_v2_response',
      'Q: $question \nA: ${reply.answer}\nSuggestions: ${reply.suggestions}',
    );
    return reply;
  }

  /// Saves the Q&A; with [linkCode] it is linked to that personal link.
  Future<bool> addQuestion(
    String question,
    String answer, {
    String? linkCode,
  }) async {
    final response = await functions.invoke(
      'add_mivo_question',
      body: {'question': question, 'answer': answer, if (linkCode != null) 'link_code': linkCode},
    );
    if (response.status == 200) {
      return true;
    }

    return false;
  }

  Future<bool> deleteQuestion(int id) async {
    try {
      final response = await functions.invoke(
        'delete_question',
        body: {'id': id},
      );

      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getJsonSkills() async {
    final response = await functions.invoke('get_skills_json', body: {});
    log(name: 'function_response', response.data.toString());
  }

  // Invoke a function named 'hello-world'
}
