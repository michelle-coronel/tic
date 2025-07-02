import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_software_screen.dart';
import '../models/categoria.dart';

// Pantalla que muestra detalles sobre el software y permite iniciar el quiz
class DetalleSoftwareScreen extends StatefulWidget {
  final Categoria categoria;

  const DetalleSoftwareScreen({super.key, required this.categoria});

  @override
  State<DetalleSoftwareScreen> createState() => _DetalleSoftwareScreenState();
}

class _DetalleSoftwareScreenState extends State<DetalleSoftwareScreen> {
  final FlutterTts flutterTts = FlutterTts(); // Motor de texto a voz

  // Texto que se reproducirá por voz
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
''';

  // Estados de reproducción de voz
  bool isSpeaking = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    // Configuración inicial del TTS
    flutterTts.setLanguage('es-ES');
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

    // Manejadores de eventos del TTS
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = true;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detiene la lectura si el widget se elimina
    super.dispose();
  }

  // Métodos para controlar el texto a voz
  Future<void> _speak() async => await flutterTts.speak(textoALeer);
  Future<void> _pause() async => await flutterTts.pause();
  Future<void> _continue() async => await flutterTts.speak(textoALeer);
  Future<void> _stop() async => await flutterTts.stop();

  // Texto del botón de voz según el estado
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  // Icono del botón de voz según el estado
  IconData get estadoIcono {
    if (isSpeaking) return Icons.pause;
    if (isPaused) return Icons.play_arrow;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    final double baseFontSize = 16.0;
    final double titleFontSize = 20.0;
    final double subtitleFontSize = 18.0;
    final double textScale = MediaQuery.of(context).textScaleFactor;

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
          // Botones para reproducir, pausar y detener la voz
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón Escuchar / Pausar / Reanudar
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
                // Botón Detener lectura
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

          // Contenido principal con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    // Título
                    Center(
                      child: Text(
                        '¿Qué es el software?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        textAlign: TextAlign.center,
                        textScaleFactor: textScale,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Imagen
                    Center(
                      child: Image.asset(
                        'assets/images/software.jpg',
                        width: 300,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Descripción del software
                    Text(
                      'El software es el conjunto de programas, instrucciones y datos que permiten a una computadora realizar tareas específicas.\n\n'
                      'A diferencia del hardware (las partes físicas), el software no se puede tocar y es esencial para el funcionamiento del equipo.\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textAlign: TextAlign.justify,
                      textScaleFactor: textScale,
                    ),

                    // Tipos y ejemplos
                    const SizedBox(height: 8),
                    Text(
                      'Tipos y ejemplos de software:\n',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 13, 116, 200),
                      ),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    // Software de sistema
                    Text(
                      '• Software de sistema:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Controla y gestiona el hardware\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    // Software de aplicación
                    Text(
                      '• Software de aplicación:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Permite al usuario realizar tareas específicas\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    // Software de programación
                    Text(
                      '• Software de programación:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Herramientas para crear otros programas\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 16),
                    // Ejemplos
                    Text(
                      'Ejemplos de software:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: subtitleFontSize,
                        color: Color.fromARGB(255, 13, 116, 200),
                      ),
                      textScaleFactor: textScale,
                    ),

                    // Lista de ejemplos
                    const SizedBox(height: 8),
                    Text(
                      '• Sistemas operativos:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Windows, macOS, Linux, Android\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Aplicaciones:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Word, Excel, Photoshop, WhatsApp\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Navegadores web:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Chrome, Firefox, Safari\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Juegos:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Minecraft, Fortnite\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Programación:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Python, Visual Studio Code\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Herramientas en educación:\n',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 13, 116, 200),
                      ),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Herramientas de apoyo:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Zoom, Meet\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Herramientas de evaluación\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Google Forms\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '• Herramientas de Enseñanza/Aprendizaje:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                      ),
                      textScaleFactor: textScale,
                    ),
                    Text(
                      'Duolingo, Khan Academy\n',
                      style: TextStyle(fontSize: baseFontSize),
                      textScaleFactor: textScale,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón inferior para iniciar el quiz
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
