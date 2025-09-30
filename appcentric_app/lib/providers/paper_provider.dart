import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../models/paper.dart';

class PaperProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Paper> _papers = [];
  Paper? _currentPaper;
  bool _isLoading = false;
  String? _error;

  List<Paper> get papers => _papers;
  Paper? get currentPaper => _currentPaper;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPapers({String? search, String? subject, int? year}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _papers = await _apiService.getPapers(
        search: search,
        subject: subject,
        year: year,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadPaperDetail(int paperId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPaper = await _apiService.getPaperDetail(paperId);
      
      // Cache the last viewed paper for offline access
      await CacheService.cacheLastViewedPaper(_currentPaper!);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadCachedPaper() async {
    final paper = await CacheService.getLastViewedPaper();
    if (paper != null) {
      _currentPaper = paper;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
