import 'package:shared_preferences/shared_preferences.dart';
import '../models/material_models.dart';

class MaterialService {
  static final MaterialService _instance = MaterialService._internal();
  factory MaterialService() => _instance;
  MaterialService._internal();

  static const String _statusKey = 'material_status';

  // Mock data grouped by courseId
  final Map<String, List<MeetingSection>> _mockMaterials = {
    'IF-101': [
      MeetingSection(
        id: 'if101-m1',
        title: 'Pertemuan 1: Pengenalan Algoritma',
        materials: [
          MaterialItem(
            id: 'mat-1',
            title: 'Silabus Perkuliahan',
            type: MaterialFileType.pdf,
            contentUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
            description: 'Silabus perkuliahan untuk satu semester ke depan.',
          ),
          MaterialItem(
            id: 'mat-1-ppt',
            title: 'Slide Pengenalan PPT',
            type: MaterialFileType.ppt,
            contentUrl: 'https://example.com/slide-pengenalan.pptx',
            slideUrls: [
              'https://picsum.photos/seed/slide1/800/600',
              'https://picsum.photos/seed/slide2/800/600',
              'https://picsum.photos/seed/slide3/800/600',
            ],
            description: 'Slide presentasi pengenalan algoritma dalam bentuk slide viewer.',
          ),
          MaterialItem(
            id: 'mat-2',
            title: 'Video Pengenalan Algoritma',
            type: MaterialFileType.video,
            contentUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            description: 'Penjelasan awal mengenai apa itu algoritma dan cara kerjanya.',
          ),
          MaterialItem(
            id: 'mat-3',
            title: 'Materi PDF - Dasar Pemrograman',
            type: MaterialFileType.pdf,
            contentUrl: 'https://www.adobe.com/support/products/enterprise/knowledgecenter/whitepapers/pdf/developing_with_pdf.pdf',
            description: 'Slide materi mengenai dasar-dasar pemrograman.',
          ),
        ],
      ),
      MeetingSection(
        id: 'if101-m2',
        title: 'Pertemuan 2: Struktur Data Dasar',
        materials: [
          MaterialItem(
            id: 'mat-4',
            title: 'Modul Praktikum 1',
            type: MaterialFileType.pdf,
            contentUrl: 'https://example.com/modul-1.pdf',
            description: 'Panduan praktikum untuk pertemuan kedua.',
          ),
          MaterialItem(
            id: 'mat-5',
            title: 'Link Referensi Eksternal',
            type: MaterialFileType.link,
            contentUrl: 'https://dart.dev/guides',
            description: 'Dokumentasi resmi bahasa pemrograman Dart.',
          ),
        ],
      ),
    ],
    'MA-202': [
      MeetingSection(
        id: 'ma202-m1',
        title: 'Pertemuan 1: Turunan Fungsi Aljabar',
        materials: [
          MaterialItem(
            id: 'mat-6',
            title: 'Materi Turunan PDF',
            type: MaterialFileType.pdf,
            contentUrl: 'https://example.com/turunan.pdf',
          ),
          MaterialItem(
            id: 'mat-7',
            title: 'Video Tutorial Turunan',
            type: MaterialFileType.video,
            contentUrl: 'https://example.com/video-turunan',
          ),
        ],
      ),
    ],
    'CS-305': [
       MeetingSection(
        id: 'cs305-m1',
        title: 'Pertemuan 1: Pengenalan Basis Data',
        materials: [
          MaterialItem(
            id: 'mat-8',
            title: 'Slide Pengenalan Basis Data',
            type: MaterialFileType.pdf,
            contentUrl: 'https://example.com/db-intro.pdf',
          ),
        ],
      ),
    ]
  };

  Future<List<MeetingSection>> getMaterialsByCourse(String courseId) async {
    // Return mock data or empty list if not found
    return _mockMaterials[courseId] ?? [];
  }

  Future<void> markAsOpened(String studentId, String materialId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> statusesJson = prefs.getStringList(_statusKey) ?? [];
    
    // Remove existing to update
    statusesJson.removeWhere((jsonStr) {
      final existing = MaterialStatus.fromJson(jsonStr);
      return existing.studentId == studentId && existing.materialId == materialId;
    });

    final newStatus = MaterialStatus(
      studentId: studentId,
      materialId: materialId,
      isOpened: true,
      lastOpened: DateTime.now(),
    );

    statusesJson.add(newStatus.toJson());
    await prefs.setStringList(_statusKey, statusesJson);
  }

  Future<bool> isOpened(String studentId, String materialId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> statusesJson = prefs.getStringList(_statusKey) ?? [];
    
    for (var jsonStr in statusesJson) {
      final status = MaterialStatus.fromJson(jsonStr);
      if (status.studentId == studentId && status.materialId == materialId) {
        return status.isOpened;
      }
    }
    return false;
  }
}
