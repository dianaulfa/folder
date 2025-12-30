import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _isDownloading = false;
  double _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    _markAsOpened();
  }

  Future<void> _markAsOpened() async {
    await _materialService.markAsOpened(widget.userName, widget.material.id);
  }

  Future<void> _downloadFile() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final fileName = widget.material.title.replaceAll(' ', '_') + (widget.material.type == MaterialFileType.pdf ? '.pdf' : '.pptx');
      final savePath = '${dir.path}/$fileName';

      await dio.download(
        widget.material.contentUrl,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = count / total;
            });
          }
        },
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mengunduh ${widget.material.title} ke $savePath'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunduh file: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.material.title, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: _isDownloading 
              ? SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(
                    value: _downloadProgress, 
                    strokeWidth: 2, 
                    color: Colors.white
                  )
                )
              : const Icon(Icons.download),
            onPressed: _isDownloading ? null : _downloadFile,
            tooltip: 'Unduh File',
          ),
        ],
      ),
      body: widget.material.type == MaterialFileType.pdf
          ? _buildPdfViewer()
          : widget.material.type == MaterialFileType.ppt
              ? _buildSlideViewer()
              : _buildDefaultViewer(),
    );
  }

  Widget _buildPdfViewer() {
    return SfPdfViewer.network(
      widget.material.contentUrl,
      canShowScrollHead: true,
      canShowPaginationDialog: true,
    );
  }

  Widget _buildSlideViewer() {
    final slides = widget.material.slideUrls ?? [widget.material.contentUrl];
    
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: _SlideViewer(urls: slides),
          ),
        ),
        _buildMaterialInfo(),
      ],
    );
  }

  Widget _buildDefaultViewer() {
    IconData typeIcon;
    Color iconColor;

    switch (widget.material.type) {
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

    return SingleChildScrollView(
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
          _buildMaterialInfo(),
          const SizedBox(height: 40),
          _buildActionButton(context, iconColor),
        ],
      ),
    );
  }

  Widget _buildMaterialInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.material.title,
            style: const TextStyle(
              fontSize: 20,
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
        ],
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
      case MaterialFileType.link:
        label = 'Buka Tautan';
        icon = Icons.open_in_new;
        break;
      default:
        label = 'Buka Materi';
        icon = Icons.visibility;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Add logic to open links or play video if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Membuka ${widget.material.type.name}...')),
          );
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _SlideViewer extends StatefulWidget {
  final List<String> urls;

  const _SlideViewer({required this.urls});

  @override
  State<_SlideViewer> createState() => _SlideViewerState();
}

class _SlideViewerState extends State<_SlideViewer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.urls.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Image.network(
                widget.urls[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
                errorBuilder: (context, error, stackTrace) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 48),
                    SizedBox(height: 16),
                    Text('Gagal memuat slide', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        ),
        // Controls
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40),
                  onPressed: _currentPage > 0 
                    ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300), 
                        curve: Curves.easeInOut
                      )
                    : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPage + 1} / ${widget.urls.length}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white, size: 40),
                  onPressed: _currentPage < widget.urls.length - 1
                    ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300), 
                        curve: Curves.easeInOut
                      )
                    : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
