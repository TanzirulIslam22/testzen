import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestResultsScreen extends StatelessWidget {
  final String testId;
  final String testName;

  const TestResultsScreen({
    Key? key,
    required this.testId,
    required this.testName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results: $testName'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('results')
            .where('testId', isEqualTo: testId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No results yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Students have not completed this test',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final results = snapshot.data!.docs;

          // Sort by score (highest first)
          results.sort((a, b) {
            final scoreA = (a.data() as Map<String, dynamic>)['score'] as num;
            final scoreB = (b.data() as Map<String, dynamic>)['score'] as num;
            return scoreB.compareTo(scoreA);
          });

          return Column(
            children: [
              _buildSummaryCard(results),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index].data() as Map<String, dynamic>;
                    final studentId = result['studentId'] as String;
                    final score = result['score'] as num;
                    final total = result['totalQuestions'] as num;
                    final percentage = (score / total * 100).toStringAsFixed(1);
                    final submittedAt = result['submittedAt'] as Timestamp?;
                    final formattedDate = submittedAt != null
                        ? '${submittedAt.toDate().day}/${submittedAt.toDate().month}/${submittedAt.toDate().year} at ${submittedAt.toDate().hour}:${submittedAt.toDate().minute.toString().padLeft(2, '0')}'
                        : 'Unknown date';

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(studentId).get(),
                      builder: (context, userSnapshot) {
                        String studentName = 'Unknown Student';
                        if (userSnapshot.hasData && userSnapshot.data!.exists) {
                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                          studentName = userData['name'] ?? 'Unknown Student';
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        studentName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getScoreColor(double.parse(percentage)),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '$percentage%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Score: $score/$total questions correct',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Submitted: $formattedDate',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(List<QueryDocumentSnapshot> results) {
    if (results.isEmpty) return const SizedBox.shrink();

    // Calculate summary statistics
    final totalStudents = results.length;
    double totalScore = 0;
    final totalQuestions = (results.first.data() as Map<String, dynamic>)['totalQuestions'] as num;
    int highestScore = 0;
    int lowestScore = totalQuestions.toInt();

    for (final result in results) {
      final data = result.data() as Map<String, dynamic>;
      final score = data['score'] as num;
      totalScore += score.toDouble();
      if (score > highestScore) highestScore = score.toInt();
      if (score < lowestScore) lowestScore = score.toInt();
    }

    final averageScore = totalScore / totalStudents;
    final averagePercentage = (averageScore / totalQuestions * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Average',
                  '$averagePercentage%',
                  _getScoreColor(double.parse(averagePercentage)),
                ),
                _buildSummaryItem(
                  'Highest',
                  '${(highestScore / totalQuestions * 100).toStringAsFixed(1)}%',
                  Colors.green,
                ),
                _buildSummaryItem(
                  'Lowest',
                  '${(lowestScore / totalQuestions * 100).toStringAsFixed(1)}%',
                  Colors.red,
                ),
                _buildSummaryItem(
                  'Students',
                  '$totalStudents',
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.amber.shade700;
    } else {
      return Colors.red;
    }
  }
}