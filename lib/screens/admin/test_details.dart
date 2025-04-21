import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testzen/models/question.dart';
import 'package:testzen/models/test.dart';
import 'package:testzen/services/test_service.dart';
import 'package:testzen/services/navigation_service.dart';

class TestDetailsScreen extends StatefulWidget {
  final String testId;

  const TestDetailsScreen({Key? key, required this.testId}) : super(key: key);

  @override
  _TestDetailsScreenState createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  final TestService _testService = TestService();
  bool isLoading = true;
  Test? test;
  List<Question> questions = [];
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadTestDetails();
  }

  Future<void> _loadTestDetails() async {
    try {
      final testData = await _testService.getTestById(widget.testId);
      if (testData != null) {
        setState(() {
          test = testData;
          isLoading = false;
        });
        _loadQuestions();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading test details: $e')),
      );
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final questionsList = await _testService.getQuestionsForTest(widget.testId);
      setState(() {
        questions = questionsList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Loading Test...' : test?.title ?? 'Test Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : test == null
          ? const Center(child: Text('Test not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test!.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description: ${test!.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${test!.duration} minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Questions: ${questions.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Questions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...questions.map((question) => _buildQuestionCard(question)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: ${question.text}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...question.options.asMap().entries.map(
                  (entry) {
                final index = entry.key;
                final option = entry.value;
                final isCorrect = question.correctOptionIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + index)}) ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(option),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}