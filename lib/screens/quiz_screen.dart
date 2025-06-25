import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/question.dart';
import 'resultado_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _futureQuestions;
  late List<Question> _questions;
  int _current = 0;
  int _score = 0;

  int? _selectedIndex;
  bool _answered = false;
  bool _isCorrect = false;
  String _textAnswer = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _futureQuestions = _loadQuestions();
    _startTime = DateTime.now();
  }

  Future<List<Question>> _loadQuestions() async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/images/quiz.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((e) => Question.fromJson(e)).toList();
  }

  Future<void> _playSound(bool isCorrect) async {
    final file = isCorrect ? 'sounds/correcto.mp3' : 'sounds/incorrecto.mp3';
    await _audioPlayer.play(AssetSource(file));
  }

  void _checkAnswer() {
    final q = _questions[_current];

    if (q.type == 'completar') {
      final correct =
          q.answerText?.trim().toLowerCase() ==
          _textAnswer.trim().toLowerCase();

      setState(() {
        _answered = true;
        _isCorrect = correct;
        if (_isCorrect) _score++;
      });

      _playSound(_isCorrect);
    } else {
      if (_selectedIndex == null) return;
      setState(() {
        _answered = true;
        _isCorrect = _selectedIndex == q.answerIndex;
        if (_isCorrect) _score++;
      });
      _playSound(_isCorrect);
    }
  }

  void _nextQuestion() {
    setState(() {
      _answered = false;
      _selectedIndex = null;
      _textAnswer = '';
      _isCorrect = false;
      if (_current < _questions.length - 1) {
        _current++;
      } else {
        _showResult();
      }
    });
  }

  void _retryQuestion() {
    setState(() {
      _answered = false;
      _selectedIndex = null;
      _textAnswer = '';
    });
  }

  void _showResult() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    final minutos = duration.inMinutes;
    final segundos = duration.inSeconds % 60;

    final tiempoFormateado = '${minutos}m ${segundos}s';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoScreen(
          score: _score,
          totalQuestions: _questions.length,
          tiempoTotal: tiempoFormateado,
          questions: _questions,
          tema: 'Hardware', // <-- Aquí agregamos este parámetro
          appBarTitle: 'Quiz Hardware', // <-- Y este parámetro también
        ),
      ),
    );
  }

  Widget _buildOptions(Question q) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: List.generate(q.options?.length ?? 0, (i) {
        final isSelected = i == _selectedIndex;

        Color borderColor = Colors.grey.shade400;
        Color bgColor = theme.cardColor;
        Color circleColor = Colors.transparent;
        Color optionTextColor = textColor;

        if (_answered) {
          if (isSelected) {
            if (_isCorrect) {
              // ✅ Correcta: solo borde y bolita verdes
              borderColor = Colors.green;
              circleColor = Colors.green;
              optionTextColor = textColor;
              // fondo no cambia
            } else {
              // ❌ Incorrecta: fondo rojo
              bgColor = isDarkMode ? Colors.red.shade700 : Colors.red.shade100;
              borderColor = Colors.red;
              circleColor = Colors.red;
              optionTextColor = isDarkMode ? Colors.white : Colors.red.shade900;
            }
          }
        } else {
          if (isSelected) {
            // Antes de responder: seleccionado = fondo ámbar
            bgColor = isDarkMode
                ? Colors.amber.shade700
                : Colors.amber.shade100;
            borderColor = Colors.amber;
            circleColor = Colors.amber;
          }
        }

        return GestureDetector(
          onTap: !_answered ? () => setState(() => _selectedIndex = i) : null,
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

  Widget _buildCompletar(Question q) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return TextField(
      enabled: !_answered,
      onChanged: (value) {
        setState(() {
          _textAnswer = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Escribe la respuesta',
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: textColor, fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return FutureBuilder<List<Question>>(
      future: _futureQuestions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No hay preguntas disponibles')),
          );
        }

        _questions = snapshot.data!;
        final q = _questions[_current];

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Pregunta ${_current + 1}/${_questions.length}',
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
                    value: (_current + 1) / _questions.length,
                    backgroundColor: Colors.grey[400],
                    color: const Color.fromARGB(255, 23, 159, 52),
                    minHeight: 18,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(((_current + 1) / _questions.length) * 100).toInt()}% completado',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    q.question,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  q.type == 'completar' ? _buildCompletar(q) : _buildOptions(q),
                  const SizedBox(height: 40),
                  if (!_answered)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (q.type == 'completar'
                                ? _textAnswer.trim().isEmpty
                                : _selectedIndex == null)
                            ? null
                            : _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ), // Aumenta tamaño
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
                          _isCorrect ? 'Continuar' : 'Volver a intentar',
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

  Widget _buildFeedbackContainer({
    required bool correct,
    String? explanation,
    String? message,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: correct ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct ? Icons.check_circle : Icons.cancel,
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
              explanation,
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
