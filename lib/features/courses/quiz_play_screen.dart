import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'models/quiz_models.dart';
import 'services/quiz_service.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;
  final String userName;

  const QuizPlayScreen({
    super.key,
    required this.quiz,
    required this.userName,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  final QuizService _quizService = QuizService();

  void _onAnswerSelected(int questionIndex, int optionIndex) {
    setState(() {
      _selectedAnswers[questionIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitQuiz() async {
    // Check if all questions are answered
    if (_selectedAnswers.length < widget.quiz.questions.length) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kuis Belum Selesai'),
          content: const Text('Beberapa pertanyaan belum dijawab. Apakah Anda yakin ingin mengirim kuis?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kirim Saja'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    // Calculate score
    int correctCount = 0;
    List<int> finalAnswers = [];
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final selected = _selectedAnswers[i] ?? -1;
      finalAnswers.add(selected);
      if (selected == widget.quiz.questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }

    final score = (correctCount / widget.quiz.questions.length * 100).toInt();

    final submission = QuizSubmission(
      studentId: widget.userName,
      courseId: widget.quiz.courseId,
      quizId: widget.quiz.id,
      answers: finalAnswers,
      score: score,
      submittedAt: DateTime.now(),
    );

    await _quizService.submitQuiz(submission);

    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate submission success
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.quiz.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(
                'Soal ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...List.generate(
                          question.options.length,
                          (index) => _buildOption(index, question.options[index]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavigationSection(),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text) {
    final isSelected = _selectedAnswers[_currentQuestionIndex] == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _onAnswerSelected(_currentQuestionIndex, index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationSection() {
    final isFirst = _currentQuestionIndex == 0;
    final isLast = _currentQuestionIndex == widget.quiz.questions.length - 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isFirst)
            OutlinedButton.icon(
              onPressed: _previousQuestion,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Sebelumnya'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          else
            const SizedBox(),
          ElevatedButton(
            onPressed: isLast ? _submitQuiz : _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLast ? Colors.green : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isLast ? 'Selesai' : 'Berikutnya'),
          ),
        ],
      ),
    );
  }
}
