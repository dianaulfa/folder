import 'dart:convert';

enum AnnouncementType {
  info,
  event,
  academic,
  urgent
}

class Announcement {
  final String id;
  final String title;
  final String author;
  final DateTime publishedAt;
  final String content;
  final String? imageUrl;
  final AnnouncementType type;

  Announcement({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedAt,
    required this.content,
    this.imageUrl,
    this.type = AnnouncementType.info,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'imageUrl': imageUrl,
      'type': type.name,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publishedAt: DateTime.parse(map['publishedAt']),
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      type: AnnouncementType.values.byName(map['type'] ?? 'info'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Announcement.fromJson(String source) => Announcement.fromMap(json.decode(source));
}
