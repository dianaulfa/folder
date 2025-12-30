import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../courses/my_classes_screen.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../announcements/announcement_list_screen.dart';
import '../announcements/announcement_detail_screen.dart';
import '../announcements/services/announcement_service.dart';
import '../announcements/models/announcement_model.dart';
import '../courses/models/course_model.dart';
import '../courses/services/course_service.dart';
import '../profile/models/user_profile.dart';
import '../profile/services/profile_service.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({super.key, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final AnnouncementService _announcementService = AnnouncementService();
  final CourseService _courseService = CourseService();
  final ProfileService _profileService = ProfileService();
  List<Announcement> _latestAnnouncements = [];
  List<Course> _latestCourses = [];
  UserProfile? _userProfile;
  bool _isAnnouncementsLoading = true;
  bool _isCoursesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadLatestAnnouncements(),
      _loadLatestCourses(),
      _loadProfile(),
    ]);
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.getProfile(widget.userName);
    setState(() {
      _userProfile = profile;
    });
  }

  Future<void> _loadLatestAnnouncements() async {
    setState(() => _isAnnouncementsLoading = true);
    final data = await _announcementService.getLatestAnnouncements(2);
    setState(() {
      _latestAnnouncements = data;
      _isAnnouncementsLoading = false;
    });
  }

  Future<void> _loadLatestCourses() async {
    setState(() => _isCoursesLoading = true);
    final data = await _courseService.getLatestProgressCourses(2);
    setState(() {
      _latestCourses = data;
      _isCoursesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Kelas Saya'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Notifikasi'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return MyClassesScreen(userName: widget.userName);
      case 2:
        return NotificationScreen(userName: widget.userName);
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        // App Bar / Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFFE57373)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      _userProfile?.fullName ?? widget.userName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    backgroundImage: _userProfile?.profilePicturePath != null
                        ? FileImage(File(_userProfile!.profilePicturePath!))
                        : null,
                    child: _userProfile?.profilePicturePath == null
                        ? const Icon(Icons.person, color: Colors.white, size: 32)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Upcoming Assignment Card
              _buildSectionHeader('Tugas yang Akan Datang'),
              const SizedBox(height: 12),
              _buildUpcomingTaskCard(),
              
              const SizedBox(height: 32),

              // Recent Announcements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Pengumuman Terbaru'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AnnouncementListScreen()),
                      );
                    },
                    child: const Text('Lihat Semua', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAnnouncementList(),

              const SizedBox(height: 32),

              // Class Progress
              _buildSectionHeader('Progres Kelas'),
              const SizedBox(height: 12),
              _buildProgressList(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildUpcomingTaskCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.assignment, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculus II: Assignment 4',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Matematika Teknik',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    'Deadline: Besok, 23:59',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Kerjakan', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementList() {
    if (_isAnnouncementsLoading) {
      return const Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CircularProgressIndicator(),
      ));
    }

    if (_latestAnnouncements.isEmpty) {
      return const Center(child: Text('Tidak ada pengumuman.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return Column(
      children: _latestAnnouncements.map((announcement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAnnouncementItem(announcement),
        );
      }).toList(),
    );
  }

  Widget _buildAnnouncementItem(Announcement announcement) {
    IconData typeIcon;
    Color typeColor;

    switch (announcement.type) {
      case AnnouncementType.urgent:
        typeIcon = Icons.error_outline;
        typeColor = Colors.red;
        break;
      case AnnouncementType.event:
        typeIcon = Icons.event;
        typeColor = Colors.orange;
        break;
      case AnnouncementType.academic:
        typeIcon = Icons.school;
        typeColor = Colors.blue;
        break;
      default:
        typeIcon = Icons.info_outline;
        typeColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailScreen(announcement: announcement),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(typeIcon, color: typeColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title, 
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${announcement.author} • ${DateFormat('dd MMM').format(announcement.publishedAt)}', 
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressList() {
    if (_isCoursesLoading) {
      return const Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CircularProgressIndicator(),
      ));
    }

    if (_latestCourses.isEmpty) {
      return const Center(child: Text('Tidak ada kelas aktif.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return Column(
      children: _latestCourses.map((course) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildProgressItem(course),
        );
      }).toList(),
    );
  }

  Widget _buildProgressItem(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              Text(course.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(course.progress * 100).toInt()}%', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: course.progress,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
