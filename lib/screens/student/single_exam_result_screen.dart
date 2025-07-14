import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/result_model.dart';
import 'package:intl/intl.dart';

class SingleExamResultScreen extends StatelessWidget {
  final String examId;
  const SingleExamResultScreen({Key? key, required this.examId}) : super(key: key);

  Future<Map<String, dynamic>?> _getExamData() async {
    return await DatabaseService.getExamById(examId);
  }

  Future<ResultModel?> _getMyResult(String userId) async {
    final allResults = await DatabaseService.getResultsForUser(userId).first;
    return allResults.firstWhere(
          (r) => r.examId == examId,
      orElse: () => ResultModel(
        examId: examId,
        examTitle: 'Unknown',
        totalQuestions: 0,
        correctAnswers: 0,
        takenAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Exam Result")),
      body: FutureBuilder(
        future: Future.wait([
          _getExamData(),
          _getMyResult(userId),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final examData = snapshot.data?[0] as Map<String, dynamic>?;
          final result = snapshot.data?[1] as ResultModel?;

          if (examData == null || result == null) {
            return const Center(child: Text('Result not found.'));
          }

          final endTime = examData['examDateTime'].toDate().add(
            Duration(minutes: examData['durationMinutes']),
          );
          final now = DateTime.now();

          if (now.isBefore(endTime)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_clock, size: 60, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text(
                    'Result will be available after the exam ends.',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'End Time: ${DateFormat('hh:mm a').format(endTime)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  result.examTitle,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your Score: ${result.correctAnswers} / ${result.totalQuestions}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  'Taken at: ${DateFormat('dd MMM, hh:mm a').format(result.takenAt)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
