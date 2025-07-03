import 'dart:convert'; // Para decodificar JSON
import 'package:flutter/material.dart'; // Widgets de Flutter
import 'package:audioplayers/audioplayers.dart'; // Para reproducir sonidos
import '../models/question.dart'; // Modelo de preguntas
import 'resultado_screen.dart'; // Pantalla para mostrar resultados

// Widget principal del quiz de software
class QuizSoftwareScreen extends StatefulWidget {
  const QuizSoftwareScreen({super.key});

  @override
  State<QuizSoftwareScreen> createState() => _QuizSoftwareScreenState();
}

class _QuizSoftwareScreenState extends State<QuizSoftwareScreen> {
  late Future<List<Question>>
  _futureQuestions; // Futuro para cargar las preguntas
  late List<Question> _questions; // Lista con las preguntas cargadas
  int _current = 0; // Índice de la pregunta actual
  int _score = 0; // Puntaje acumulado
  bool _modoAccesibleActivado =
      false; // Para activar modo accesible manualmente
  int?
  _selectedIndex; // Índice de opción seleccionada para preguntas de opción múltiple
  bool _answered = false; // Si la pregunta ya fue respondida
  bool _isCorrect = false; // Si la respuesta fue correcta
  String _textAnswer = ''; // Respuesta escrita para preguntas tipo completar
  final AudioPlayer _audioPlayer = AudioPlayer(); // Reproductor de sonidos

  late DateTime _startTime; // Tiempo cuando inicia el quiz

  List<DragItem> _dragItems = []; // Items para preguntas tipo arrastrar
  Map<String, List<DragItem>> _acceptedItems =
      {}; // Items aceptados en cada categoría (target)

  @override
  void initState() {
    super.initState();
    _futureQuestions = _loadQuestions(); // Carga las preguntas al iniciar
    _startTime = DateTime.now(); // Registra la hora de inicio
  }

