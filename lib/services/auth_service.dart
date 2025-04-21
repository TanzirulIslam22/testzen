import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // General Register with Role (student/teacher/admin)
  Future<void> registerWithEmailAndPassword(
      String email, String password, String name, String role) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'role': role.toLowerCase(), // just to be consistent
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Create Student Account (used by admin maybe)
  Future<void> createStudentAccount(
      String email, String password, String name) async {
    await registerWithEmailAndPassword(email, password, name, 'student');
  }

  // Create Teacher Account (if needed separately)
  Future<void> createTeacherAccount(
      String email, String password, String name) async {
    await registerWithEmailAndPassword(email, password, name, 'teacher');
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  // Get current user role (helper)
  Future<String?> getCurrentUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(user.uid).get();
      return snapshot.get('role') as String?;
    }
    return null;
  }

  // Handle Firebase auth error messages
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
