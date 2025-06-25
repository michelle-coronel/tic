class Question {
  final int id;
  final String type;
  final String question;
  final List<String>? options;
  final int? answerIndex;
  final String? answerText;
  final String explanation;
  final String sound;

  // Para tipo "arrastrar"
  final List<DragItem>? items;
  final List<String>? targets;

  Question({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.answerIndex,
    this.answerText,
    required this.explanation,
    this.sound = '',
    this.items,
    this.targets,
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
      items: json['items'] != null
          ? (json['items'] as List).map((e) => DragItem.fromJson(e)).toList()
          : null,
      targets: json['targets'] != null
          ? List<String>.from(json['targets'])
          : null,
    );
  }
}

class DragItem {
  final String text;
  final String categoriaCorrecta;

  DragItem({required this.text, required this.categoriaCorrecta});

  factory DragItem.fromJson(Map<String, dynamic> json) {
    return DragItem(
      text: json['text'],
      categoriaCorrecta: json['categoriaCorrecta'],
    );
  }
}
