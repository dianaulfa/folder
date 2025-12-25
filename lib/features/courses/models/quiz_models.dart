import 'dart:convert';

class Quiz {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int durationMinutes;

  Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.questions,
    this.durationMinutes = 15,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'questions': questions.map((x) => x.toMap()).toList(),
      'durationMinutes': durationMinutes,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      questions: List<QuizQuestion>.from(
          map['questions']?.map((x) => QuizQuestion.fromMap(x)) ?? const []),
      durationMinutes: map['durationMinutes'] ?? 15,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) => Quiz.fromMap(json.decode(source));
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? const []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}

class QuizSubmission {
  final String studentId;
  final String courseId;
  final String quizId;
  final List<int> answers; // Index of selected option for each question
  final int score;
  final DateTime submittedAt;

  QuizSubmission({
    required this.studentId,
    required this.courseId,
    required this.quizId,
    required this.answers,
    required this.score,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'quizId': quizId,
      'answers': answers,
      'score': score,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory QuizSubmission.fromMap(Map<String, dynamic> map) {
    return QuizSubmission(
      studentId: map['studentId'] ?? '',
      courseId: map['courseId'] ?? '',
      quizId: map['quizId'] ?? '',
      answers: List<int>.from(map['answers'] ?? const []),
      score: map['score'] ?? 0,
      submittedAt: DateTime.parse(map['submittedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizSubmission.fromJson(String source) =>
      QuizSubmission.fromMap(json.decode(source));
}
