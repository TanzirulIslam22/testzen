import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../services/exam_service.dart';

class AddQuestionScreen extends StatefulWidget {
  final String examId;
  const AddQuestionScreen({Key? key, required this.examId}) : super(key: key);

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
  List.generate(4, (_) => TextEditingController());
  int _correctOption = 1;
  bool _isLoading = false;

  Future<void> _submitQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final question = QuestionModel(
        questionText: _questionController.text.trim(),
        options: _optionControllers.map((c) => c.text.trim()).toList(),
        correctOption: _correctOption,
      );

      await ExamService.addQuestion(widget.examId, question);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question added successfully')),
      );

      _formKey.currentState!.reset();
      _questionController.clear();
      _optionControllers.forEach((c) => c.clear());
      setState(() => _correctOption = 1);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _optionControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (val) => val == null || val.isEmpty ? 'Enter question' : null,
              ),
              const SizedBox(height: 10),
              ...List.generate(4, (index) => TextFormField(
                controller: _optionControllers[index],
                decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                validator: (val) => val == null || val.isEmpty ? 'Enter option ${index + 1}' : null,
              )),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _correctOption,
                decoration: const InputDecoration(labelText: 'Correct Option'),
                items: List.generate(4, (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('Option ${index + 1}'),
                )),
                onChanged: (val) => setState(() => _correctOption = val ?? 1),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submitQuestion,
                child: const Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
