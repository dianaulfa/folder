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
        appBar: AppBar(
          title: Text(courseName, style: const TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Materi'),
              Tab(text: 'Tugas'),
              Tab(text: 'Progres'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Daftar Materi Pembelajaran')),
            Center(child: Text('Daftar Tugas dan Kuis')),
            Center(child: Text('Progres Pembelajaran Mata Kuliah')),
          ],
        ),
      ),
    );
  }
}
