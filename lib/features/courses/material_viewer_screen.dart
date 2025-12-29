import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'models/material_models.dart';
import 'services/material_service.dart';

class MaterialViewerScreen extends StatefulWidget {
  final MaterialItem material;
  final String userName;

  const MaterialViewerScreen({
    super.key,
    required this.material,
    required this.userName,
  });

  @override
  State<MaterialViewerScreen> createState() => _MaterialViewerScreenState();
}

class _MaterialViewerScreenState extends State<MaterialViewerScreen> {
  final MaterialService _materialService = MaterialService();

  @override
  void initState() {
    super.initState();
    // Mark as opened automatically when screen is shown
    _markAsOpened();
  }

  Future<void> _markAsOpened() async {
    await _materialService.markAsOpened(widget.userName, widget.material.id);
  }

  @override
  Widget build(BuildContext context) {
    IconData typeIcon;
    Color iconColor;

    switch (widget.material.type) {
      case MaterialFileType.pdf:
        typeIcon = Icons.picture_as_pdf;
        iconColor = Colors.red;
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.material.type.name.toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, size: 80, color: iconColor),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.material.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.material.type.name.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.material.description.isEmpty 
                ? 'Tidak ada deskripsi tambahan untuk materi ini.' 
                : widget.material.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            _buildActionButton(context, iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Color color) {
    String label;
    IconData icon;

    switch (widget.material.type) {
      case MaterialFileType.video:
        label = 'Putar Video';
        icon = Icons.play_arrow;
        break;
      case MaterialFileType.pdf:
      case MaterialFileType.doc:
        label = 'Buka Dokumen';
        icon = Icons.file_open;
        break;
      case MaterialFileType.link:
        label = 'Buka Tautan';
        icon = Icons.open_in_new;
        break;
      default:
        label = 'Lihat Materi';
        icon = Icons.visibility;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Membuka ${widget.material.title}...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}
