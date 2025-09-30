import 'subject.dart';
import 'question.dart';

class Paper {
  final int id;
  final String title;
  final int year;
  final String? type;
  final Subject subject;
  final List<Question> questions;

  Paper({
    required this.id,
    required this.title,
    required this.year,
    this.type,
    required this.subject,
    required this.questions,
  });

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'] as int,
      title: json['title'] as String,
      year: json['year'] as int,
      type: json['type'] as String?,
      subject: Subject.fromJson(json['subject'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'type': type,
      'subject': subject.toJson(),
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
