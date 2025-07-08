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
        .map((snapshot) => snapshot.docs
        .map((doc) => ResultModel.fromMap(doc.data()))
        .toList());
  }

  // ✅ Fixed: Fetch all results for a specific exam (for leaderboard)
  static Stream<List<ResultModel>> getResultsForExam(String examId) {
    return _firestore
        .collectionGroup('results')
        .where('examId', isEqualTo: examId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ResultModel> results = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        // Extract userId from path: users/{userId}/results/{resultId}
        final userId = doc.reference.parent.parent?.id ?? 'UnknownUser';

        // Fetch user name from users collection
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final userName = userDoc.data()?['name'] ??
            userDoc.data()?['email'] ??
            'Anonymous';

        // Create ResultModel with fetched userName
        results.add(ResultModel(
          userId: userId,
          userName: userName,
          examId: data['examId'] ?? '',
          examTitle: data['examTitle'] ?? '',
          totalQuestions: data['totalQuestions'] ?? 0,
          correctAnswers: data['correctAnswers'] ?? 0,
          takenAt: data['takenAt'] != null
              ? (data['takenAt'] as Timestamp).toDate()
              : DateTime.now(),
        ));
      }

      // Sort descending by correctAnswers (highest score first)
      results.sort((a, b) => b.correctAnswers.compareTo(a.correctAnswers));

      return results;
    });
  }

  // Get full exam document by ID (used for checking endTime)
  static Future<Map<String, dynamic>?> getExamById(String examId) async {
    try {
      final doc = await _firestore.collection('exams').doc(examId).get();
      return doc.data();
    } catch (e) {
      print('Error fetching exam data: $e');
      return null;
    }
  }

  // Delete Exam with its Questions
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

  // Alternative method using LeaderboardEntry (keep for backward compatibility)
  static Stream<List<LeaderboardEntry>> getLeaderboardForExam(String examId) {
    return _firestore
        .collectionGroup('results')
        .where('examId', isEqualTo: examId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<LeaderboardEntry> entries = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        // Extract userId from path: users/{userId}/results/{resultId}
        final userId = doc.reference.parent.parent?.id ?? 'UnknownUser';

        // Fetch user name from users collection
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final userName = userDoc.data()?['name'] ??
            userDoc.data()?['email'] ??
            'Anonymous';

        entries.add(LeaderboardEntry(
          userId: userId,
          userName: userName,
          correctAnswers: data['correctAnswers'] ?? 0,
          totalQuestions: data['totalQuestions'] ?? 0,
          takenAt: data['takenAt'] != null
              ? (data['takenAt'] as Timestamp).toDate()
              : null,
        ));
      }

      // Sort descending by correctAnswers
      entries.sort((a, b) => b.correctAnswers.compareTo(a.correctAnswers));

      return entries;
    });
  }
}

// Helper class for leaderboard entries
class LeaderboardEntry {
  final String userId;
  final String userName;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime? takenAt;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.takenAt,
  });
}