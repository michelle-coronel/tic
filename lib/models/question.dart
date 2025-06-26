// Clase que representa una pregunta dentro del quiz
class Question {
  // ID único de la pregunta
  final int id;

  // Tipo de pregunta: puede ser 'multiple', 'true_false', 'completar', 'ordenar', 'arrastrar', etc.
  final String type;

  // Texto de la pregunta que se va a mostrar al usuario
  final String question;

  // Lista de opciones posibles (solo para preguntas de opción múltiple, verdadero/falso, etc.)
  final List<String>? options;

  // Índice de la respuesta correcta dentro de la lista de opciones (para opción múltiple)
  final int? answerIndex;

  // Texto de la respuesta correcta (para preguntas tipo completar)
  final String? answerText;

  // Explicación que se muestra al usuario después de responder, útil para aprendizaje
  final String explanation;

  // Ruta del sonido que se debe reproducir para esta pregunta (opcional)
  final String sound;

  // Lista de elementos arrastrables (solo para preguntas tipo "arrastrar")
  final List<DragItem>? items;

  // Lista de categorías objetivo a donde se deben arrastrar los elementos (para tipo "arrastrar")
  final List<String>? targets;

  // Constructor de la clase Question
  Question({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.answerIndex,
    this.answerText,
    required this.explanation,
    this.sound = '', // Valor por defecto si no se especifica sonido
    this.items,
    this.targets,
  });

  // Método factory para crear una instancia de Question a partir de un JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'], // ID de la pregunta
      type: json['type'], // Tipo de pregunta
      question: json['question'], // Texto de la pregunta
      // Convierte la lista de opciones del JSON a List<String>
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,

      answerIndex:
          json['answerIndex'], // Índice de la respuesta correcta (si aplica)
      answerText:
          json['answerText'], // Texto de la respuesta correcta (si aplica)
      explanation:
          json['explanation'] ?? '', // Explicación (si no hay, pone vacío)
      // Si existe la clave 'sound', se usa su valor, sino se deja como cadena vacía
      sound: json.containsKey('sound') ? json['sound'] : '',

      // Si hay elementos 'items' en el JSON, se convierten a una lista de objetos DragItem
      items: json['items'] != null
          ? (json['items'] as List).map((e) => DragItem.fromJson(e)).toList()
          : null,

      // Convierte la lista de targets del JSON a List<String>
      targets: json['targets'] != null
          ? List<String>.from(json['targets'])
          : null,
    );
  }
}

// Clase que representa un ítem arrastrable dentro de una pregunta tipo "arrastrar"
class DragItem {
  // Texto del ítem que se va a arrastrar
  final String text;

  // Categoría correcta donde debe colocarse este ítem
  final String categoriaCorrecta;

  // Constructor de la clase DragItem
  DragItem({required this.text, required this.categoriaCorrecta});

  // Método factory para crear una instancia de DragItem a partir de un JSON
  factory DragItem.fromJson(Map<String, dynamic> json) {
    return DragItem(
      text: json['text'], // Texto del ítem
      categoriaCorrecta:
          json['categoriaCorrecta'], // Categoría correcta para el ítem
    );
  }
}
