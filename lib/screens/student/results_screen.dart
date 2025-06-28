import 'package:flutter/material.dart';
import '../../models/result_model.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Exam Results')),
      body: StreamBuilder<List<ResultModel>>(
        stream: DatabaseService.getResultsForUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data ?? [];
          if (results.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final r = results[index];
              return ListTile(
                title: Text(r.examTitle),
                subtitle: Text('Score: ${r.correctAnswers}/${r.totalQuestions}'),
                trailing: Text(
                  '${r.takenAt.day}/${r.takenAt.month}/${r.takenAt.year}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
