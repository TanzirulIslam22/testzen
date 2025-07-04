import 'package:flutter/material.dart'; //refer to flutter UI toolkit
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/student/student_home.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _user;
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    _user = AuthService.currentUser;

    if (_user != null) {
      final doc =
          await AuthService.firestore.collection('users').doc(_user!.uid).get();
      _role = doc.data()?['role'];
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) {
      // Not logged in
      return const LoginScreen();
    }

    if (_role == 'admin') {
      return const AdminHome();
    } else if (_role == 'student') {
      return const StudentHome();
    } else {
      return const LoginScreen(); // Unknown role, fallback to login
    }
  }
}
