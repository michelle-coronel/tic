import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_software_screen.dart'; // Pantalla de quiz específica para software
import '../models/categoria.dart'; // Modelo Categoria

class DetalleSoftwareScreen extends StatefulWidget {
  final Categoria categoria; // Categoría que se mostrará

  const DetalleSoftwareScreen({super.key, required this.categoria});

  @override
  State<DetalleSoftwareScreen> createState() => _DetalleSoftwareScreenState();
}

class _DetalleSoftwareScreenState extends State<DetalleSoftwareScreen> {
  final FlutterTts flutterTts =
      FlutterTts(); // Instancia de TTS para síntesis de voz

  bool isSpeaking = false; // Estado: si está hablando
  bool isPaused = false; // Estado: si está pausado

  // Texto que será leído por voz
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

  @override
  void initState() {
    super.initState();

    // Configuraciones iniciales de TTS
    flutterTts.setLanguage('es-ES');
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

    // Handlers para actualizar estado visual según eventos de TTS
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
    // Para el TTS al salir de la pantalla
    flutterTts.stop();
    super.dispose();
  }

  // Métodos para controlar TTS
  Future<void> _speak() async => await flutterTts.speak(textoALeer);

  Future<void> _pause() async => await flutterTts.pause();

  Future<void> _continue() async => await flutterTts.speak(textoALeer);

  Future<void> _stop() async => await flutterTts.stop();

  // Texto dinámico del botón según estado
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  // Icono dinámico del botón según estado
  IconData get estadoIcono {
    if (isSpeaking) return Icons.pause;
    if (isPaused) return Icons.play_arrow;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget
              .categoria
              .nombre, // Título del AppBar con el nombre de la categoría
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
          // Fila con botones para controlar TTS (Escuchar/Pausar/Reanudar) y Restablecer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
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
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.3 * 255).round()),
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
                InkWell(
                  onTap: _stop,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.3 * 255).round()),
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
              ],
            ),
          ),

          // Contenedor con padding y borde para el contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título centrado
                    Center(
                      child: Text(
                        '¿Qué es el software?',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Imagen ilustrativa centrada
                    Center(
                      child: Image.asset(
                        'assets/images/software.jpg',
                        width: 300,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Texto introductorio con justificado
                    const Text(
                      'El software es el conjunto de programas, instrucciones y datos que permiten a una computadora realizar tareas específicas. '
                      'A diferencia del hardware (las partes físicas), el software no se puede tocar y es esencial para el funcionamiento del equipo.\n',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),

                    // Texto enriquecido con estilos para tipos y ejemplos de software
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Tipos de software:\n\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 13, 116, 200),
                            ),
                          ),
                          TextSpan(
                            text: '• Software de sistema:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Controla y gestiona el hardware\n\n'),
                          TextSpan(
                            text: '• Software de aplicación:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Permite al usuario realizar tareas específicas\n\n',
                          ),
                          TextSpan(
                            text: '• Software de programación:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Herramientas para crear otros programas\n\n',
                          ),
                          TextSpan(
                            text: 'Ejemplos de software:\n\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 13, 116, 200),
                            ),
                          ),
                          TextSpan(
                            text: '• Sistemas operativos:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Windows, macOS, Linux, Android\n\n'),
                          TextSpan(
                            text: '• Aplicaciones:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Word, Excel, Photoshop, WhatsApp\n\n',
                          ),
                          TextSpan(
                            text: '• Navegadores web:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Chrome, Firefox, Safari\n\n'),
                          TextSpan(
                            text: '• Juegos:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Minecraft, Fortnite\n\n'),
                          TextSpan(
                            text: '• Programación:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Python, Visual Studio Code\n\n'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón para iniciar el quiz, abajo y ancho completo
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navega a la pantalla QuizSoftwareScreen
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