  // Función para cargar las preguntas desde un archivo JSON local
  Future<List<Question>> _loadQuestions() async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/images/software_questions.json'); // Lee JSON
    final List<dynamic> jsonData = json.decode(jsonString); // Decodifica JSON
    return jsonData
        .map((e) => Question.fromJson(e))
        .toList(); // Convierte a lista de Question
  }

  // Reproduce sonido dependiendo si la respuesta es correcta o incorrecta
  Future<void> _playSound(bool isCorrect) async {
    final file = isCorrect ? 'sounds/correcto.mp3' : 'sounds/incorrecto.mp3';
    await _audioPlayer.play(AssetSource(file));
  }

  // Método para verificar si la respuesta dada es correcta
  void _checkAnswer() {
    final q = _questions[_current];

    if (q.type == 'completar') {
      // Para preguntas tipo completar, compara texto ingresado con respuesta correcta (sin distinguir mayúsculas/minúsculas)
      final correct =
          q.answerText?.trim().toLowerCase() ==
          _textAnswer.trim().toLowerCase();

      setState(() {
        _answered = true; // Marca que se respondió
        _isCorrect = correct; // Marca si es correcta o no
        if (_isCorrect) _score++; // Incrementa puntaje si es correcta
      });

      _playSound(_isCorrect); // Reproduce sonido correspondiente
    } else if (q.type == 'arrastrar') {
      // Para preguntas tipo arrastrar, verifica que todos los items estén en la categoría correcta
      bool allCorrect = true;
      for (var item in _dragItems) {
        bool found = false;
        _acceptedItems.forEach((categoria, items) {
          if (items.contains(item)) {
            if (categoria != item.categoriaCorrecta) allCorrect = false;
            found = true;
          }
        });
        if (!found)
          allCorrect = false; // Si algún item no está asignado, es incorrecto
      }

      setState(() {
        _answered = true;
        _isCorrect = allCorrect;
        if (_isCorrect) _score++;
      });

      _playSound(_isCorrect);
    } else {
      // Para preguntas de opción múltiple
      if (_selectedIndex == null) return; // Si no hay selección, no hace nada
      setState(() {
        _answered = true;
        _isCorrect =
            _selectedIndex ==
            q.answerIndex; // Compara índice seleccionado con respuesta correcta
        if (_isCorrect) _score++;
      });
      _playSound(_isCorrect);
    }
  }

  // Avanza a la siguiente pregunta o muestra resultados si se terminó el quiz
  void _nextQuestion() {
    setState(() {
      _answered = false;
      _selectedIndex = null;
      _textAnswer = '';
      _isCorrect = false;
      _modoAccesibleActivado = false;
      if (_current < _questions.length - 1) {
        _current++;
        _initDragItemsIfNeeded(); // Inicializa los items para la siguiente pregunta si es tipo arrastrar
      } else {
        _showResult(); // Muestra pantalla de resultados al terminar
      }
    });
  }

  // Permite reintentar la pregunta actual (resetea estado)
  void _retryQuestion() {
    setState(() {
      _answered = false;
      _selectedIndex = null;
      _textAnswer = '';
      _modoAccesibleActivado = false;
      if (_questions[_current].type == 'arrastrar') {
        _initDragItemsIfNeeded(); // Reinicia los items si es pregunta arrastrar
      }
    });
  }

  // Navega a la pantalla de resultados con datos del quiz
  void _showResult() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime); // Calcula duración total
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

  // Inicializa los items para preguntas tipo arrastrar, asignando listas vacías a cada target
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

  // Construye widget para preguntas tipo completar (input de texto)
  Widget _buildCompletar(Question q) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return TextField(
      enabled: !_answered, // Solo editable si no se respondió aún
      onChanged: (value) =>
          setState(() => _textAnswer = value), // Actualiza texto ingresado
      decoration: const InputDecoration(
        labelText: 'Escribe la respuesta',
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: textColor, fontSize: 18),
    );
  }

  // Construye opciones para preguntas de opción múltiple
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

        // Cambios visuales según estado de la respuesta y selección
        if (_answered && isSelected) {
          if (_isCorrect) {
            // Correcta: borde y círculo verde
            borderColor = Colors.green;
            circleColor = Colors.green;
          } else {
            // Incorrecta: fondo y borde rojos, texto más claro
            bgColor = isDarkMode ? Colors.red.shade900 : Colors.red.shade100;
            borderColor = Colors.red;
            circleColor = Colors.red;
            optionTextColor = isDarkMode
                ? Colors.red.shade300
                : Colors.red.shade900;
          }
        } else if (!_answered && isSelected) {
          // Seleccionada antes de comprobar: fondo y borde ámbar
          bgColor = isDarkMode ? Colors.amber.shade700 : Colors.amber.shade100;
          borderColor = Colors.amber;
          circleColor = Colors.amber;
        }

        return GestureDetector(
          onTap: !_answered
              ? () => setState(() => _selectedIndex = i)
              : null, // Selección solo si no ha respondido
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

  // Construye widget para preguntas tipo arrastrar y soltar
  Widget _buildArrastrar(Question q) {
    if (_dragItems.isEmpty) _initDragItemsIfNeeded();

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título Opciones
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
        // Lista de elementos draggeables
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
                // Cómo se ve el item mientras se arrastra
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
                // Cómo se ve el item normalmente
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
        // Título Categorías (targets)
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
        // Lista de targets donde se sueltan los items
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
                        // Muestra los items aceptados dentro del target
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
                onWillAcceptWithDetails: (details) =>
                    !_answered, // Solo acepta si no se ha respondido aún
                onAcceptWithDetails: (details) {
                  final item = details.data;
                  if (!_acceptedItems[target]!.contains(item)) {
                    setState(() {
                      // Elimina item de cualquier categoría para moverlo solo a una
                      _acceptedItems.forEach((_, list) => list.remove(item));
                      // Lo agrega a la categoría actual
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

  // Alternativa accesible para preguntas tipo arrastrar (TalkBack)
  Widget _buildArrastrarAccesible(Question q) {
    if (q.items == null || q.targets == null) return const SizedBox();

    // Inicializa mapas si están vacíos
    if (_acceptedItems.isEmpty) {
      _acceptedItems = {for (var t in q.targets!) t: []};
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: q.items!.map((item) {
        final currentTarget = _acceptedItems.entries
            .firstWhere(
              (entry) => entry.value.contains(item),
              orElse: () => MapEntry('', []),
            )
            .key;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.blueGrey.shade700 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? Colors.blueGrey.shade300
                  : const Color.fromARGB(255, 200, 200, 200),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Aquí va el Semantics
              Semantics(
                label:
                    'Lista desplegable accesible. Usa TalkBack para seleccionar una opción.',
                child: const Text(
                  'Modo accesible activado: selecciona una opción de la lista.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 4),

              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: currentTarget.isEmpty ? null : currentTarget,
                  decoration: const InputDecoration(
                    labelText: 'Selecciona una categoría',
                    border: OutlineInputBorder(),
                  ),

                  dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  onChanged: _answered
                      ? null
                      : (String? newTarget) {
                          if (newTarget == null) return;
                          setState(() {
                            // Quita de todas las categorías
                            _acceptedItems.forEach(
                              (_, list) => list.remove(item),
                            );
                            // Agrega a la nueva
                            _acceptedItems[newTarget]!.add(item);
                          });
                        },
                  items: q.targets!
                      .map(
                        (target) => DropdownMenuItem(
                          value: target,
                          child: Text(target, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Construye contenedor de feedback (correcto o incorrecto) con mensaje y explicación
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

  // Construye la interfaz principal del quiz
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return FutureBuilder<List<Question>>(
      future: _futureQuestions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras carga muestra indicador
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Muestra error si falla carga
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Si no hay datos muestra mensaje
          return const Scaffold(
            body: Center(child: Text('No hay preguntas disponibles')),
          );
        }

        _questions = snapshot.data!;
        final q = _questions[_current];

        // Inicializa drag items después del build si es pregunta arrastrar y no están inicializados
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
                  // Barra de progreso
                  LinearProgressIndicator(
                    value: (_current + 1) / _questions.length,
                    backgroundColor: Colors.grey[400],
                    color: const Color.fromARGB(255, 23, 159, 52),
                    minHeight: 18,
                  ),
                  const SizedBox(height: 20),
                  // Texto porcentaje completado
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
                  // Texto pregunta
                  Text(
                    q.question,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Botón para cambiar de modo si es tipo arrastrar
                  if (q.type == 'arrastrar')
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _modoAccesibleActivado = !_modoAccesibleActivado;
                          });
                        },
                        icon: Icon(
                          _modoAccesibleActivado
                              ? Icons.touch_app
                              : Icons.accessibility_new,
                        ),
                        // Boton modo accesible / Modo arrastrar
                        label: Text(
                          _modoAccesibleActivado
                              ? 'Modo arrastrar'
                              : 'Modo accesible',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _modoAccesibleActivado
                              ? const Color.fromARGB(255, 156, 39, 176)
                              : Color.fromARGB(255, 3, 95, 234),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 8,
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Widget para la pregunta según tipo
                  if (q.type == 'completar')
                    _buildCompletar(q)
                  else if (q.type == 'arrastrar')
                    _modoAccesibleActivado
                        ? _buildArrastrarAccesible(q)
                        : _buildArrastrar(q)
                  else
                    _buildOptions(q),

                  const SizedBox(height: 40),
                  if (!_answered)
                    // Botón comprobar solo si no se ha respondido
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
                    // Feedback de la respuesta (correcto o incorrecto)
                    const SizedBox(height: 16),
                    _buildFeedbackContainer(
                      correct: _isCorrect,
                      message: _isCorrect ? '¡Muy bien!' : 'Incorrecto',
                      explanation: _isCorrect ? q.explanation : null,
                    ),
                    const SizedBox(height: 16),
                    // Botón para continuar o reintentar
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
}
