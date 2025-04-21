import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testzen/models/question.dart';
import 'package:testzen/models/test.dart';

class TestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all tests
  Stream<List<Test>> getTests() {
    return _firestore.collection('tests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Test.fromFirestore(doc)).toList();
    });
  }

  // Get a single test by ID
  Future<Test?> getTestById(String testId) async {
    DocumentSnapshot doc = await _firestore.collection('tests').doc(testId).get();
    if (doc.exists) {
      return Test.fromFirestore(doc);
    }
    return null;
  }

  // Get questions for a specific test
  Future<List<Question>> getQuestionsForTest(String testId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('tests')
        .doc(testId)
        .collection('questions')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) {
      // Extract the data from the DocumentSnapshot first
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Then pass just the data to your fromFirestore method
      return Question.fromFirestore(data);
    }).toList();
  }

  // Create a new test
  Future<String> createTest(Test test) async {
    DocumentReference docRef = await _firestore.collection('tests').add(test.toMap());
    return docRef.id;
  }

  // Update an existing test
  Future<void> updateTest(String testId, Test test) async {
    await _firestore.collection('tests').doc(testId).update(test.toMap());
  }

  // Delete a test
  Future<void> deleteTest(String testId) async {
    // Delete all questions in the test
    QuerySnapshot questionsSnapshot = await _firestore
        .collection('tests')
        .doc(testId)
        .collection('questions')
        .get();

    WriteBatch batch = _firestore.batch();
    for (var doc in questionsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete the test document
    batch.delete(_firestore.collection('tests').doc(testId));

    await batch.commit();
  }

  // Add a question to a test
  Future<String> addQuestion(String testId, Question question) async {
    DocumentReference docRef = await _firestore
        .collection('tests')
        .doc(testId)
        .collection('questions')
        .add(question.toMap());
    return docRef.id;
  }

  // Update a question
  Future<void> updateQuestion(String testId, String questionId, Question question) async {
    await _firestore
        .collection('tests')
        .doc(testId)
        .collection('questions')
        .doc(questionId)
        .update(question.toMap());
  }

  // Delete a question
  Future<void> deleteQuestion(String testId, String questionId) async {
    await _firestore
        .collection('tests')
        .doc(testId)
        .collection('questions')
        .doc(questionId)
        .delete();
  }
}