import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/result_model.dart';

class LeaderboardScreen extends StatelessWidget {
  final String examId;
  final String examTitle;

  const LeaderboardScreen({
    Key? key,
    required this.examId,
    required this.examTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard: $examTitle'),
      ),
      body: StreamBuilder<List<ResultModel>>(
        stream: DatabaseService.getResultsForExam(examId), // ✅ Real-time Firestore stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          final results = snapshot.data!;
          results.sort((a, b) => b.correctAnswers.compareTo(a.correctAnswers));

          return ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(result.userName),
                subtitle: Text('Score: ${result.correctAnswers}/${result.totalQuestions}'),
                trailing: Text(
                  '${result.takenAt.day}/${result.takenAt.month}/${result.takenAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
