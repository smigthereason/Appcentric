class Question {
  final int id;
  final String questionText;
  final int questionNumber;
  final int marks;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionText,
    required this.questionNumber,
    required this.marks,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question_text'],
      questionNumber: json['question_number'],
      marks: json['marks'],
      answers: (json['answers'] as List)
          .map((a) => Answer.fromJson(a))
          .toList(),
    );
  }
}
