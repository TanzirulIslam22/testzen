import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import 'add_question_screen.dart';
import 'leaderboard_screen.dart'; // Import the leaderboard screen

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({Key? key}) : super(key: key);

  Future<void> _confirmDelete(BuildContext context, String examId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exam'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseService.deleteExam(examId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exam deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('exams').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No exams found.'));
          }

          final exams = snapshot.data!.docs;

          return ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              final examId = exam.id;
              final examData = exam.data() as Map<String, dynamic>;
              final title = examData['title'] ?? 'No Title';

              return ListTile(
                title: Text(title),
                subtitle: Text('Duration: ${examData['durationMinutes'] ?? 'N/A'} mins'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Add Question',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddQuestionScreen(examId: examId),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.leaderboard, color: Colors.blue),
                      tooltip: 'View Leaderboard',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeaderboardScreen(
                              examId: examId,
                              examTitle: title,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete Exam',
                      onPressed: () => _confirmDelete(context, examId, title),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
