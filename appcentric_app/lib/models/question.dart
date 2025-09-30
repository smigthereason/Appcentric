import 'answer.dart';

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
      id: json['id'] as int,
      questionText: json['question_text'] as String,
      questionNumber: json['question_number'] as int,
      marks: json['marks'] as int,
      answers: (json['answers'] as List<dynamic>)
          .map((a) => Answer.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_number': questionNumber,
      'marks': marks,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}
