class AiChatModel {
  final String answer;

  AiChatModel({required this.answer});

  factory AiChatModel.fromJson(Map<String, dynamic> json) {
    return AiChatModel(answer: json['answer'] ?? '');
  }
}
