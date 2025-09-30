class Answer {
  final int id;
  final String answerText;
  final bool isCorrect;
  final String? explanation;

  Answer({
    required this.id,
    required this.answerText,
    required this.isCorrect,
    this.explanation,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as int,
      answerText: json['answer_text'] as String,
      isCorrect: json['is_correct'] as bool,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_text': answerText,
      'is_correct': isCorrect,
      'explanation': explanation,
    };
  }
}
