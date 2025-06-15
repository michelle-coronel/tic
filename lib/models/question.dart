class Question {
  final int id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final String sound;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,

    this.sound = '',
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answerIndex: json['answerIndex'],
      explanation: json['explanation'] ?? '',
      sound: json.containsKey('sound') ? json['sound'] : '',
    );
  }
}
