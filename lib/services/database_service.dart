import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exam.dart';
import '../models/question.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Exam methods
  Future<void> createExam(Exam exam) async {
    await _firestore.collection('exams').doc(exam.id).set(exam.toMap());
  }

  Future<void> addQuestions(String examId, List<Question> questions) async {
    await _firestore.collection('exams').doc(examId).update({
      'questions': questions.map((q) => q.toMap()).toList(),
    });
  }

  Future<List<Exam>> getUpcomingExams() async {
    QuerySnapshot snapshot = await _firestore
        .collection('exams')
        .where('endTime', isGreaterThan: DateTime.now())
        .get();
    return snapshot.docs.map((doc) => Exam.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  // Student registration for exam
  Future<void> registerForExam(String examId, String userId) async {
    await _firestore.collection('examRegistrations').doc('$examId-$userId').set({
      'examId': examId,
      'userId': userId,
      'registeredAt': DateTime.now(),
      'status': 'registered',
    });
  }

  // Submit exam answers
  Future<void> submitExamAnswers(
      String examId,
      String userId,
      Map<int, int> answers,
      int score,
      ) async {
    await _firestore.collection('examResults').doc('$examId-$userId').set({
      'examId': examId,
      'userId': userId,
      'answers': answers,
      'score': score,
      'submittedAt': DateTime.now(),
    });
  }
}