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
      id: json['id'],
      title: json['title'],
      year: json['year'],
      type: json['type'],
      subject: Subject.fromJson(json['subject']),
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Subject {
  final int id;
  final String name;
  final String code;
  final String? description;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    this.description,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
    );
  }
}
