import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/role_selection.dart';
import 'screens/admin/admin_home.dart';
import 'screens/student/student_home.dart';
import 'screens/admin/create_exam_screen.dart';
import 'screens/admin/exam_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/role_selection': (context) => const RoleSelectionScreen(),
        '/admin_home': (context) => const AdminHome(),
        '/student_home': (context) => const StudentHome(),
        '/create_exam': (context) => const CreateExamScreen(),
        '/exam_list': (context) => const ExamListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/register') {
          final role = settings.arguments as String?;
          if (role == null) return null;
          return MaterialPageRoute(
            builder: (context) => RegisterScreen(role: role),
          );
        }
        return null;
      },
    );
  }
}
