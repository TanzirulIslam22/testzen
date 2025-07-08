import 'package:cloud_firestore/cloud_firestore.dart';

class ResultModel {
  final String userId;
  final String userName;
  final String examId;
  final String examTitle;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime takenAt;

  ResultModel({
    required this.userId,
    required this.userName,
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.takenAt,
  });

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      userId: map['userId'] ?? 'UnknownUser',
      userName: map['userName'] ?? 'Anonymous',
      examId: map['examId'] ?? '',
      examTitle: map['examTitle'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      takenAt: (map['takenAt'] is Timestamp)
          ? (map['takenAt'] as Timestamp).toDate()
          : DateTime.now(), // fallback to avoid crash
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'examId': examId,
      'examTitle': examTitle,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'takenAt': Timestamp.fromDate(takenAt), // ✅ Fixed: Convert DateTime to Timestamp for Firestore
    };
  }

  // ✅ Added: Helper method to calculate score percentage
  double get scorePercentage => totalQuestions > 0
      ? (correctAnswers / totalQuestions) * 100
      : 0.0;

  // ✅ Added: Helper method to get formatted score string
  String get formattedScore => '$correctAnswers/$totalQuestions';

  // ✅ Added: Helper method to get formatted date
  String get formattedDate => '${takenAt.day}/${takenAt.month}/${takenAt.year}';
}