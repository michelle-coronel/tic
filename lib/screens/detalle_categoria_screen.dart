import 'package:flutter/material.dart'; // Importa los widgets de Flutter para la interfaz
import 'package:flutter_tts/flutter_tts.dart'; // Importa la librería para síntesis de voz (Text-to-Speech)

import 'quiz_screen.dart'; // Importa la pantalla del quiz
import '../models/categoria.dart'; // Importa el modelo Categoria

// Widget Stateful que muestra el detalle de una categoría específica (ej. Hardware)
class DetalleCategoriaScreen extends StatefulWidget {
  final Categoria categoria; // Categoría que será mostrada en esta pantalla

  const DetalleCategoriaScreen({super.key, required this.categoria});

  @override
  State<DetalleCategoriaScreen> createState() => _DetalleCategoriaScreenState();
}

// Estado asociado al widget DetalleCategoriaScreen
class _DetalleCategoriaScreenState extends State<DetalleCategoriaScreen> {
  final FlutterTts flutterTts =
      FlutterTts(); // Instancia de la clase FlutterTts para síntesis de voz

  // Texto que será leído por la síntesis de voz
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

  bool isSpeaking = false; // Indica si el TTS está hablando actualmente
  bool isPaused = false; // Indica si la lectura está pausada

  @override
  void initState() {
    super.initState();

    // Configura idioma, tono y velocidad del TTS
    flutterTts.setLanguage('es-ES');
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

    // Manejador cuando comienza la lectura
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    // Manejador cuando termina la lectura
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });

    // Manejador cuando se pausa la lectura
    flutterTts.setPauseHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = true;
      });
    });

    // Manejador cuando se reanuda la lectura
    flutterTts.setContinueHandler(() {
      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
    });

    // Manejador cuando se cancela la lectura
    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
    });
  }

  @override
  void dispose() {
    // Detiene la lectura TTS cuando el widget se destruye para liberar recursos
    flutterTts.stop();
    super.dispose();
  }

  // Método para iniciar la lectura del texto
  Future<void> _speak() async {
    await flutterTts.speak(textoALeer);
  }

  // Método para pausar la lectura
  Future<void> _pause() async {
    await flutterTts.pause();
  }

  // Método para continuar la lectura (reanudar)
  Future<void> _continue() async {
    // flutter_tts no siempre soporta resume, por eso se llama speak de nuevo
    await flutterTts.speak(textoALeer);
  }

  // Método para detener la lectura completamente
  Future<void> _stop() async {
    await flutterTts.stop();
  }

  // Getter que devuelve el texto para mostrar en el botón principal según el estado actual
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  // Getter que devuelve el ícono para mostrar en el botón principal según el estado actual
  IconData get estadoIcono {
    if (isSpeaking) return Icons.pause;
    if (isPaused) return Icons.play_arrow;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con el nombre de la categoría
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

      // Cuerpo principal en columna vertical
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila con botones para controlar la síntesis de voz
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón principal para controlar la lectura (Escuchar, Pausar, Reanudar)
                Semantics(
                  label:
                      '$estadoTexto el texto con voz', // Etiqueta accesible sin repetir "botón"
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
                        minWidth: 48, // Tamaño mínimo para accesibilidad táctil
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

                // Botón para detener la lectura por completo
                Semantics(
                  label:
                      'Detener lectura de voz', // Descripción clara sin repetir "botón"
                  button: true,
                  child: InkWell(
                    onTap: _stop,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth:
                            60, // Tamaño mínimo táctil mayor para botón de detener
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
                        Icons
                            .refresh, // Icono que representa la acción de detener/reiniciar
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenedor con scroll para mostrar el texto e imagen de forma cómoda
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ), // Borde gris alrededor
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(
                    context,
                  ).cardColor, // Color adaptativo según tema
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título centrado en negrita
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

                    // Imagen ilustrativa centrada
                    Center(
                      child: Image.asset(
                        'assets/images/hardware.jpeg',
                        width: 300,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Texto introductorio justificado
                    const Text(
                      'El hardware es todo lo que puedes tocar en una computadora o dispositivo. '
                      'Son las partes físicas como el teclado, la pantalla, el ratón, etc.\n',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),

                    // Subtítulo con estilo destacado y color azul
                    Text(
                      'Ejemplos de hardware comunes:\n',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 13, 116, 200),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Lista detallada usando RichText para dar formato al texto
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        children: const [
                          TextSpan(
                            text: '1. Monitor:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Muestra información en pantalla (salida)\n\n',
                          ),
                          TextSpan(
                            text: '2. Teclado:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Permite al usuario ingresar datos, texto, comandos y funciones\n\n',
                          ),
                          TextSpan(
                            text: '3. Ratón:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Se usa para mover el cursor y hacer clic\n\n',
                          ),
                          TextSpan(
                            text: '4. CPU o torre:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Es el cerebro del computador, donde se procesan los datos (proceso)\n\n',
                          ),
                          TextSpan(
                            text: '5. Impresora:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Saca los documentos en papel\n\n'),
                          TextSpan(
                            text: '6. Altavoces:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Reproducen sonido\n\n'),
                          TextSpan(
                            text: '7. Cámara web:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Sirve para hacer videollamadas\n\n'),
                          TextSpan(
                            text: '8. Micrófono:\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Permite grabar o hablar en videollamadas\n',
                          ),
                        ],
                      ),
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
