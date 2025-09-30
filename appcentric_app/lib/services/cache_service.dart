import 'package:hive/hive.dart';
import '../models/paper.dart';

class CacheService {
  static const String _papersBox = 'papers_box';
  static const String _lastViewedKey = 'last_viewed_paper';

  static Future<void> init() async {
    await Hive.openBox<Map>(_papersBox);
  }

  static Future<void> cacheLastViewedPaper(Paper paper) async {
    final box = Hive.box<Map>(_papersBox);
    final paperMap = _paperToMap(paper);
    await box.put(_lastViewedKey, paperMap);
  }

  static Future<Paper?> getLastViewedPaper() async {
    final box = Hive.box<Map>(_papersBox);
    final paperMap = box.get(_lastViewedKey);
    
    if (paperMap != null) {
      return _paperFromMap(paperMap);
    }
    return null;
  }

  static Map<String, dynamic> _paperToMap(Paper paper) {
    return {
      'id': paper.id,
      'title': paper.title,
      'year': paper.year,
      'type': paper.type,
      'subject': {
        'id': paper.subject.id,
        'name': paper.subject.name,
        'code': paper.subject.code,
      },
      'questions': paper.questions.map((q) => {
        'id': q.id,
        'question_text': q.questionText,
        'question_number': q.questionNumber,
        'marks': q.marks,
        'answers': q.answers.map((a) => {
          'id': a.id,
          'answer_text': a.answerText,
          'is_correct': a.isCorrect,
          'explanation': a.explanation,
        }).toList(),
      }).toList(),
    };
  }

  static Paper _paperFromMap(Map<String, dynamic> map) {
    return Paper.fromJson(map);
  }
}
