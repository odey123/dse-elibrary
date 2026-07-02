import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/chat_message.dart';
import 'models/practice_question.dart';
import 'models/audio_summary_result.dart';

class AIService {
  // Backend URL - Change this to your deployed URL later
  static const String baseUrl = 'http://localhost:3000';
  
  // For web testing, use localhost
  // For Android emulator, use: http://10.0.2.2:3000
  // For iOS simulator, use: http://localhost:3000
  // For deployed version, use: https://your-app.vercel.app
  
  /// Ask AI a question with optional course material context
  Future<String> askQuestion({
    required String question,
    String? materialText,
    String? courseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          if (materialText != null) 'materialText': materialText,
          if (courseId != null) 'courseId': courseId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['answer'] as String;
        } else {
          throw Exception(data['error'] ?? 'Failed to get AI response');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to AI service: $e');
    }
  }

  /// Ask AI a question with specific course material (RAG)
  /// This will extract content from the PDF and use it as context
  Future<String> askWithMaterial({
    required String question,
    required String materialUrl,
    String? courseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat/ask-with-material'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'materialUrl': materialUrl,
          if (courseId != null) 'courseId': courseId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['answer'] as String;
        } else {
          throw Exception(data['error'] ?? 'Failed to get AI response');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to AI service: $e');
    }
  }

  /// Generate practice questions for a topic
  Future<List<PracticeQuestion>> generateQuestions({
    required String topic,
    String? courseId,
    String difficulty = 'medium',
    int numQuestions = 5,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/practice/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'topic': topic,
          if (courseId != null) 'courseId': courseId,
          'difficulty': difficulty,
          'numQuestions': numQuestions,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final questionsJson = data['questions'] as List;
          return questionsJson
              .map((q) => PracticeQuestion.fromJson(q))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Failed to generate questions');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate questions: $e');
    }
  }

  /// Check answer and get hints
  Future<AnswerCheckResult> checkAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    int hintLevel = 0,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/practice/check-answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'userAnswer': userAnswer,
          'correctAnswer': correctAnswer,
          'hintLevel': hintLevel,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return AnswerCheckResult.fromJson(data);
        } else {
          throw Exception(data['error'] ?? 'Failed to check answer');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check answer: $e');
    }
  }

  /// Generate a NotebookLM-style audio summary from a course material PDF
  Future<AudioSummaryResult> generateAudioSummary({
    required String materialUrl,
    String? courseName,
    String? voiceName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/summary/audio'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'materialUrl': materialUrl,
          if (courseName != null) 'courseName': courseName,
          if (voiceName != null) 'voiceName': voiceName,
        }),
      ).timeout(const Duration(minutes: 3)); // Audio generation can take a while

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return AudioSummaryResult.fromJson(data);
        } else {
          throw Exception(data['error'] ?? 'Failed to generate audio summary');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate audio summary: $e');
    }
  }

  /// Test backend connection
  Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/chat/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

