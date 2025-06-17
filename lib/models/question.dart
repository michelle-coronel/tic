class Question {
  final int id;
  final String type; // Nuevo para saber el tipo de pregunta
  final String question;
  final List<String>? options; // Opcional para preguntas con opciones
  final int? answerIndex; // Opcional para preguntas con opciones
  final String? answerText; // Nuevo para preguntas de completar
  final String explanation;
  final String sound;

  Question({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.answerIndex,
    this.answerText,
    required this.explanation,
    this.sound = '',
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: json['type'],
      question: json['question'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      answerIndex: json['answerIndex'],
      answerText: json['answerText'],
      explanation: json['explanation'] ?? '',
      sound: json.containsKey('sound') ? json['sound'] : '',
    );
  }
}
