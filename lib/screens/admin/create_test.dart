import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testzen/models/question.dart';


class CreateTestScreen extends StatefulWidget {
  const CreateTestScreen({Key? key}) : super(key: key);

  @override
  _CreateTestScreenState createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _testDurationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _questionTextController = TextEditingController();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _optionCController = TextEditingController();
  final _optionDController = TextEditingController();

  List<Question> _questions = [];
  int _correctAnswerIndex = 0; // 0 for A, 1 for B, etc.
  bool _isLoading = false;

  @override
  void dispose() {
    _testNameController.dispose();
    _testDurationController.dispose();
    _subjectController.dispose();
    _questionTextController.dispose();
    _optionAController.dispose();
    _optionBController.dispose();
    _optionCController.dispose();
    _optionDController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    if (_questionTextController.text.isEmpty ||
        _optionAController.text.isEmpty ||
        _optionBController.text.isEmpty ||
        _optionCController.text.isEmpty ||
        _optionDController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all question fields')),
      );
      return;
    }

    final question = Question(
      text: _questionTextController.text,
      options: [
        _optionAController.text,
        _optionBController.text,
        _optionCController.text,
        _optionDController.text,
      ],
      correctAnswerIndex: _correctAnswerIndex,
    );

    setState(() {
      _questions.add(question);
      _questionTextController.clear();
      _optionAController.clear();
      _optionBController.clear();
      _optionCController.clear();
      _optionDController.clear();
      _correctAnswerIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question added')),
    );
  }

  Future<void> _saveTest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final testData = {
        'name': _testNameController.text,
        'subject': _subjectController.text,
        'duration': int.parse(_testDurationController.text),
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'questions': _questions.map((q) => q.toMap()).toList(),
      };

      await FirebaseFirestore.instance.collection('tests').add(testData);

      // Reset form
      _formKey.currentState!.reset();
      _testNameController.clear();
      _testDurationController.clear();
      _subjectController.clear();
      setState(() {
        _questions.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test created successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (keep all your existing test detail fields)

              // Updated question and options section:
              const Text(
                'Add Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _questionTextController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter question text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildOptionField(0, 'A', _optionAController),
              const SizedBox(height: 8),
              _buildOptionField(1, 'B', _optionBController),
              const SizedBox(height: 8),
              _buildOptionField(2, 'C', _optionCController),
              const SizedBox(height: 8),
              _buildOptionField(3, 'D', _optionDController),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
              ),
              const SizedBox(height: 16),

              // Questions list view
              if (_questions.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Questions (${_questions.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(question.text),
                        subtitle: Text('Correct Answer: ${String.fromCharCode(65 + question.correctAnswerIndex)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _questions.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],

              // Save button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _saveTest,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Save Test'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(int index, String label, TextEditingController controller) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: _correctAnswerIndex,
          onChanged: (value) {
            setState(() {
              _correctAnswerIndex = value!;
            });
          },
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Option $label',
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter option $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}