import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import 'models/user_profile.dart';
import 'services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _countryController;
  late TextEditingController _descriptionController;
  String? _tempImagePath;
  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.profile.firstName);
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _emailController = TextEditingController(text: widget.profile.email);
    _countryController = TextEditingController(text: widget.profile.country);
    _descriptionController = TextEditingController(text: widget.profile.description);
    _tempImagePath = widget.profile.profilePicturePath;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _tempImagePath = image.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    final updatedProfile = widget.profile.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      country: _countryController.text,
      description: _descriptionController.text,
      profilePicturePath: _tempImagePath,
    );

    await _profileService.saveProfile(updatedProfile);
    if (mounted) {
      Navigator.pop(context, updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 32),
            _buildTextField('Nama Pertama', _firstNameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Nama Terakhir', _lastNameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Email', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField('Negara', _countryController, Icons.public),
            const SizedBox(height: 16),
            _buildTextField('Deskripsi', _descriptionController, Icons.description_outlined, maxLines: 4),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: _tempImagePath != null ? FileImage(File(_tempImagePath!)) : null,
              child: _tempImagePath == null
                  ? const Icon(Icons.person, size: 70, color: Colors.grey)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, 
      {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: const Text(
          'Simpan Perubahan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
