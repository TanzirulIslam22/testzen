import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testzen/screens/admin/test_results.dart';

class ResultsDashboard extends StatelessWidget {
  const ResultsDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('tests')
          .where('createdBy', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get(),
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
                Icon(Icons.insert_chart, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No tests available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Create tests to see results here',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final tests = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];
            final testData = test.data() as Map<String, dynamic>;
            final testName = testData['name'] ?? 'Unnamed Test';
            final subject = testData['subject'] ?? 'No Subject';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestResultsScreen(
                        testId: test.id,
                        testName: testName,
                      ),
                    ),
                  );
                },
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
                              testName,
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
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              subject,
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('results')
                            .where('testId', isEqualTo: test.id)
                            .get(),
                        builder: (context, resultSnapshot) {
                          if (resultSnapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Loading results...');
                          }

                          final resultsCount = resultSnapshot.hasData ? resultSnapshot.data!.docs.length : 0;

                          if (resultsCount == 0) {
                            return const Text(
                              'No results yet',
                              style: TextStyle(color: Colors.grey),
                            );
                          }

                          return Row(
                            children: [
                              const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '$resultsCount submissions',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}