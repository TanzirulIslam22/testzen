import 'package:cloud_firestore/cloud_firestore.dart';
import 'question.dart'; // ✅ Make sure this import exists!

class Exam {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String createdBy;
  final List<String> allowedRoles;
  final List<Question>? questions; // ✅ Add this line

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.createdBy,
    required this.allowedRoles,
    this.questions, // ✅ Include this in the constructor
  });

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      durationMinutes: map['durationMinutes'],
      createdBy: map['createdBy'],
      allowedRoles: List<String>.from(map['allowedRoles']),
      questions: map['questions'] != null
          ? List<Map<String, dynamic>>.from(map['questions'])
          .map((q) => Question.fromFirestore(q))
          .toList()
          : null, // ✅ Parse questions if they exist
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'durationMinutes': durationMinutes,
      'createdBy': createdBy,
      'allowedRoles': allowedRoles,
      'questions': questions?.map((q) => q.toMap()).toList(), // ✅ Convert to map
    };
  }
}
