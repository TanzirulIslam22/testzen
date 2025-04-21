import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testzen/models/exam.dart';
class Test {
  final String id;
  final String title;
  final String description;
  final int duration; // in minutes
  final String createdBy;
  final Timestamp createdAt;
  final bool isActive;
  final bool isScheduled; // New field
  final String? scheduledExamId; // New field
  final List<String>? allowedStudentIds; // New field

  Test({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.createdBy,
    required this.createdAt,
    this.isActive = true,
    this.isScheduled = false, // Default to false
    this.scheduledExamId, // Null initially
    this.allowedStudentIds, // Null initially
  });

  factory Test.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Test(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? 60,
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isActive: data['isActive'] ?? true,
      isScheduled: data['isScheduled'] ?? false,
      scheduledExamId: data['scheduledExamId'],
      allowedStudentIds: data['allowedStudentIds'] != null
          ? List<String>.from(data['allowedStudentIds'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'isActive': isActive,
      'isScheduled': isScheduled,
      'scheduledExamId': scheduledExamId,
      'allowedStudentIds': allowedStudentIds,
    };
  }

  // Helper method to check if test is available for scheduling
  bool get canBeScheduled {
    return isActive && !isScheduled;
  }

  // Helper method to check if a student is allowed to take the test
  bool isStudentAllowed(String studentId) {
    if (allowedStudentIds == null) return true; // No restrictions
    return allowedStudentIds!.contains(studentId);
  }

  // Copy with method for immutability
  Test copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    String? createdBy,
    Timestamp? createdAt,
    bool? isActive,
    bool? isScheduled,
    String? scheduledExamId,
    List<String>? allowedStudentIds,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      isScheduled: isScheduled ?? this.isScheduled,
      scheduledExamId: scheduledExamId ?? this.scheduledExamId,
      allowedStudentIds: allowedStudentIds ?? this.allowedStudentIds,
    );
  }
}