import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_question_screen.dart';

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({Key? key}) : super(key: key);

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

              return ListTile(
                title: Text(examData['title'] ?? 'No Title'),
                subtitle: Text('Duration: ${examData['durationMinutes'] ?? 'N/A'} mins'),
                trailing: IconButton(
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
              );
            },
          );
        },
      ),
    );
  }
}
