import '../models/announcement_model.dart';

class AnnouncementService {
  static final AnnouncementService _instance = AnnouncementService._internal();
  factory AnnouncementService() => _instance;
  AnnouncementService._internal();

  final List<Announcement> _mockAnnouncements = [
    Announcement(
      id: 'ann-1',
      title: 'Pembayaran UKT Semester Genap 2025',
      author: 'Admin Akademik',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      content: 'Diberitahukan kepada seluruh mahasiswa bahwa periode pembayaran UKT untuk Semester Genap 2025 akan dimulai pada tanggal 5 Januari hingga 20 Januari 2025. Harap melakukan pembayaran tepat waktu melalui bank mitra yang telah ditentukan.\n\nPastikan Anda menyimpan bukti pembayaran untuk keperluan registrasi ulang dan pengisian KRS.',
      imageUrl: 'https://picsum.photos/seed/ukt2025/1200/600',
      type: AnnouncementType.urgent,
    ),
    Announcement(
      id: 'ann-2',
      title: 'Workshop Flutter Advanced Performance',
      author: 'Himpunan Mahasiswa IT',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      content: 'Kami mengundang Anda untuk mengikuti workshop "Advanced Performance with Flutter" yang akan dibawakan oleh Google Developer Expert. Workshop ini akan membahas teknik optimasi aplikasi Flutter dan manajemen state yang efisien.\n\nTanggal: 15 Januari 2025\nTempat: Aula Gedung C, Lantai 3\nPendaftaran dapat dilakukan melalui link bit.ly/workshop-it-2025.',
      imageUrl: 'https://picsum.photos/seed/flutter/1200/600',
      type: AnnouncementType.event,
    ),
    Announcement(
      id: 'ann-3',
      title: 'Perubahan Jadwal Ujian Tengah Semester',
      author: 'BAAK',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      content: 'Terdapat perubahan jadwal untuk beberapa mata kuliah pada Ujian Tengah Semester ini. Mohon periksa kembali jadwal Anda melalui menu Jadwal di portal akademik atau unduh file revisi jadwal pada tautan di bawah.\n\nPerubahan ini meliputi pemindahan jam ujian dan perpindahan ruangan untuk menghindari penumpukan di blok ruang tertentu.',
      imageUrl: 'https://picsum.photos/seed/exam/1200/600',
      type: AnnouncementType.academic,
    ),
    Announcement(
      id: 'ann-4',
      title: 'Layanan Perpustakaan Digital Baru',
      author: 'Pustakawan Utama',
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      content: 'Kabar gembira! Kini mahasiswa dapat mengakses ribuan koleksi e-book dan jurnal internasional melalui portal perpustakaan digital kami yang baru. Gunakan akun SSO Anda untuk login dan nikmati akses literatur berkualitas dari mana saja.',
      imageUrl: 'https://picsum.photos/seed/library/1200/600',
      type: AnnouncementType.info,
    ),
  ];

  Future<List<Announcement>> getAllAnnouncements() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAnnouncements;
  }

  Future<List<Announcement>> getLatestAnnouncements(int count) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockAnnouncements.take(count).toList();
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockAnnouncements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}
