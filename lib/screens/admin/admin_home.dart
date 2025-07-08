import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToCreateExam(BuildContext context) {
    Navigator.pushNamed(context, '/create_exam');
  }

  void _goToExamList(BuildContext context) {
    Navigator.pushNamed(context, '/exam_list');
  }

  void _goToLeaderboardList(BuildContext context) {
    Navigator.pushNamed(context, '/leaderboard_list');
    // or Navigator.pushNamed(context, '/leaderboard'); if you have a single leaderboard screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _goToCreateExam(context),
              child: const Text('Create New Exam'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToExamList(context),
              child: const Text('View Exam List'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToLeaderboardList(context),
              child: const Text('View Leaderboards'),
            ),
          ],
        ),
      ),
    );
  }
}
