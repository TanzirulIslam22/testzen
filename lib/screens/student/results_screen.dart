import 'package:flutter/material.dart';
import '../../models/result_model.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  Future<bool> _isResultVisible(String examId) async {
    final exam = await DatabaseService.getExamById(examId);
    final endTime = exam?['examDateTime']?.toDate()?.add(
      Duration(minutes: exam['durationMinutes'] ?? 0),
    );
    if (endTime == null) return false;
    return DateTime.now().isAfter(endTime);
  }

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
              final result = results[index];

              return FutureBuilder<bool>(
                future: _isResultVisible(result.examId),
                builder: (context, visibleSnapshot) {
                  final visible = visibleSnapshot.data ?? false;

                  return ListTile(
                    title: Text(result.examTitle),
                    subtitle: visible
                        ? Text(
                        'Score: ${result.correctAnswers}/${result.totalQuestions}')
                        : const Text('Result not yet published.'),
                    trailing: Text(
                      '${result.takenAt.day}/${result.takenAt.month}/${result.takenAt.year}',
                    ),
                    leading: Icon(
                      visible ? Icons.check_circle : Icons.lock_clock,
                      color: visible ? Colors.green : Colors.grey,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
