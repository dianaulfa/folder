import 'dart:convert';

enum MaterialFileType {
  pdf,
  video,
  link,
  doc,
  other
}

class MaterialItem {
  final String id;
  final String title;
  final MaterialFileType type;
  final String contentUrl;
  final String description;

  MaterialItem({
    required this.id,
    required this.title,
    required this.type,
    required this.contentUrl,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'contentUrl': contentUrl,
      'description': description,
    };
  }

  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: MaterialFileType.values.byName(map['type'] ?? 'other'),
      contentUrl: map['contentUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

class MeetingSection {
  final String id;
  final String title;
  final List<MaterialItem> materials;

  MeetingSection({
    required this.id,
    required this.title,
    required this.materials,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'materials': materials.map((x) => x.toMap()).toList(),
    };
  }

  factory MeetingSection.fromMap(Map<String, dynamic> map) {
    return MeetingSection(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      materials: List<MaterialItem>.from(
        (map['materials'] as List<dynamic>).map((x) => MaterialItem.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }
}

class MaterialStatus {
  final String studentId;
  final String materialId;
  final bool isOpened;
  final DateTime lastOpened;

  MaterialStatus({
    required this.studentId,
    required this.materialId,
    this.isOpened = false,
    required this.lastOpened,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'materialId': materialId,
      'isOpened': isOpened,
      'lastOpened': lastOpened.toIso8601String(),
    };
  }

  factory MaterialStatus.fromMap(Map<String, dynamic> map) {
    return MaterialStatus(
      studentId: map['studentId'] ?? '',
      materialId: map['materialId'] ?? '',
      isOpened: map['isOpened'] ?? false,
      lastOpened: DateTime.parse(map['lastOpened']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaterialStatus.fromJson(String source) => MaterialStatus.fromMap(json.decode(source));
}
