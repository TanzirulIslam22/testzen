import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/database_service.dart';
import 'single_exam_result_screen.dart'; // ✅ Correct import for result

class WaitingScreen extends StatefulWidget {
  final String examId;
  const WaitingScreen({Key? key, required this.examId}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  DateTime? _endTime;
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExamEndTime();
  }

  Future<void> _loadExamEndTime() async {
    final data = await DatabaseService.getExamById(widget.examId);
    if (data == null || data['examDateTime'] == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exam data not found')),
      );
      Navigator.pop(context);
      return;
    }

    final DateTime examDateTime = data['examDateTime'].toDate();
    final int duration = data['durationMinutes'] ?? 0;
    final DateTime endTime = examDateTime.add(Duration(minutes: duration));

    _endTime = endTime;
    _updateTimer();
    _startTimer();
  }

  void _updateTimer() {
    if (_endTime == null) return;
    final now = DateTime.now();
    final left = _endTime!.difference(now);

    if (left.isNegative) {
      _goToResultScreen();
    } else {
      setState(() {
        _timeLeft = left;
        _loading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimer();
    });
  }

  void _goToResultScreen() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SingleExamResultScreen(examId: widget.examId),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
        title: const Text('Waiting for Result...'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_clock, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Your result will be published after the exam ends.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'End Time: ${DateFormat('hh:mm a').format(_endTime!)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Time left: ${_formatDuration(_timeLeft)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
