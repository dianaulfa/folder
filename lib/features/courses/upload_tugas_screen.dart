import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_theme.dart';
import 'models/assignment_models.dart';
import 'services/assignment_service.dart';

class UploadTugasScreen extends StatefulWidget {
  final String courseId;
  final String assignmentId;
  final String taskTitle;
  final String userName;

  const UploadTugasScreen({
    super.key,
    required this.courseId,
    required this.assignmentId,
    required this.taskTitle,
    required this.userName,
  });

  @override
  State<UploadTugasScreen> createState() => _UploadTugasScreenState();
}

class _UploadTugasScreenState extends State<UploadTugasScreen> {
  final AssignmentService _assignmentService = AssignmentService();
  final List<PlatformFile> _selectedFiles = [];
  bool _isUploading = false;

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
              'Silakan unggah dokumen jawaban Anda. Pastikan nama file jelas dan format sesuai ketentuan.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Batas ukuran file: 10 MB (Format: PDF, DOCX, ZIP, JPG, PNG)',
                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Upload Area
            GestureDetector(
              onTap: _isUploading ? null : _pickFile,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomPaint(
                  painter: DashPainter(color: AppColors.primary.withOpacity(0.3)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Pilih File untuk Diupload',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isUploading ? 'Sedang memproses...' : 'Mendukung berbagai format file',
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
            const SizedBox(height: 32),

            // File List
            if (_selectedFiles.isNotEmpty) ...[
              const Text(
                'File yang dipilih:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ..._selectedFiles.map((file) => _buildFileItem(file)).toList(),
              const SizedBox(height: 32),
            ],

            // Submit Button
            ElevatedButton(
              onPressed: (_selectedFiles.isNotEmpty && !_isUploading) ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Submit / Simpan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(PlatformFile file) {
    String fileSize = (file.size / (1024 * 1024)).toStringAsFixed(2) + ' MB';
    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = AppColors.primary;

    if (file.extension?.toLowerCase() == 'pdf') {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (['jpg', 'jpeg', 'png'].contains(file.extension?.toLowerCase())) {
      fileIcon = Icons.image;
      iconColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(fileIcon, color: iconColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fileSize,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeFile(file),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'zip', 'jpg', 'jpeg', 'png', 'ppt', 'pptx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // Validation: Max 10MB
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ukuran file maksimal 10 MB')),
            );
          }
          return;
        }

        setState(() {
          _selectedFiles.clear(); // Allowing one file per submission as per common patterns
          _selectedFiles.add(file);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih file: $e')),
        );
      }
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _selectedFiles.remove(file);
    });
  }

  Future<void> _handleSubmit() async {
    setState(() => _isUploading = true);

    try {
      final file = _selectedFiles.first;
      
      final submission = AssignmentSubmission(
        studentId: widget.userName,
        courseId: widget.courseId,
        assignmentId: widget.assignmentId,
        fileName: file.name,
        fileType: file.extension ?? 'unknown',
        fileSize: file.size,
        filePath: file.path ?? '',
        uploadTime: DateTime.now(),
      );

      await _assignmentService.submitAssignment(submission);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim tugas: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Text('Berhasil dikirim!'),
          ],
        ),
        content: const Text('Tugas Anda telah tersimpan dan berhasil dikirim ke dosen.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // dialog
              Navigator.of(context).pop(true); // screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Tutup', style: TextStyle(color: Colors.white)),
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
