import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UploadTugasScreen extends StatefulWidget {
  final String taskTitle;

  const UploadTugasScreen({super.key, required this.taskTitle});

  @override
  State<UploadTugasScreen> createState() => _UploadTugasScreenState();
}

class _UploadTugasScreenState extends State<UploadTugasScreen> {
  bool _isFileSelected = false;
  String _fileName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Upload Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task Header
            Text(
              widget.taskTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Implementasikan solusi lengkap sesuai dengan petunjuk yang diberikan di modul. Pastikan file dalam format PDF dan ukuran maksimal 10MB.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Upload Area
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.none, // We'll use a custom painter if we want real dashes, but this is fine for now
                  ),
                ),
                child: CustomPaint(
                  painter: DashPainter(color: AppColors.primary.withOpacity(0.3)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isFileSelected ? Icons.insert_drive_file : Icons.cloud_upload_outlined,
                          size: 64,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isFileSelected ? _fileName : 'Ketuk untuk pilih file',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isFileSelected ? 'File telah dipilih' : '(PDF, Max 10MB)',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Submit Button
            ElevatedButton(
              onPressed: _isFileSelected ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Kumpulkan Tugas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Bantuan',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFile() {
    // Simulate file picking
    setState(() {
      _isFileSelected = true;
      _fileName = 'JAWABAN_${widget.taskTitle.replaceAll(' ', '_')}.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File terpilih: mockup_file.pdf')),
    );
  }

  void _handleSubmit() {
    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil!'),
        content: const Text('Tugas Anda telah berhasil dikumpulkan.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to detail
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Simple dash painter for the upload area
class DashPainter extends CustomPainter {
  final Color color;
  DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    RRect rrect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(20));
    Path path = Path()..addRRect(rrect);

    for (double i = 0; i < path.computeMetrics().first.length; i += dashWidth + dashSpace) {
      canvas.drawPath(
        path.computeMetrics().first.extractPath(i, i + dashWidth),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
