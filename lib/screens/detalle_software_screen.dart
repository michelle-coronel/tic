import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Librería para síntesis de voz (Text-To-Speech)

import 'quiz_software_screen.dart'; // Importa la pantalla del quiz de software
import '../models/categoria.dart'; // Modelo Categoria

// Widget Stateful que muestra el detalle de la categoría de Software y permite lectura en voz alta
class DetalleSoftwareScreen extends StatefulWidget {
  final Categoria categoria; // Recibe la categoría para mostrar su nombre

  const DetalleSoftwareScreen({super.key, required this.categoria});

  @override
  State<DetalleSoftwareScreen> createState() => _DetalleSoftwareScreenState();
}

class _DetalleSoftwareScreenState extends State<DetalleSoftwareScreen> {
  final FlutterTts flutterTts = FlutterTts(); // Instancia para síntesis de voz

  // Texto largo que se leerá con voz
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

  bool isSpeaking = false; // Indica si está leyendo
  bool isPaused = false; // Indica si la lectura está pausada

  @override
  void initState() {
    super.initState();

    // Configura el lenguaje, tono y velocidad del TTS
    flutterTts.setLanguage('es-ES'); // Español de España
    flutterTts.setPitch(1.0); // Tono normal
    flutterTts.setSpeechRate(0.5); // Velocidad media-lenta

    // Maneja eventos de inicio de lectura
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    // Evento cuando termina la lectura
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });

    // Evento cuando la lectura es pausada
    flutterTts.setPauseHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = true;
      });
    });

    // Evento cuando la lectura se reanuda
    flutterTts.setContinueHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    // Evento cuando la lectura es cancelada
    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });
  }

  @override
  void dispose() {
    // Para la lectura al cerrar la pantalla
    flutterTts.stop();
    super.dispose();
  }

  // Métodos para controlar la lectura de voz
  Future<void> _speak() async => await flutterTts.speak(textoALeer);
  Future<void> _pause() async => await flutterTts.pause();
  Future<void> _continue() async => await flutterTts.speak(textoALeer);
  Future<void> _stop() async => await flutterTts.stop();

  // Texto del botón según estado actual de lectura
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  // Ícono del botón según estado actual de lectura
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
              .nombre, // Muestra el nombre de la categoría en la barra superior
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
          // Fila con botones para controlar la lectura en voz alta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón principal para reproducir, pausar o reanudar el texto
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
                ),

                // Botón para detener completamente la lectura
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
                ),
              ],
            ),
          ),

          // Contenido principal con explicación y ejemplos sobre software
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Borde gris
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  color: Theme.of(
                    context,
                  ).cardColor, // Color de tarjeta según tema
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

                    // Imagen representativa
                    Center(
                      child: Image.asset(
                        'assets/images/software.jpg',
                        width: 300,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Texto descriptivo con semántica para accesibilidad
                    Semantics(
                      label:
                          'Descripción del software: El software es el conjunto de programas, instrucciones y datos que permiten a una computadora realizar tareas específicas. A diferencia del hardware, el software no se puede tocar y es esencial para el funcionamiento del equipo.',
                      child: const Text(
                        'El software es el conjunto de programas, instrucciones y datos que permiten a una computadora realizar tareas específicas. '
                        '\n\n A diferencia del hardware (las partes físicas), el software no se puede tocar y es esencial para el funcionamiento del equipo.\n',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtítulo para tipos y ejemplos
                    Text(
                      'Tipos y ejemplos de software:\n',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 13, 116, 200),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Texto enriquecido con los tipos y ejemplos de software, con semántica para lectores de pantalla
                    Semantics(
                      label: '''
1. Software de sistema: Controla y gestiona el hardware

2. Software de aplicación: Permite al usuario realizar tareas específicas

3. Software de programación: Herramientas para crear otros programas

Ejemplos:
• Sistemas operativos: Windows, macOS, Linux, Android
• Aplicaciones: Word, Excel, Photoshop, WhatsApp
• Navegadores web: Chrome, Firefox, Safari
• Juegos: Minecraft, Fortnite
• Programación: Python, Visual Studio Code
''',
                      child: RichText(
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
                            TextSpan(
                              text: 'Controla y gestiona el hardware\n\n',
                            ),
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
                              text:
                                  'Herramientas para crear otros programas\n\n',
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
                            TextSpan(
                              text: 'Windows, macOS, Linux, Android\n\n',
                            ),
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
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón al pie para iniciar el quiz de software
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navega a la pantalla del quiz de software
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
