import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/paper.dart';
import '../models/subject.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String baseUrl = 'http://localhost:8000/api';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer ';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: 'auth_token');
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data?['token'] as String?;
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
      }
      return token;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Paper>> getPapers({String? search, String? subject, int? year}) async {
    try {
      final Map<String, dynamic> params = <String, dynamic>{};
      if (search != null) params['search'] = search;
      if (subject != null) params['subject'] = subject;
      if (year != null) params['year'] = year;

      final response = await _dio.get<Map<String, dynamic>>('/papers', queryParameters: params);
      
      final data = response.data?['data'] as List<dynamic>? ?? [];
      final papers = data
          .map((paper) => Paper.fromJson(paper as Map<String, dynamic>))
          .toList();
      return papers;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Paper> getPaperDetail(int paperId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/papers/');
      return Paper.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Subject>> getSubjects() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/publicum');
      final data = response.data?['data'] as List<dynamic>? ?? [];
      final subjects = data
          .map((subject) => Subject.fromJson(subject as Map<String, dynamic>))
          .toList();
      return subjects;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/auth/logout');
    } catch (e) {
      // Ignore errors during logout
    } finally {
      await _storage.delete(key: 'auth_token');
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network settings.';
    } else if (e.response != null) {
      final message = e.response?.data?['message'] as String?;
      return message ?? 'An error occurred';
    } else {
      return 'An unexpected error occurred';
    }
  }
}
