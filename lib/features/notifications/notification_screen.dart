import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for notifications
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Tugas Baru: Algoritma & Pemrograman',
        'desc': 'Dosen telah merilis Tugas 2 di Pertemuan 4.',
        'time': '3 jam lalu',
        'type': 'Tugas',
        'isRead': false,
      },
      {
        'title': 'Kuis Mendatang: Matematika Teknik II',
        'desc': 'Jangan lupa Kuis 1 akan dilaksanakan besok jam 08:00.',
        'time': '5 jam lalu',
        'type': 'Kuis',
        'isRead': false,
      },
      {
        'title': 'Pengumuman: Libur Nasional',
        'desc': 'Kegiatan perkuliahan ditiadakan pada hari Senin depan.',
        'time': '1 hari lalu',
        'type': 'Pengumuman',
        'isRead': true,
      },
      {
        'title': 'Tugas Dinilai: Basis Data',
        'desc': 'Tugas 1 Anda telah dinilai oleh Dosen. Nilai: 95/100.',
        'time': '2 hari lalu',
        'type': 'Tugas',
        'isRead': true,
      },
      {
        'title': 'Materi Baru: Fisika Dasar I',
        'desc': 'Modul PDF Pertemuan 3 telah diunggah.',
        'time': '3 hari lalu',
        'type': 'Pengumuman',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Tandai Semua Dibaca', style: TextStyle(color: AppColors.primary, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return _buildNotificationItem(item);
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    IconData icon;
    Color color;

    switch (item['type']) {
      case 'Tugas':
        icon = Icons.assignment_outlined;
        color = Colors.blue;
        break;
      case 'Kuis':
        icon = Icons.quiz_outlined;
        color = Colors.orange;
        break;
      case 'Pengumuman':
        icon = Icons.campaign_outlined;
        color = AppColors.primary;
        break;
      default:
        icon = Icons.notifications_none;
        color = Colors.grey;
    }

    bool isRead = item['isRead'];

    return Container(
      decoration: BoxDecoration(
        color: isRead ? Colors.white : AppColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? Colors.grey.shade100 : AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item['title'],
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item['desc'],
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['time'],
              style: TextStyle(
                fontSize: 11,
                color: isRead ? Colors.grey : AppColors.primary.withOpacity(0.7),
                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ],
        ),
        onTap: () {
          // Action for clicking notification
        },
      ),
    );
  }
}
