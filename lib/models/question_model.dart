class QuestionModel
{
  final String questionText;
  final List<String> options;
  final int correctOption;
    //'final' keyword refers to the list immutable

  QuestionModel({
    required this.questionText,  //'require' ensures the caller must pass a value
    required this.options,
    required this.correctOption,
  }) : assert(options.length == 4, 'There must be exactly 4 options.');
         //'assert' refers to the run-time check for development/debugging


  // Convert the QuestionModel object to a Map to save in Firestore
  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctOption': correctOption,
    };
  }

  // QuestionModel object from a Firestore document Map
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOption: map['correctOption'] ?? 1,
    );
  }
}
