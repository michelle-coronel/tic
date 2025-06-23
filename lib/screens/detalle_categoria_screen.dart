import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'quiz_screen.dart';
import '../models/categoria.dart';

class DetalleCategoriaScreen extends StatefulWidget {
  final Categoria categoria;

  const DetalleCategoriaScreen({super.key, required this.categoria});

  @override
  State<DetalleCategoriaScreen> createState() => _DetalleCategoriaScreenState();
}

class _DetalleCategoriaScreenState extends State<DetalleCategoriaScreen> {
  final FlutterTts flutterTts = FlutterTts();

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

  bool isSpeaking = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('es-ES');
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

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
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    await flutterTts.speak(textoALeer);
  }

  Future<void> _pause() async {
    await flutterTts.pause();
  }

  Future<void> _continue() async {
    await flutterTts.speak(textoALeer);
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

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
          // Botones Escuchar y Restablecer alineados a la derecha, arriba
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón Escuchar/Pausar/Reanudar
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

                // Botón Restablecer (refresh)
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
              ],
            ),
          ),

          // Texto "¿Qué es el hardware?" centrado y con tamaño aumentado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '¿Qué es el hardware?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Imagen centrada
          Center(child: Image.asset('assets/images/hardware.jpeg', width: 300)),

          const SizedBox(height: 16),

          // Texto explicativo con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  children: const [
                    TextSpan(
                      text:
                          '\nEl hardware es todo lo que puedes tocar en una computadora o dispositivo. '
                          'Son las partes físicas como el teclado, la pantalla, el ratón, etc.\n\n'
                          'Ejemplos de hardware comunes:\n\n',
                    ),
                    TextSpan(
                      text: '1. Monitor:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Muestra información en pantalla (salida)\n\n',
                    ),
                    TextSpan(
                      text: '2. Teclado:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Se usa para escribir y tiene letras, números y símbolos (entrada)\n\n',
                    ),
                    TextSpan(
                      text: '3. Ratón:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Se usa para mover el cursor y hacer clic\n\n',
                    ),
                    TextSpan(
                      text: '4. CPU o torre:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Es el cerebro del computador, es decir, donde se procesan los datos (proceso)\n\n',
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
                    TextSpan(text: 'Sirve para hacer videollamadas\n\n'),
                    TextSpan(
                      text: '8. Micrófono:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Permite grabar o hablar en videollamadas\n',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón Iniciar Quiz abajo
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
