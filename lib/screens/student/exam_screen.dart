import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testzen/models/exam.dart';
import 'package:testzen/models/question.dart'; // ✅ ADD THIS LINE
import 'package:testzen/services/database_service.dart';
import 'package:testzen/widgets/timer_widget.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testzen/screens/student/results_screen.dart';


class ExamScreen extends StatefulWidget {
  final Exam exam;

  const ExamScreen({super.key, required this.exam});

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late DateTime _startTime;
  late DateTime _endTime;
  late int _remainingSeconds;
  late Timer _timer;
  final Map<int, int> _answers = {};
  int _currentQuestionIndex = 0;

  // Getter to safely access questions
  List<Question> get _questions => widget.exam.questions ?? [];


  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _endTime = _startTime.add(Duration(minutes: widget.exam.durationMinutes));
    _remainingSeconds = _endTime.difference(_startTime).inSeconds;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds = _endTime.difference(DateTime.now()).inSeconds;
        if (_remainingSeconds <= 0) {
          _timer.cancel();
          _submitExam();
        }
      });
    });
  }

  void _submitExam() async {
    // Calculate score
    int score = 0;
    for (var entry in _answers.entries) {
      if (entry.value == _questions[entry.key].correctAnswerIndex) {
        score++;
      }
    }

    // Submit to database
    await Provider.of<DatabaseService>(context, listen: false).submitExamAnswers(
      widget.exam.id,
      FirebaseAuth.instance.currentUser!.uid,
      _answers,
      score,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          exam: widget.exam,
          score: score,
          totalQuestions: _questions.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if questions exist
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.exam.title),
        ),
        body: Center(
          child: Text("No questions available for this exam."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
        actions: [
          TimerWidget(remainingSeconds: _remainingSeconds),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _questions[_currentQuestionIndex].text,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ..._questions[_currentQuestionIndex]
                      .options
                      .asMap()
                      .entries
                      .map((entry) => RadioListTile<int>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: _answers[_currentQuestionIndex],
                    onChanged: (int? value) {
                      setState(() {
                        _answers[_currentQuestionIndex] = value!;
                      });
                    },
                  ))
                      .toList(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentQuestionIndex > 0)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          },
                          child: Text('Previous'),
                        ),
                      ElevatedButton(
                        onPressed: _answers.containsKey(_currentQuestionIndex)
                            ? () {
                          if (_currentQuestionIndex <
                              _questions.length - 1) {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          } else {
                            _submitExam();
                          }
                        }
                            : null,
                        child: Text(_currentQuestionIndex ==
                            _questions.length - 1
                            ? 'Submit'
                            : 'Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}