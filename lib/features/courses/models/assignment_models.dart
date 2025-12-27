import 'dart:convert';

class Assignment {
  final String id;
  final String courseId;
  final String title;
  final String deadline;
  final String description;

  Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.deadline,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'deadline': deadline,
      'description': description,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      deadline: map['deadline'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) => Assignment.fromMap(json.decode(source));
}

class AssignmentSubmission {
  final String studentId;
  final String courseId;
  final String assignmentId;
  final String fileName;
  final String fileType;
  final int fileSize; // in bytes
  final String filePath;
  final DateTime uploadTime;
  final String status;

  AssignmentSubmission({
    required this.studentId,
    required this.courseId,
    required this.assignmentId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.filePath,
    required this.uploadTime,
    this.status = 'Sudah Mengumpulkan',
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'assignmentId': assignmentId,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'filePath': filePath,
      'uploadTime': uploadTime.toIso8601String(),
      'status': status,
    };
  }

  factory AssignmentSubmission.fromMap(Map<String, dynamic> map) {
    return AssignmentSubmission(
      studentId: map['studentId'] ?? '',
      courseId: map['courseId'] ?? '',
      assignmentId: map['assignmentId'] ?? '',
      fileName: map['fileName'] ?? '',
      fileType: map['fileType'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      filePath: map['filePath'] ?? '',
      uploadTime: DateTime.parse(map['uploadTime']),
      status: map['status'] ?? 'Sudah Mengumpulkan',
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignmentSubmission.fromJson(String source) =>
      AssignmentSubmission.fromMap(json.decode(source));
}
