import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/question_model.dart';
import '../../models/result_model.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';

class ExamScreen extends StatefulWidget {
  final String examId;
  const ExamScreen({Key? key, required this.examId}) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List<QuestionModel> _questions = [];
  Map<int, int> _answers = {}; // question index -> selected option
  bool _loading = true;
  Timer? _timer;
  int _secondsLeft = 0;
  String _examTitle = '';
  int _durationMinutes = 0;

  @override
  void initState() {
    super.initState();
    _loadExamAndQuestions();
  }

  Future<void> _loadExamAndQuestions() async {
    try {
      // Load exam details
      final examDoc = await FirebaseFirestore.instance.collection('exams').doc(widget.examId).get();
      final examData = examDoc.data();
      if (examData == null) {
        // handle no exam found
        Navigator.pop(context);
        return;
      }

      _examTitle = examData['title'] ?? 'Exam';
      _durationMinutes = examData['durationMinutes'] ?? 0;
      _secondsLeft = _durationMinutes * 60;

      // Load questions
      final questionsSnapshot = await FirebaseFirestore.instance
          .collection('exams')
          .doc(widget.examId)
          .collection('questions')
          .get();

      final questions = questionsSnapshot.docs
          .map((doc) => QuestionModel.fromMap(doc.data()))
          .toList();

      setState(() {
        _questions = questions;
        _loading = false;
      });

      _startTimer();
    } catch (e) {
      print('Error loading exam/questions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load exam. Please try again.')),
        );
      }
      Navigator.pop(context);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        _submitAnswers(autoSubmitted: true);
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  String get _timeFormatted {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _submitAnswers({bool autoSubmitted = false}) async {
    _timer?.cancel();

    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctOption) {
        correct++;
      }
    }

    final userId = AuthService.currentUser?.uid;
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final result = ResultModel(
      examId: widget.examId,
      examTitle: _examTitle,
      totalQuestions: _questions.length,
      correctAnswers: correct,
      takenAt: DateTime.now(),
    );

    print('Submitting exam result for user $userId with score $correct/${_questions.length}');
    try {
      await DatabaseService.saveExamResult(userId: userId, result: result);
      print('Result saved successfully');
    } catch (e) {
      print('Error saving result: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save result: $e')),
      );
    }

    if (!autoSubmitted) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Exam Submitted'),
          content: Text('You got $correct out of ${_questions.length} correct.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Time Up'),
          content: Text('Time is up! You got $correct out of ${_questions.length} correct.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_examTitle),
        actions: [
          Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text('Time Left: $_timeFormatted', style: const TextStyle(fontSize: 18)),
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final q = _questions[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q${index + 1}: ${q.questionText}'),
                  const SizedBox(height: 8),
                  ...List.generate(
                    4,
                        (i) => RadioListTile<int>(
                      title: Text(q.options[i]),
                      value: i + 1,
                      groupValue: _answers[index],
                      onChanged: (val) {
                        setState(() {
                          _answers[index] = val!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _submitAnswers(),
        label: const Text('Submit'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}