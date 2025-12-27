import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'class_detail_screen.dart';
import '../profile/profile_screen.dart';

class MyClassesScreen extends StatelessWidget {
  final String userName;

  const MyClassesScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // Mock data for classes
    final List<Map<String, dynamic>> classes = [
      {'name': 'Algoritma & Pemrograman', 'code': 'IF-101', 'progress': 0.75},
      {'name': 'Matematika Teknik II', 'code': 'MA-202', 'progress': 0.40},
      {'name': 'Basis Data', 'code': 'CS-305', 'progress': 0.90},
      {'name': 'Fisika Dasar I', 'code': 'FI-111', 'progress': 0.20},
      {'name': 'Statistika & Probabilitas', 'code': 'ST-201', 'progress': 0.55},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelas Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userName: userName),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final course = classes[index];
          return _buildClassCard(context, course);
        },
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ClassDetailScreen(
                courseId: course['code'],
                courseName: course['name'],
                userName: userName,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course['code'],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(course['progress'] * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: course['progress'],
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
