import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'upload_tugas_screen.dart';
import 'services/quiz_service.dart';
import 'services/assignment_service.dart';
import 'services/material_service.dart';
import 'models/quiz_models.dart';
import 'models/assignment_models.dart';
import 'models/material_models.dart';
import 'quiz_play_screen.dart';
import 'quiz_result_screen.dart';
import 'material_viewer_screen.dart';

class ClassDetailScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String userName;

  const ClassDetailScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.userName,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final QuizService _quizService = QuizService();
  final AssignmentService _assignmentService = AssignmentService();
  final MaterialService _materialService = MaterialService();
  List<Quiz> _quizzes = [];
  List<MeetingSection> _meetingSections = [];
  Map<String, QuizSubmission?> _submissions = {};
  Map<String, AssignmentSubmission?> _assignmentSubmissions = {};
  Map<String, bool> _materialOpenedStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    
    // Load Quizzes
    final quizzes = await _quizService.getQuizzesByCourse(widget.courseId);
    Map<String, QuizSubmission?> submissions = {};
    for (var quiz in quizzes) {
      final sub = await _quizService.getSubmission(widget.userName, quiz.id);
      submissions[quiz.id] = sub;
    }

    // Load Assignment Submissions
    final assignSubs = await _assignmentService.getSubmissionsByCourse(widget.userName, widget.courseId);
    Map<String, AssignmentSubmission?> assignmentMap = {};
    for (var sub in assignSubs) {
      assignmentMap[sub.assignmentId] = sub;
    }

    // Load Materials
    final sections = await _materialService.getMaterialsByCourse(widget.courseId);
    Map<String, bool> materialStatusMap = {};
    for (var section in sections) {
      for (var item in section.materials) {
        final opened = await _materialService.isOpened(widget.userName, item.id);
        materialStatusMap[item.id] = opened;
      }
    }

    setState(() {
      _quizzes = quizzes;
      _meetingSections = sections;
      _submissions = submissions;
      _assignmentSubmissions = assignmentMap;
      _materialOpenedStatus = materialStatusMap;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Detail Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildCourseHeader(context),
            const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Materi'),
                Tab(text: 'Tugas'),
                Tab(text: 'Kuis'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMateriTab(context),
                  _buildTugasTab(context),
                  _buildKuisTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primary, size: 35),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Dosen: Dr. Ir. Budi Santoso, M.T.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: 0.75,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '75%',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriTab(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_meetingSections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 80, color: AppColors.primary.withOpacity(0.2)),
            const SizedBox(height: 16),
            const Text('Belum ada materi yang tersedia.', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _meetingSections.length,
      itemBuilder: (context, index) {
        final section = _meetingSections[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                section.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
            ),
            ...section.materials.map((item) => _buildMaterialItem(item)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildMaterialItem(MaterialItem item) {
    bool isCompleted = _materialOpenedStatus[item.id] ?? false;
    IconData typeIcon;
    Color iconColor;

    switch (item.type) {
      case MaterialFileType.pdf:
        typeIcon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case MaterialFileType.ppt:
        typeIcon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case MaterialFileType.video:
        typeIcon = Icons.play_circle_fill;
        iconColor = Colors.blue;
        break;
      case MaterialFileType.link:
        typeIcon = Icons.link;
        iconColor = Colors.green;
        break;
      case MaterialFileType.doc:
        typeIcon = Icons.description;
        iconColor = Colors.blueAccent;
        break;
      default:
        typeIcon = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialViewerScreen(
              material: item,
              userName: widget.userName,
            ),
          ),
        );
        _loadAllData(); // Refresh to update status
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(typeIcon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    'Tipe: ${item.type.name.toUpperCase()}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              const Icon(Icons.check_circle, color: Colors.green, size: 24)
            else
              const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasTab(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final tasks = [
      {'id': 'task-1', 'title': 'Tugas 1: Implementasi Array', 'deadline': '20 Sep 2023, 23:59'},
      {'id': 'task-2', 'title': 'Tugas 2: Linked List Logic', 'deadline': '05 Okt 2023, 23:59'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final item = tasks[index];
        final submission = _assignmentSubmissions[item['id']];
        bool isDone = submission != null;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['title']!, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isDone ? 'Sudah Mengumpulkan' : 'Belum Selesai',
                      style: TextStyle(
                        color: isDone ? Colors.green : Colors.orange, 
                        fontSize: 10, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Deadline: ${item['deadline']}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              if (isDone) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.file_present, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        submission!.fileName,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    if (!isDone) {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UploadTugasScreen(
                            courseId: widget.courseId,
                            assignmentId: item['id']!,
                            taskTitle: item['title']!,
                            userName: widget.userName,
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadAllData(); // Refresh all data
                      }
                    } else {
                      _showSubmissionDetails(submission);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDone ? Colors.grey : AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isDone ? 'Lihat Tugas' : 'Upload Tugas', 
                    style: TextStyle(color: isDone ? Colors.grey : AppColors.primary)
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubmissionDetails(AssignmentSubmission submission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Detail Pengumpulan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('File', submission.fileName),
            _buildDetailRow('Tipe', submission.fileType),
            _buildDetailRow('Ukuran', '${(submission.fileSize / 1024).toStringAsFixed(2)} KB'),
            _buildDetailRow('Waktu', submission.uploadTime.toString().split('.')[0]),
            _buildDetailRow('Status', submission.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildKuisTab(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 80, color: AppColors.primary.withOpacity(0.2)),
            const SizedBox(height: 16),
            const Text('Belum ada kuis yang tersedia.', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _quizzes.length,
      itemBuilder: (context, index) {
        final quiz = _quizzes[index];
        final submission = _submissions[quiz.id];
        final bool isDone = submission != null;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isDone ? 'Sudah Dikerjakan' : 'Tersedia',
                      style: TextStyle(
                        color: isDone ? Colors.green : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                quiz.description,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Durasi: ${quiz.durationMinutes} Menit',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.help_outline, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.questions.length} Soal',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              if (isDone) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nilai: ${submission.score}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizResultScreen(
                              quiz: quiz,
                              submission: submission,
                            ),
                          ),
                        );
                      },
                      child: const Text('Lihat Detail'),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPlayScreen(
                            quiz: quiz,
                            userName: widget.userName,
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadAllData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Mulai Kuis'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
