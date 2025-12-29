import 'package:shared_preferences/shared_preferences.dart';
import '../models/assignment_models.dart';

class AssignmentService {
  static final AssignmentService _instance = AssignmentService._internal();
  factory AssignmentService() => _instance;
  AssignmentService._internal();

  static const String _submissionsKey = 'assignment_submissions';

  Future<void> submitAssignment(AssignmentSubmission submission) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> submissionsJson = prefs.getStringList(_submissionsKey) ?? [];
    
    // Check if user already submitted for this assignment to avoid duplicates/overwrite
    submissionsJson.removeWhere((jsonStr) {
      final existing = AssignmentSubmission.fromJson(jsonStr);
      return existing.studentId == submission.studentId && 
             existing.courseId == submission.courseId &&
             existing.assignmentId == submission.assignmentId;
    });

    submissionsJson.add(submission.toJson());
    await prefs.setStringList(_submissionsKey, submissionsJson);
  }

  Future<AssignmentSubmission?> getSubmission(String studentId, String courseId, String assignmentId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> submissionsJson = prefs.getStringList(_submissionsKey) ?? [];
    
    for (var jsonStr in submissionsJson) {
      final submission = AssignmentSubmission.fromJson(jsonStr);
      if (submission.studentId == studentId && 
          submission.courseId == courseId && 
          submission.assignmentId == assignmentId) {
        return submission;
      }
    }
    return null;
  }

  Future<List<AssignmentSubmission>> getSubmissionsByStudent(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> submissionsJson = prefs.getStringList(_submissionsKey) ?? [];
    
    return submissionsJson
        .map((jsonStr) => AssignmentSubmission.fromJson(jsonStr))
        .where((s) => s.studentId == studentId)
        .toList();
  }

  Future<List<AssignmentSubmission>> getSubmissionsByCourse(String studentId, String courseId) async {
    final submissions = await getSubmissionsByStudent(studentId);
    return submissions.where((s) => s.courseId == courseId).toList();
  }
}
