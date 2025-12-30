import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';
import 'models/user_profile.dart';
import 'services/profile_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _profileService.getProfile(widget.userName);
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 16),
            _buildDescriptionSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 32, left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              backgroundImage: _profile?.profilePicturePath != null 
                  ? FileImage(File(_profile!.profilePicturePath!)) 
                  : null,
              child: _profile?.profilePicturePath == null
                  ? const Icon(Icons.person, size: 65, color: AppColors.primary)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _profile?.fullName ?? widget.userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_profile?.program}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'NIM: ${_profile?.nim}',
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, 'Email', _profile?.email ?? ''),
          const Divider(height: 32, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildInfoRow(Icons.phone_android_outlined, 'Nomor Telepon', _profile?.phone ?? ''),
          const Divider(height: 32, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildInfoRow(Icons.public, 'Negara', _profile?.country ?? ''),
          const Divider(height: 32, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildInfoRow(Icons.school_outlined, 'Fakultas', _profile?.faculty ?? ''),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Diri',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _profile?.description ?? '-',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_profile != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(profile: _profile!),
                    ),
                  );
                  if (result != null && result is UserProfile) {
                    setState(() => _profile = result);
                  }
                }
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar (Log Out)', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
