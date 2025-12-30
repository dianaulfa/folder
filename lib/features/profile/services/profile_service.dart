import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileService {
  static const String _key = 'user_profile';
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  Future<UserProfile> getProfile(String defaultName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    
    if (data == null) {
      // Default profile if none exists
      return UserProfile(
        firstName: defaultName.split(' ').first,
        lastName: defaultName.contains(' ') ? defaultName.split(' ').sublist(1).join(' ') : '',
        email: '${defaultName.toLowerCase().replaceAll(' ', '.')}@university.ac.id',
        phone: '+62 812 3456 7890',
        address: 'Jl. Kampus Merdeka No. 123',
        program: 'S1 Teknik Informatika',
        faculty: 'Fakultas Teknologi Informasi',
        nim: '21010123456',
        country: 'Indonesia',
        description: 'Mahasiswa yang berfokus pada pengembangan aplikasi mobile dan kecerdasan buatan.',
      );
    }
    
    return UserProfile.fromJson(data);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, profile.toJson());
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
