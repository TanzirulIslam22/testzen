class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  // Regular constructor
  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });

  // Add the factory method here
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      text: data['text'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
    );
  }

  // For compatibility with other parts of your code that use correctOptionIndex
  int get correctOptionIndex => correctAnswerIndex;

  // Method to convert Question to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}