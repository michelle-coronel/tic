import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/question.dart';
import 'resultado_screen.dart';

class QuizSoftwareScreen extends StatefulWidget {
  const QuizSoftwareScreen({super.key});

  @override
  State<QuizSoftwareScreen> createState() => _QuizSoftwareScreenState();
}

class _QuizSoftwareScreenState extends State<QuizSoftwareScreen> {
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

  List<DragItem> _dragItems = [];
  Map<String, List<DragItem>> _acceptedItems = {};

  @override
  void initState() {
    super.initState();
    _futureQuestions = _loadQuestions();
    _startTime = DateTime.now();
  }

  Future<List<Question>> _loadQuestions() async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/images/software_questions.json');
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
    } else if (q.type == 'arrastrar') {
      bool allCorrect = true;
      for (var item in _dragItems) {
        bool found = false;
        _acceptedItems.forEach((categoria, items) {
          if (items.contains(item)) {
            if (categoria != item.categoriaCorrecta) allCorrect = false;
            found = true;
          }
        });
        if (!found) allCorrect = false;
      }
      setState(() {
        _answered = true;
        _isCorrect = allCorrect;
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
        _initDragItemsIfNeeded();
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
      if (_questions[_current].type == 'arrastrar') {
        _initDragItemsIfNeeded();
      }
    });
  }

  void _showResult() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    final tiempoFormateado =
        '${duration.inMinutes}m ${duration.inSeconds % 60}s';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoScreen(
          score: _score,
          totalQuestions: _questions.length,
          tiempoTotal: tiempoFormateado,
          questions: _questions,
          tema: 'Software',
          appBarTitle: 'Quiz Software',
        ),
      ),
    );
  }

  void _initDragItemsIfNeeded() {
    final q = _questions[_current];
    if (q.type == 'arrastrar' && q.items != null) {
      _dragItems = List<DragItem>.from(q.items!);
      _acceptedItems = {for (var t in q.targets!) t: []};
    } else {
      _dragItems = [];
      _acceptedItems = {};
    }
  }

  Widget _buildCompletar(Question q) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return TextField(
      enabled: !_answered,
      onChanged: (value) => setState(() => _textAnswer = value),
      decoration: const InputDecoration(
        labelText: 'Escribe la respuesta',
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: textColor, fontSize: 18),
    );
  }

  /*
  Widget _buildOptions(Question q) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final baseTextColor =
        theme.textTheme.bodyLarge?.color ??
        (isDarkMode ? Colors.white : Colors.black);

    return Column(
      children: List.generate(q.options?.length ?? 0, (i) {
        final isSelected = i == _selectedIndex;

        // Colores base para modo claro
        Color borderColor = Colors.grey.shade400;
        Color bgColor = theme.cardColor;
        Color circleColor = Colors.transparent;
        Color optionTextColor = baseTextColor;

        if (_answered && isSelected) {
          if (_isCorrect) {
            circleColor = Colors.green;
            borderColor = Colors.green;
            bgColor = isDarkMode
                ? Colors.green.shade900
                : Colors.green.shade100;
            optionTextColor = isDarkMode
                ? Colors.green.shade300
                : Colors.green.shade900;
          } else {
            bgColor = isDarkMode ? Colors.red.shade900 : Colors.red.shade100;
            circleColor = Colors.red;
            borderColor = Colors.red;
            optionTextColor = isDarkMode
                ? Colors.red.shade300
                : Colors.red.shade900;
          }
        } else if (!_answered && isSelected) {
          bgColor = isDarkMode ? Colors.amber.shade700 : Colors.amber.shade100;
          circleColor = Colors.amber;
          borderColor = Colors.amber;
          optionTextColor = isDarkMode ? Colors.black : Colors.black;
        } else {
          // Para opciones no seleccionadas, ajustar el color de texto y fondo según modo
          bgColor = isDarkMode ? Colors.grey.shade800 : theme.cardColor;
          optionTextColor = baseTextColor;
          borderColor = isDarkMode
              ? Colors.grey.shade600
              : Colors.grey.shade400;
        }

        return GestureDetector(
          onTap: !_answered ? () => setState(() => _selectedIndex = i) : null,
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
                          : (isDarkMode ? Colors.white70 : Colors.grey),
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
  }*/
  Widget _buildOptions(Question q) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final baseTextColor =
        theme.textTheme.bodyLarge?.color ??
        (isDarkMode ? Colors.white : Colors.black);

    return Column(
      children: List.generate(q.options?.length ?? 0, (i) {
        final isSelected = i == _selectedIndex;

        Color borderColor = Colors.grey.shade400;
        Color bgColor = theme.cardColor;
        Color circleColor = Colors.transparent;
        Color optionTextColor = baseTextColor;

        if (_answered && isSelected) {
          if (_isCorrect) {
            // ✅ CORRECTA: solo borde y bolita verdes
            borderColor = Colors.green;
            circleColor = Colors.green;
          } else {
            // ❌ INCORRECTA: fondo rojo + rojo en borde y bolita
            bgColor = isDarkMode ? Colors.red.shade900 : Colors.red.shade100;
            borderColor = Colors.red;
            circleColor = Colors.red;
            optionTextColor = isDarkMode
                ? Colors.red.shade300
                : Colors.red.shade900;
          }
        } else if (!_answered && isSelected) {
          // 🔘 Seleccionada (antes de comprobar): fondo ámbar
          bgColor = isDarkMode ? Colors.amber.shade700 : Colors.amber.shade100;
          borderColor = Colors.amber;
          circleColor = Colors.amber;
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
                          : (isDarkMode ? Colors.white70 : Colors.grey),
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

  Widget _buildArrastrar(Question q) {
    if (_dragItems.isEmpty) _initDragItemsIfNeeded();

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (q.targets != null && q.targets!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Opciones:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        Column(
          children: _dragItems.map((item) {
            final bool isAssigned = _acceptedItems.entries.any(
              (e) => e.value.contains(item),
            );

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Draggable<DragItem>(
                data: item,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAssigned
                        ? (isDarkMode
                              ? Colors.green.shade700
                              : Colors.green.shade200)
                        : (isDarkMode
                              ? Colors.blueGrey.shade700
                              : const Color.fromARGB(255, 243, 234, 164)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.blueGrey.shade300
                          : const Color.fromARGB(255, 240, 228, 5),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    isAssigned ? 'Seleccionado' : item.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? (isAssigned ? Colors.white : Colors.white70)
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (q.targets != null && q.targets!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Categorías:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        Column(
          children: q.targets!.map((target) {
            final accepted = _acceptedItems[target] ?? [];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: DragTarget<DragItem>(
                builder: (context, _, __) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey.shade600
                            : Colors.black45,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          target,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...accepted.map(
                          (item) => Text(
                            item.text,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onWillAcceptWithDetails: (details) => !_answered,
                onAcceptWithDetails: (details) {
                  final item = details.data;
                  if (!_acceptedItems[target]!.contains(item)) {
                    setState(() {
                      _acceptedItems.forEach((_, list) => list.remove(item));
                      _acceptedItems[target]!.add(item);
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (q.type == 'arrastrar' && _dragItems.isEmpty) {
            _initDragItemsIfNeeded();
          }
        });

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
                  if (q.type == 'completar')
                    _buildCompletar(q)
                  else if (q.type == 'arrastrar')
                    _buildArrastrar(q)
                  else
                    _buildOptions(q),

                  const SizedBox(height: 40),
                  if (!_answered)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (q.type == 'completar'
                                ? _textAnswer.trim().isEmpty
                                : (q.type != 'arrastrar' &&
                                      _selectedIndex == null))
                            ? null
                            : _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                    )
                  else ...[
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
}
