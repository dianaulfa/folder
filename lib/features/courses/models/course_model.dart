class Course {
  final String id;
  final String name;
  final String code;
  final String semester;
  final double progress;
  final String imageUrl;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.semester,
    required this.progress,
    required this.imageUrl,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      semester: map['semester'] ?? '',
      progress: (map['progress'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
