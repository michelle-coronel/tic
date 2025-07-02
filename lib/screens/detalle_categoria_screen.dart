import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_screen.dart';
import '../models/categoria.dart';

/// Pantalla que muestra detalles sobre una categoría (hardware),
/// con explicación textual, imagen y funcionalidad de lectura en voz alta,
/// además permite iniciar un quiz relacionado.
class DetalleCategoriaScreen extends StatefulWidget {
  /// Objeto de tipo Categoria que contiene datos sobre la categoría seleccionada.
  final Categoria categoria;

  /// Constructor que recibe la categoría requerida.
  const DetalleCategoriaScreen({super.key, required this.categoria});

  @override
  State<DetalleCategoriaScreen> createState() => _DetalleCategoriaScreenState();
}

class _DetalleCategoriaScreenState extends State<DetalleCategoriaScreen> {
  /// Instancia de FlutterTts para síntesis de voz.
  final FlutterTts flutterTts = FlutterTts();

  /// Texto largo que será leído en voz alta cuando se active la función.
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

  /// Estado actual: si se está hablando (lectura activa).
  bool isSpeaking = false;

  /// Estado actual: si la lectura está pausada.
  bool isPaused = false;

  /// Nivel actual de zoom aplicado al texto (1.0 = normal).
  double _currentScale = 1.0;

  /// Controlador para manejar transformaciones (zoom y desplazamiento) del contenido.
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();

    // Configuraciones iniciales para el motor de texto a voz:
    flutterTts.setLanguage('es-ES'); // Idioma español (España)
    flutterTts.setPitch(1.0); // Tono normal
    flutterTts.setSpeechRate(0.5); // Velocidad media lenta

    // Manejadores de eventos para actualizar estado según acción de TTS:
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
    // Detener cualquier lectura activa y liberar recursos.
    flutterTts.stop();
    _transformationController.dispose();
    super.dispose();
  }

  /// Método para iniciar la lectura en voz alta.
  Future<void> _speak() async => await flutterTts.speak(textoALeer);

  /// Método para pausar la lectura.
  Future<void> _pause() async => await flutterTts.pause();

  /// Método para continuar la lectura después de pausar.
  Future<void> _continue() async => await flutterTts.speak(textoALeer);

  /// Método para detener la lectura.
  Future<void> _stop() async => await flutterTts.stop();

  /// Texto que muestra el botón según estado actual de lectura.
  String get estadoTexto {
    if (isSpeaking) return 'Pausar';
    if (isPaused) return 'Reanudar';
    return 'Escuchar';
  }

  /// Icono que muestra el botón según estado actual de lectura.
  IconData get estadoIcono {
    if (isSpeaking) return Icons.pause;
    if (isPaused) return Icons.play_arrow;
    return Icons.volume_up;
  }

  /// Restablece el zoom a escala normal (1.0).
  void _resetZoom() {
    setState(() {
      _currentScale = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  /// Alterna entre diferentes niveles de zoom (1.0, 1.5, 2.0).
  void _toggleZoom() {
    final List<double> zoomSteps = [1.0, 1.5, 2.0];
    int currentIndex = zoomSteps.indexOf(_currentScale);
    int nextIndex = (currentIndex + 1) % zoomSteps.length;
    double nextScale = zoomSteps[nextIndex];

    setState(() {
      _currentScale = nextScale;

      // Aplicar escala manteniendo el offset actual, o resetear si volvemos a 1.0
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
    // Factor de escala de texto configurado en el dispositivo
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        // Título del AppBar con el nombre de la categoría (hardware)
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
          // Fila de botones para controlar la lectura en voz alta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón para iniciar, pausar o reanudar la lectura
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
                // Botón para detener la lectura
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

          // Contenido principal con explicación e imagen
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onDoubleTap: _toggleZoom, // Doble tap para alternar zoom
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      panEnabled:
                          true, // Permitir mover contenido cuando está zoom
                      scaleEnabled: false, // Desactivar zoom por pellizco
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
                            // Título principal centrado
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

                            // Imagen ilustrativa
                            Center(
                              child: Image.asset(
                                'assets/images/hardware.jpeg',
                                width: 300,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Texto introductorio sobre hardware
                            const Text(
                              'El hardware es todo lo que puedes tocar en una computadora o dispositivo. '
                              'Son las partes físicas como el teclado, la pantalla, el ratón, etc.\n',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),

                            // Subtítulo para ejemplos
                            Text(
                              'Ejemplos de hardware comunes:\n',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                      255,
                                      13,
                                      116,
                                      200,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 8),

                            // Lista detallada de ejemplos con formato accesible
                            Semantics(
                              label:
                                  'Lista de ejemplos de hardware con explicación',
                              child: RichText(
                                textScaleFactor: textScale,
                                text: TextSpan(
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                                  children: const [
                                    TextSpan(
                                      text: '1. Monitor:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Muestra información en pantalla (salida)\n\n',
                                    ),
                                    TextSpan(
                                      text: '2. Teclado:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Permite al usuario ingresar datos, texto, comandos y funciones\n\n',
                                    ),
                                    TextSpan(
                                      text: '3. Ratón:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Se usa para mover el cursor y hacer clic\n\n',
                                    ),
                                    TextSpan(
                                      text: '4. CPU o torre:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Es el cerebro del computador, donde se procesan los datos (proceso)\n\n',
                                    ),
                                    TextSpan(
                                      text: '5. Impresora:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Saca los documentos en papel\n\n',
                                    ),
                                    TextSpan(
                                      text: '6. Altavoces:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: 'Reproducen sonido\n\n'),
                                    TextSpan(
                                      text: '7. Cámara web:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Sirve para hacer videollamadas\n\n',
                                    ),
                                    TextSpan(
                                      text: '8. Micrófono:\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                ),

                // Botón para restablecer zoom visible solo si hay zoom aplicado
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

          // Botón inferior para iniciar el quiz relacionado
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navega a la pantalla de quiz cuando se presiona
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
