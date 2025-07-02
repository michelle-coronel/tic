import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_software_screen.dart';
import '../models/categoria.dart';

/// Pantalla que muestra detalles e información sobre el software
/// y permite iniciar un quiz relacionado.
/// Recibe un objeto [Categoria] para mostrar su nombre en el AppBar.
class DetalleSoftwareScreen extends StatefulWidget {
  final Categoria categoria;

  const DetalleSoftwareScreen({super.key, required this.categoria});

  @override
  State<DetalleSoftwareScreen> createState() => _DetalleSoftwareScreenState();
}

class _DetalleSoftwareScreenState extends State<DetalleSoftwareScreen> {
  /// Instancia de FlutterTts para síntesis de voz
  final FlutterTts flutterTts = FlutterTts();

  /// Texto que será leído en voz alta mediante síntesis TTS
  final String textoALeer = '''
El software es el conjunto de programas, instrucciones y datos que permiten a una computadora realizar tareas específicas. A diferencia del hardware (las partes físicas), el software no se puede tocar y es esencial para el funcionamiento del equipo.

Tipos de software:

1. Software de sistema: Controla y gestiona el hardware
2. Software de aplicación: Permite al usuario realizar tareas específicas
3. Software de programación: Herramientas para crear otros programas

Ejemplos de software:
Sistemas operativos: Windows, macOS, Linux, Android
Aplicaciones: Word, Excel, Photoshop, WhatsApp
Navegadores web: Chrome, Firefox, Safari
Juegos: Minecraft, Fortnite
Programación: Python, Visual Studio Code
Herramientas en educación: 
Herramientas de apoyo: Zoom, Google Meet, Microsoft Teams
Herramientas de evaluación: Google Forms, Socrative, Kahoot!
Herramientas de Enseñanza/Aprendizaje: Duolingo, Moodle, Khan Academic
''';

  /// Estado si el TTS está hablando
  bool isSpeaking = false;

  /// Estado si el TTS está pausado
  bool isPaused = false;

  /// Escala actual para zoom en el contenido
  double _currentScale = 1.0;

  /// Controlador para manipular la transformación (zoom y desplazamiento) del InteractiveViewer
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();

    // Configuración inicial del motor TTS
    flutterTts.setLanguage('es-ES');
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

    // Handler que se ejecuta cuando comienza la lectura
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    // Handler que se ejecuta al terminar la lectura
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });

    // Handler que se ejecuta al pausar la lectura
    flutterTts.setPauseHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = true;
      });
    });

    // Handler que se ejecuta al continuar la lectura después de pausar
    flutterTts.setContinueHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    // Handler que se ejecuta cuando se cancela la lectura
    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });
  }

  @override
  void dispose() {
    // Detener la lectura y liberar recursos del controlador de transformación
    flutterTts.stop();
    _transformationController.dispose();
    super.dispose();
  }

  /// Inicia la lectura en voz alta del texto
  Future<void> _speak() async => await flutterTts.speak(textoALeer);

  /// Pausa la lectura de voz
  Future<void> _pause() async => await flutterTts.pause();

  /// Continúa la lectura desde donde se pausó
  Future<void> _continue() async => await flutterTts.speak(textoALeer);

  /// Detiene la lectura completamente
  Future<void> _stop() async => await flutterTts.stop();

  /// Getter para texto dinámico del botón de control de voz
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  /// Getter para icono dinámico del botón de control de voz
  IconData get estadoIcono {
    if (isSpeaking) return Icons.pause;
    if (isPaused) return Icons.play_arrow;
    return Icons.volume_up;
  }

  /// Resetea el zoom a la escala original 1.0
  void _resetZoom() {
    setState(() {
      _currentScale = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  /// Alterna entre diferentes niveles de zoom: 1.0, 1.5, 2.0
  void _toggleZoom() {
    final List<double> zoomSteps = [1.0, 1.5, 2.0];
    int currentIndex = zoomSteps.indexOf(_currentScale);
    int nextIndex = (currentIndex + 1) % zoomSteps.length;
    double nextScale = zoomSteps[nextIndex];

    setState(() {
      _currentScale = nextScale;

      // Aplicar la escala o resetear si es 1.0
      if (_currentScale == 1.0) {
        _transformationController.value = Matrix4.identity();
      } else {
        _transformationController.value = Matrix4.identity()
          ..scale(_currentScale);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Factor de escala de texto según accesibilidad o configuración del dispositivo
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria.nombre,
          style:
              Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila con botones para controlar la lectura de texto con voz
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón para reproducir, pausar o reanudar la lectura
                Semantics(
                  label: '$estadoTexto el texto con voz',
                  button: true,
                  child: InkWell(
                    onTap: () {
                      if (isSpeaking) {
                        _pause();
                      } else if (isPaused) {
                        _continue();
                      } else {
                        _speak();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(estadoIcono, color: Colors.white, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            estadoTexto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botón para detener completamente la lectura y resetear
                Semantics(
                  label: 'Detener lectura de voz',
                  button: true,
                  child: InkWell(
                    onTap: _stop,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 60,
                        minHeight: 60,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Área principal con contenido del texto, imagen y zoom
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const ClampingScrollPhysics(),
                  child: GestureDetector(
                    onDoubleTap: _toggleZoom, // Zoom con doble tap
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      panEnabled: true, // Permite mover cuando hay zoom
                      scaleEnabled: false, // Desactiva zoom con pinch
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                '¿Qué es el software?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                textScaleFactor: textScale,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Center(
                              child: Image.asset(
                                'assets/images/software.jpg',
                                width: 300,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              'El software es el conjunto de programas, instrucciones y datos que permiten a una computadora realizar tareas específicas.\n\n'
                              'A diferencia del hardware (las partes físicas), el software no se puede tocar y es esencial para el funcionamiento del equipo.\n',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                              textScaleFactor: textScale,
                            ),

                            // Descripción de tipos y ejemplos con formatos variados
                            const SizedBox(height: 8),
                            Text(
                              'Tipos y ejemplos de software:\n',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 13, 116, 200),
                              ),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Software de sistema:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Controla y gestiona el hardware\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Software de aplicación:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Permite al usuario realizar tareas específicas\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Software de programación:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Herramientas para crear otros programas\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 16),
                            Text(
                              'Ejemplos de software:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: const Color.fromARGB(255, 13, 116, 200),
                              ),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Sistemas operativos:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Windows, macOS, Linux, Android\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Aplicaciones:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Word, Excel, Photoshop, WhatsApp\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Navegadores web:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Chrome, Firefox, Safari\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Juegos:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Minecraft, Fortnite\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Programación:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Python, Visual Studio Code\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 16),
                            Text(
                              'Herramientas en educación:\n',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 13, 116, 200),
                              ),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Herramientas de apoyo:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Zoom, Google Meet, Microsoft Teams\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Herramientas de evaluación\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Google Forms, Socrative, Kahoot!\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '• Herramientas de Enseñanza/Aprendizaje:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textScaleFactor: textScale,
                            ),
                            Text(
                              'Duolingo, Moodle, Khan Academic\n',
                              style: TextStyle(fontSize: 16),
                              textScaleFactor: textScale,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Botón flotante para restablecer zoom cuando no está al 100%
                if (_currentScale != 1.0)
                  Positioned(
                    top: 12,
                    right: 20,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.zoom_in),
                      label: const Text('Restablecer pantalla'),
                      onPressed: _resetZoom,
                    ),
                  ),
              ],
            ),
          ),

          // Botón para iniciar el quiz relacionado con el software
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizSoftwareScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                elevation: 6,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text('Iniciar Quiz', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
