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
}
