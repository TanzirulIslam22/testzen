import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/result_model.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save student's exam result
  static Future<void> saveExamResult({
    required String userId,
    required ResultModel result,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .add(result.toMap());
  }

  // Fetch all results for a student
  static Stream<List<ResultModel>> getResultsForUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .orderBy('takenAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ResultModel.fromMap(doc.data())).toList());
  }

  // ✅ Get full exam document by ID (used for checking endTime)
  static Future<Map<String, dynamic>?> getExamById(String examId) async {
    try {
      final doc = await _firestore.collection('exams').doc(examId).get();
      return doc.data();
    } catch (e) {
      print('Error fetching exam data: $e');
      return null;
    }
  }

  // ✅ Delete Exam with its Questions
  static Future<void> deleteExam(String examId) async {
    final examRef = _firestore.collection('exams').doc(examId);

    try {
      final questionsSnapshot = await examRef.collection('questions').get();
      for (var doc in questionsSnapshot.docs) {
        await doc.reference.delete();
      }

      await examRef.delete();
      print('Exam and its questions deleted');
    } catch (e) {
      print('Failed to delete exam: $e');
      rethrow;
    }
  }
}
