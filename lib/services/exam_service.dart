import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';

class ExamService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createExam({
    required String title,
    required String description,
    required DateTime examDateTime,
    required int durationMinutes,
  }) async {
    await _firestore.collection('exams').add({
      'title': title,
      'description': description,
      'examDateTime': examDateTime.toUtc(),
      'durationMinutes': durationMinutes,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> addQuestion(String examId, QuestionModel question) async {
    final questionsCollection =
        _firestore.collection('exams').doc(examId).collection('questions');

    await questionsCollection.add(question.toMap());
  }
}
