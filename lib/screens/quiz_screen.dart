import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/question.dart';

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

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _futureQuestions = _loadQuestions();
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
    if (_selectedIndex == null) return;

    setState(() {
      _answered = true;
      _isCorrect = _selectedIndex == _questions[_current].answerIndex;
      if (_isCorrect) _score++;
    });

    _playSound(_isCorrect);
  }

  void _nextQuestion() {
    setState(() {
      _answered = false;
      _selectedIndex = null;
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
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resultado'),
        content: Text('Tu puntaje: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Listo'),
          ),
        ],
      ),
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
                  // Barra de progreso
                  Container(
                    width: double.infinity,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_current + 1) / _questions.length,
                        backgroundColor: Colors.transparent,
                        color: const Color.fromARGB(255, 23, 159, 52),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(((_current + 1) / _questions.length) * 100).toInt()}% completado',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // ignore: deprecated_member_use
                        color: textColor.withOpacity(0.7),
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

                  ...List.generate(q.options.length, (i) {
                    final isSelected = i == _selectedIndex;

                    Color borderColor = Colors.grey.shade400;
                    Color bgColor = theme.cardColor;
                    Color circleColor = Colors.transparent;
                    Color optionTextColor =
                        theme.textTheme.bodyLarge?.color ?? Colors.black;

                    if (_answered && isSelected) {
                      if (_isCorrect) {
                        bgColor = theme.cardColor;
                        circleColor = Colors.green;
                        borderColor = Colors.green;
                        optionTextColor =
                            theme.textTheme.bodyLarge?.color ?? Colors.black;
                      } else {
                        bgColor = Colors.red.shade100;
                        circleColor = Colors.red;
                        borderColor = Colors.red;
                        optionTextColor = Colors.red.shade900;
                      }
                    } else if (!_answered && isSelected) {
                      bgColor = Colors.amber.shade100;
                      circleColor = Colors.amber;
                      borderColor = Colors.amber;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (!_answered) {
                          setState(() {
                            _selectedIndex = i;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
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
                                q.options[i],
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

                  const SizedBox(height: 40),
                  if (!_answered)
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedIndex == null
                              ? null
                              : _checkAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Comprobar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  if (_answered) ...[
                    const SizedBox(height: 16),
                    if (_isCorrect)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: const Color.fromARGB(255, 44, 165, 50),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '¡Muy bien!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                      255,
                                      43,
                                      145,
                                      46,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              q.explanation,
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.cancel, color: Colors.red, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              'Incorrecto',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isCorrect
                              ? _nextQuestion
                              : _retryQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCorrect
                                ? Colors.green
                                : Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _isCorrect ? 'Continuar' : 'Volver a intentar',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
}
