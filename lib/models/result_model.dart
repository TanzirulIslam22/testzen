import 'package:cloud_firestore/cloud_firestore.dart';

class ResultModel {
  final String examId;
  final String examTitle;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime takenAt;

  ResultModel({
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.takenAt,
  });

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      examId: map['examId'] ?? '',
      examTitle: map['examTitle'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      takenAt: (map['takenAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'examTitle': examTitle,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'takenAt': takenAt,
    };
  }
}
