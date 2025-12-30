import 'dart:convert';

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String program;
  final String faculty;
  final String nim;
  final String country;
  final String description;
  final String? profilePicturePath;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.program,
    required this.faculty,
    required this.nim,
    required this.country,
    required this.description,
    this.profilePicturePath,
  });

  String get fullName => '$firstName $lastName';

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? program,
    String? faculty,
    String? nim,
    String? country,
    String? description,
    String? profilePicturePath,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      program: program ?? this.program,
      faculty: faculty ?? this.faculty,
      nim: nim ?? this.nim,
      country: country ?? this.country,
      description: description ?? this.description,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'program': program,
      'faculty': faculty,
      'nim': nim,
      'country': country,
      'description': description,
      'profilePicturePath': profilePicturePath,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      program: map['program'] ?? '',
      faculty: map['faculty'] ?? '',
      nim: map['nim'] ?? '',
      country: map['country'] ?? '',
      description: map['description'] ?? '',
      profilePicturePath: map['profilePicturePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));
}
