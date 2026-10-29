/// Reply from the `ask_mivo_v2` Edge Function.
class AiChatModel {
  final String answer;

  /// Follow-up questions the visitor can tap next (may be empty).
  final List<String> suggestions;

  const AiChatModel({required this.answer, this.suggestions = const []});

  factory AiChatModel.fromJson(Map<String, dynamic> json) {
    final raw = json['suggestions'];
    return AiChatModel(
      answer: (json['answer'] ?? '').toString(),
      suggestions: raw is List
          ? raw
                .whereType<String>()
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList()
          : const [],
    );
  }
}
