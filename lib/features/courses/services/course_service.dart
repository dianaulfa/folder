import '../models/course_model.dart';

class CourseService {
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal();

  final List<Course> _mockCourses = [
    Course(
      id: 'IF-101',
      name: 'Algoritma & Pemrograman',
      code: 'IF-101',
      semester: 'Semester 1',
      progress: 0.75,
      imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=800&q=80', // Programming/Code
    ),
    Course(
      id: 'MA-202',
      name: 'Matematika Teknik II',
      code: 'MA-202',
      semester: 'Semester 2',
      progress: 0.40,
      imageUrl: 'https://images.unsplash.com/photo-1509228468518-180dd48219d1?w=800&q=80', // Math/Calculus
    ),
    Course(
      id: 'CS-305',
      name: 'Basis Data',
      code: 'CS-305',
      semester: 'Semester 3',
      progress: 0.90,
      imageUrl: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800&q=80', // Database/Storage
    ),
    Course(
      id: 'FI-111',
      name: 'Fisika Dasar I',
      code: 'FI-111',
      semester: 'Semester 1',
      progress: 0.20,
      imageUrl: 'https://images.unsplash.com/photo-1636466484362-d49925699387?w=800&q=80', // Physics/Science
    ),
    Course(
      id: 'ST-201',
      name: 'Statistika & Probabilitas',
      code: 'ST-201',
      semester: 'Semester 2',
      progress: 0.55,
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bbbda536639a?w=800&q=80', // Statistics/Charts
    ),
    Course(
      id: 'UX-401',
      name: 'UI/UX Design',
      code: 'UX-401',
      semester: 'Semester 4',
      progress: 0.85,
      imageUrl: 'https://images.unsplash.com/photo-1586717791821-3f44a563eb4c?w=800&q=80', // Design/Interface
    ),
  ];

  Future<List<Course>> getEnrolledCourses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCourses;
  }

  Future<List<Course>> getLatestProgressCourses(int count) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCourses.take(count).toList();
  }
}
