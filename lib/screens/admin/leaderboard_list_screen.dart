// lib/screens/admin/leaderboard_list_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin/leaderboard_screen.dart'; // Import leaderboard screen

class LeaderboardListScreen extends StatelessWidget {
  const LeaderboardListScreen({Key? key}) : super(key: key);

  void _goToLeaderboard(BuildContext context, String examId, String examTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaderboardScreen(examId: examId, examTitle: examTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exam for Leaderboard'),
      ),
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
                trailing: IconButton(
                  icon: const Icon(Icons.leaderboard),
                  tooltip: 'View Leaderboard',
                  onPressed: () => _goToLeaderboard(context, examId, title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
