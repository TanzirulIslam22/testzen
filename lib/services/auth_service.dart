import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Optional public getter
  static FirebaseFirestore get firestore => _firestore;

  /// Register user and save role in Firestore
  static Future<void> register({
    required String email,
    required String password,
    required String role,
  }) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('User registration failed');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Login user and return role
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('User login failed');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      print('❗️User doc not found for UID: ${user.uid}');
      throw Exception('User role not found');
    }

    final data = doc.data();
    print('✅ User document data: $data');

    if (data == null || !data.containsKey('role')) {
      throw Exception('User role not found');
    }

    return data['role'] as String;
  }

  /// Sign out user
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// Get current Firebase user
  static User? get currentUser => _auth.currentUser;
}
