import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ClassDetailScreen extends StatelessWidget {
  final String courseName;

  const ClassDetailScreen({super.key, required this.courseName});

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
                  courseName,
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
    final sections = [
      {
        'section': 'Pertemuan 1: Pengenalan Algoritma',
        'items': [
          {'title': 'Silabus Perkuliahan', 'type': 'PDF', 'status': 'Selesai'},
          {'title': 'Video Pengenalan Algoritma', 'type': 'Video', 'status': 'Belum Selesai'},
          {'title': 'Materi PDF - Dasar Pemrograman', 'type': 'PDF', 'status': 'Selesai'},
        ]
      },
      {
        'section': 'Pertemuan 2: Struktur Data Dasar',
        'items': [
          {'title': 'Modul Praktikum 1', 'type': 'PDF', 'status': 'Belum Dibuka'},
          {'title': 'Link Referensi Eksternal', 'type': 'Link', 'status': 'Belum Dibuka'},
        ]
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final items = section['items'] as List<Map<String, String>>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                section['section'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
            ),
            ...items.map((item) => _buildMaterialItem(item)).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildMaterialItem(Map<String, String> item) {
    bool isCompleted = item['status'] == 'Selesai';
    IconData typeIcon;
    Color iconColor;

    switch (item['type']) {
      case 'PDF':
        typeIcon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'Video':
        typeIcon = Icons.play_circle_fill;
        iconColor = Colors.blue;
        break;
      case 'Link':
        typeIcon = Icons.link;
        iconColor = Colors.green;
        break;
      default:
        typeIcon = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
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
                  item['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  'Tipe: ${item['type']}',
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
    );
  }

  Widget _buildTugasTab(BuildContext context) {
    final tasks = [
      {'title': 'Tugas 1: Implementasi Array', 'deadline': '20 Sep 2023, 23:59', 'status': 'Sudah Dikumpulkan'},
      {'title': 'Tugas 2: Linked List Logic', 'deadline': '05 Okt 2023, 23:59', 'status': 'Belum Selesai'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final item = tasks[index];
        bool isDone = item['status'] == 'Sudah Dikumpulkan';
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['status']!,
                      style: TextStyle(color: isDone ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDone ? Colors.grey : AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(isDone ? 'Lihat Tugas' : 'Upload Tugas', style: TextStyle(color: isDone ? Colors.grey : AppColors.primary)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKuisTab(BuildContext context) {
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
}
