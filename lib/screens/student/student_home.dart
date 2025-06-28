import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'available_exam_screen.dart';
import 'results_screen.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AvailableExamsScreen(),
                  ),
                );
              },
              child: const Text('View Available Exams'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResultsScreen(),
                  ),
                );
              },
              child: const Text('View My Results'),
            ),
          ],
        ),
      ),
    );
  }
}
