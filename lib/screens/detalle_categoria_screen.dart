import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_screen.dart';
import '../models/categoria.dart';

// Pantalla de detalle de una categoría, en este caso: Hardware
class DetalleCategoriaScreen extends StatefulWidget {
  final Categoria categoria;

  const DetalleCategoriaScreen({super.key, required this.categoria});

  @override
  State<DetalleCategoriaScreen> createState() => _DetalleCategoriaScreenState();
}

class _DetalleCategoriaScreenState extends State<DetalleCategoriaScreen> {
  final FlutterTts flutterTts = FlutterTts(); // Motor de texto a voz

  // Texto que será leído por voz
  final String textoALeer = '''
El hardware es todo lo que puedes tocar en una computadora o dispositivo. Son las partes físicas como el teclado, la pantalla, el ratón, etc.

Ejemplos de hardware comunes:

1. Monitor: Muestra información en pantalla (salida)
2. Teclado: Se usa para escribir y tiene letras, números y símbolos (entrada)
3. Ratón: Se usa para mover el cursor y hacer clic
4. CPU o torre: Es el cerebro del computador, es decir, donde se procesan los datos (proceso)
5. Impresora: Saca los documentos en papel
6. Altavoces: Reproducen sonido
7. Cámara web: Sirve para hacer videollamadas
8. Micrófono: Permite grabar o hablar en videollamadas
''';

  // Estados para controlar si se está hablando o está pausado
  bool isSpeaking = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('es-ES'); // Idioma: español
    flutterTts.setPitch(1.0); // Tono de voz
    flutterTts.setSpeechRate(0.5); // Velocidad de lectura

    // Configura los eventos del TTS
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
    flutterTts.stop(); // Detiene la voz al cerrar pantalla
    super.dispose();
  }

  // Funciones para controlar el texto a voz
  Future<void> _speak() async => await flutterTts.speak(textoALeer);
  Future<void> _pause() async => await flutterTts.pause();
  Future<void> _continue() async => await flutterTts.speak(textoALeer);
  Future<void> _stop() async => await flutterTts.stop();

  // Devuelve el texto del botón según el estado actual
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  // Devuelve el ícono del botón según el estado actual
  IconData get estadoIcono {
    if (isSpeaking) return Icons.pause;
    if (isPaused) return Icons.play_arrow;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria.nombre, // Título: nombre de la categoría
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
          // Botones de control de voz
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
                // Botón Detener
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
          // Contenido educativo (scrollable)
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
                        '¿Qué es el hardware?',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Imagen
                    Center(
                      child: Image.asset(
                        'assets/images/hardware.jpeg',
                        width: 300,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Texto introductorio
                    const Text(
                      'El hardware es todo lo que puedes tocar en una computadora o dispositivo. '
                      'Son las partes físicas como el teclado, la pantalla, el ratón, etc.\n',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    // Subtítulo
                    Text(
                      'Ejemplos de hardware comunes:\n',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 13, 116, 200),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Lista de dispositivos
                    Semantics(
                      label: 'Lista de ejemplos de hardware con explicación',
                      child: RichText(
                        textScaleFactor: textScale,
                        text: TextSpan(
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.5),
                          children: const [
                            TextSpan(
                              text: '1. Monitor:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Muestra información en pantalla (salida)\n\n',
                            ),
                            TextSpan(
                              text: '2. Teclado:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Permite al usuario ingresar datos, texto, comandos y funciones\n\n',
                            ),
                            TextSpan(
                              text: '3. Ratón:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Se usa para mover el cursor y hacer clic\n\n',
                            ),
                            TextSpan(
                              text: '4. CPU o torre:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Es el cerebro del computador, donde se procesan los datos (proceso)\n\n',
                            ),
                            TextSpan(
                              text: '5. Impresora:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: 'Saca los documentos en papel\n\n'),
                            TextSpan(
                              text: '6. Altavoces:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: 'Reproducen sonido\n\n'),
                            TextSpan(
                              text: '7. Cámara web:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Sirve para hacer videollamadas\n\n',
                            ),
                            TextSpan(
                              text: '8. Micrófono:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Permite grabar o hablar en videollamadas\n',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón para iniciar el quiz
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
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
