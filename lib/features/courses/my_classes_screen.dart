import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'class_detail_screen.dart';
import '../profile/profile_screen.dart';
import 'models/course_model.dart';
import 'services/course_service.dart';
import '../profile/services/profile_service.dart';
import '../profile/models/user_profile.dart';
import 'dart:io';

class MyClassesScreen extends StatefulWidget {
  final String userName;

  const MyClassesScreen({super.key, required this.userName});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  final CourseService _courseService = CourseService();
  final ProfileService _profileService = ProfileService();
  List<Course> _courses = [];
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadCourses(),
      _loadProfile(),
    ]);
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.getProfile(widget.userName);
    setState(() {
      _userProfile = profile;
    });
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    final data = await _courseService.getEnrolledCourses();
    setState(() {
      _courses = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelas Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userName: widget.userName),
                ),
              );
              _loadProfile();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: _userProfile?.profilePicturePath != null
                    ? FileImage(File(_userProfile!.profilePicturePath!))
                    : null,
                child: _userProfile?.profilePicturePath == null
                    ? const Icon(Icons.person, size: 20, color: AppColors.primary)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCourses,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return _buildClassCard(context, _courses[index]);
                },
              ),
            ),
    );
  }

  Widget _buildClassCard(BuildContext context, Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClassDetailScreen(
                  courseId: course.code,
                  courseName: course.name,
                  userName: widget.userName,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Thumbnail
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      course.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.broken_image, color: AppColors.primary),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Text(
                        course.code,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.semester,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${(course.progress * 100).toInt()}%',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: course.progress,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Progres pembelajaran',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
