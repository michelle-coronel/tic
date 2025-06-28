import 'dart:convert'; // Para decodificar JSON
import 'package:flutter/material.dart'; // Widgets de Flutter
import 'package:audioplayers/audioplayers.dart'; // Para reproducir sonidos
import '../models/question.dart'; // Modelo Question para representar preguntas
import 'resultado_screen.dart'; // Pantalla de resultados después del quiz

// Widget Stateful que representa la pantalla principal del Quiz
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

// Estado del QuizScreen, maneja la lógica y UI del quiz
class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>>
  _futureQuestions; // Future para cargar preguntas desde JSON
  late List<Question> _questions; // Lista de preguntas cargadas
  int _current = 0; // Índice de la pregunta actual
  int _score = 0; // Puntuación acumulada del usuario

  int?
  _selectedIndex; // Índice de opción seleccionada (para preguntas de opción múltiple)
  bool _answered = false; // Indica si la pregunta actual fue respondida
  bool _isCorrect = false; // Indica si la respuesta fue correcta
  String _textAnswer = ''; // Texto ingresado para preguntas tipo completar
  final AudioPlayer _audioPlayer = AudioPlayer(); // Reproductor de sonidos

  late DateTime _startTime; // Hora en la que empezó el quiz para medir duración

  @override
  void initState() {
    super.initState();
    _futureQuestions =
        _loadQuestions(); // Carga las preguntas al iniciar el widget
    _startTime = DateTime.now(); // Guarda el tiempo inicial
  }

  // Carga y decodifica las preguntas desde un archivo JSON local
  Future<List<Question>> _loadQuestions() async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/images/quiz.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((e) => Question.fromJson(e))
        .toList(); // Convierte JSON en objetos Question
  }

  // Reproduce un sonido dependiendo si la respuesta fue correcta o incorrecta
  Future<void> _playSound(bool isCorrect) async {
    final file = isCorrect ? 'sounds/correcto.mp3' : 'sounds/incorrecto.mp3';
    await _audioPlayer.play(AssetSource(file));
  }

  // Verifica la respuesta dada por el usuario para la pregunta actual
  void _checkAnswer() {
    final q = _questions[_current];

    if (q.type == 'completar') {
      // Para preguntas de texto, compara la respuesta ignorando mayúsculas y espacios
      final correct =
          q.answerText?.trim().toLowerCase() ==
          _textAnswer.trim().toLowerCase();

      setState(() {
        _answered = true; // Marca la pregunta como respondida
        _isCorrect = correct; // Indica si fue correcta
        if (_isCorrect) _score++; // Incrementa puntaje si es correcta
      });

      _playSound(_isCorrect); // Reproduce sonido de feedback
    } else {
      // Para preguntas de opción múltiple
      if (_selectedIndex == null)
        return; // Si no hay opción seleccionada, no hace nada
      setState(() {
        _answered = true;
        _isCorrect =
            _selectedIndex ==
            q.answerIndex; // Verifica si opción seleccionada es la correcta
        if (_isCorrect) _score++;
      });
      _playSound(_isCorrect);
    }
  }

  // Avanza a la siguiente pregunta o muestra resultados si fue la última
  void _nextQuestion() {
    setState(() {
      _answered = false; // Resetea estado para nueva pregunta
      _selectedIndex = null;
      _textAnswer = '';
      _isCorrect = false;
      if (_current < _questions.length - 1) {
        _current++; // Incrementa índice de pregunta
      } else {
        _showResult(); // Si no hay más preguntas, muestra resultados
      }
    });
  }

  // Permite reintentar la misma pregunta, reseteando selección y texto
  void _retryQuestion() {
    setState(() {
      _answered = false;
      _selectedIndex = null;
      _textAnswer = '';
    });
  }

  // Navega a la pantalla de resultados, pasando datos necesarios
  void _showResult() {
    final endTime = DateTime.now();
    final duration = endTime.difference(
      _startTime,
    ); // Calcula duración del quiz
    final minutos = duration.inMinutes;
    final segundos = duration.inSeconds % 60;

    final tiempoFormateado =
        '${minutos}m ${segundos}s'; // Formato legible para tiempo

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoScreen(
          score: _score, // Puntuación total
          totalQuestions: _questions.length, // Total preguntas respondidas
          tiempoTotal: tiempoFormateado, // Tiempo total empleado
          questions:
              _questions, // Lista completa de preguntas para mostrar detalles
          tema: 'Hardware', // Tema del quiz (fijo en este código)
          appBarTitle:
              'Quiz Hardware', // Título en la barra de la pantalla resultados
        ),
      ),
    );
  }

  // Construye las opciones para preguntas de opción múltiple con estilos según estado
  Widget _buildOptions(Question q) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: List.generate(q.options?.length ?? 0, (i) {
        final isSelected = i == _selectedIndex;

        // Colores por defecto para borde, fondo y texto
        Color borderColor = Colors.grey.shade400;
        Color bgColor = theme.cardColor;
        Color circleColor = Colors.transparent;
        Color optionTextColor = textColor;

        if (_answered) {
          if (isSelected) {
            if (_isCorrect) {
              // Si respondido correctamente: borde y círculo verde
              borderColor = Colors.green;
              circleColor = Colors.green;
              optionTextColor = textColor;
            } else {
              // Respuesta incorrecta: fondo rojo, borde rojo, texto rojo fuerte
              bgColor = isDarkMode ? Colors.red.shade700 : Colors.red.shade100;
              borderColor = Colors.red;
              circleColor = Colors.red;
              optionTextColor = isDarkMode ? Colors.white : Colors.red.shade900;
            }
          }
        } else {
          if (isSelected) {
            // Antes de responder, opción seleccionada se marca con fondo ámbar y borde ámbar
            bgColor = isDarkMode
                ? Colors.amber.shade700
                : Colors.amber.shade100;
            borderColor = Colors.amber;
            circleColor = Colors.amber;
          }
        }

        return GestureDetector(
          onTap: !_answered
              ? () => setState(() => _selectedIndex = i)
              : null, // Solo permite seleccionar antes de responder
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: circleColor != Colors.transparent
                          ? circleColor
                          : Colors.grey,
                      width: 2,
                    ),
                    color: circleColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    q.options![i],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: optionTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Construye el campo de texto para preguntas tipo completar
  Widget _buildCompletar(Question q) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return TextField(
      enabled: !_answered, // Solo permite escribir si no se ha respondido aún
      onChanged: (value) {
        setState(() {
          _textAnswer = value; // Actualiza texto ingresado
        });
      },
      decoration: const InputDecoration(
        labelText: 'Escribe la respuesta',
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: textColor, fontSize: 18),
    );
  }

  // Construcción principal de la UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return FutureBuilder<List<Question>>(
      future: _futureQuestions, // Espera las preguntas cargadas
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras carga, muestra un spinner
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // En caso de error al cargar JSON, muestra mensaje
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Si no hay preguntas disponibles
          return const Scaffold(
            body: Center(child: Text('No hay preguntas disponibles')),
          );
        }

        // Si datos cargados correctamente, asigna lista de preguntas
        _questions = snapshot.data!;
        final q = _questions[_current]; // Pregunta actual

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Pregunta ${_current + 1}/${_questions.length}', // Muestra progreso de pregunta
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value:
                        (_current + 1) /
                        _questions.length, // Barra progreso en porcentaje
                    backgroundColor: Colors.grey[400],
                    color: const Color.fromARGB(255, 23, 159, 52),
                    minHeight: 18,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(((_current + 1) / _questions.length) * 100).toInt()}% completado', // Texto % completado
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    q.question, // Muestra el texto de la pregunta
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Construye widget de opciones o campo de texto según tipo
                  q.type == 'completar' ? _buildCompletar(q) : _buildOptions(q),
                  const SizedBox(height: 40),
                  // Botón para comprobar respuesta solo si no se ha respondido aún
                  if (!_answered)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (q.type == 'completar'
                                ? _textAnswer.trim().isEmpty
                                : _selectedIndex == null)
                            ? null
                            : _checkAnswer, // Solo habilita si hay respuesta válida
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Comprobar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Si ya respondió, muestra feedback y botones de continuar o reintentar
                  if (_answered) ...[
                    const SizedBox(height: 16),
                    _buildFeedbackContainer(
                      correct: _isCorrect,
                      message: _isCorrect ? '¡Muy bien!' : 'Incorrecto',
                      explanation: _isCorrect ? q.explanation : null,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCorrect ? _nextQuestion : _retryQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCorrect
                              ? Colors.green
                              : Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          _isCorrect
                              ? (_current == _questions.length - 1
                                    ? 'Finalizar Quiz'
                                    : 'Continuar')
                              : 'Volver a intentar',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget que construye el contenedor de feedback (correcto o incorrecto) con mensaje y explicación
  Widget _buildFeedbackContainer({
    required bool correct,
    String? explanation,
    String? message,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: correct
            ? Colors.green[100]
            : Colors.red[100], // Fondo verde o rojo claro
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct
                    ? Icons.check_circle
                    : Icons.cancel, // Icono check o cruz
                color: correct ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  correct
                      ? (message ?? '¡Correcto!')
                      : (message ?? 'Incorrecto'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: correct ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          if (explanation != null && explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              explanation, // Muestra explicación solo si es correcta y hay texto
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode && correct ? Colors.black : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
