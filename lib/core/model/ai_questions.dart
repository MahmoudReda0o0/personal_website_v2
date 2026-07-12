class QuestionModel {
  final int id;
  final DateTime createdAt;
  final String question;

  const QuestionModel({
    required this.id,
    required this.createdAt,
    required this.question,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      question: json['question'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'question': question,
    };
  }
}
