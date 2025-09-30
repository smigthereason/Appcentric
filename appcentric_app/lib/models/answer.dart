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
      id: json['id'],
      answerText: json['answer_text'],
      isCorrect: json['is_correct'],
      explanation: json['explanation'],
    );
  }
}
