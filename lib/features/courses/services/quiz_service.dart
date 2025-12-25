import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_models.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;
  QuizService._internal();

  static const String _submissionsKey = 'quiz_submissions';

  // Mock quizzes for exploration
  final List<Quiz> _mockQuizzes = [
    Quiz(
      id: 'q1',
      courseId: 'Algoritma & Pemrograman',
      title: 'Kuis 1: Dasar Algoritma',
      description: 'Uji pemahaman Anda tentang konsep dasar algoritma dan flow control.',
      durationMinutes: 10,
      questions: [
        QuizQuestion(
          question: 'Apa yang dimaksud dengan variabel dalam pemrograman?',
          options: [
            'Sebuah fungsi untuk mencetak teks',
            'Tempat penyimpanan data di memori',
            'Tipe data angka saja',
            'Simbol matematika'
          ],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          question: 'Manakah dari berikut ini yang merupakan struktur kontrol pengulangan?',
          options: ['if-else', 'switch-case', 'for', 'class'],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          question: 'Simbol yang digunakan untuk komentar baris tunggal di Dart adalah...',
          options: ['//', '/*', '#', ' --'],
          correctAnswerIndex: 0,
        ),
      ],
    ),
    Quiz(
      id: 'q2',
      courseId: 'Basis Data',
      title: 'Kuis 1: Pengenalan SQL',
      description: 'Kuis singkat mengenai perintah dasar SQL.',
      durationMinutes: 5,
      questions: [
        QuizQuestion(
          question: 'Perintah mana yang digunakan untuk mengambil data dari tabel?',
          options: ['INSERT', 'SELECT', 'UPDATE', 'DELETE'],
          correctAnswerIndex: 1,
        ),
      ],
    ),
  ];

  Future<List<Quiz>> getQuizzesByCourse(String courseName) async {
    // In a real app, this would fetch from a database or API
    return _mockQuizzes.where((q) => q.courseId == courseName).toList();
  }

  Future<void> submitQuiz(QuizSubmission submission) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> submissionsJson = prefs.getStringList(_submissionsKey) ?? [];
    
    // Check if user already submitted for this quiz to avoid duplicates
    submissionsJson.removeWhere((jsonStr) {
      final existing = QuizSubmission.fromJson(jsonStr);
      return existing.studentId == submission.studentId && existing.quizId == submission.quizId;
    });

    submissionsJson.add(submission.toJson());
    await prefs.setStringList(_submissionsKey, submissionsJson);
  }

  Future<QuizSubmission?> getSubmission(String studentId, String quizId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> submissionsJson = prefs.getStringList(_submissionsKey) ?? [];
    
    for (var jsonStr in submissionsJson) {
      final submission = QuizSubmission.fromJson(jsonStr);
      if (submission.studentId == studentId && submission.quizId == quizId) {
        return submission;
      }
    }
    return null;
  }

  Future<List<QuizSubmission>> getSubmissionsByStudent(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> submissionsJson = prefs.getStringList(_submissionsKey) ?? [];
    
    return submissionsJson
        .map((jsonStr) => QuizSubmission.fromJson(jsonStr))
        .where((s) => s.studentId == studentId)
        .toList();
  }
}
