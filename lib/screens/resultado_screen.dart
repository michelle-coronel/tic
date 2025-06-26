import 'package:flutter/material.dart';
import '../models/categoria.dart'; // Modelo para las categorías de temas
import '../models/question.dart'; // Modelo para las preguntas del quiz
import 'resultados_screen_hardware.dart'; // Pantalla resultados para Hardware
import 'lecciones_screen.dart'; // Pantalla de lecciones con lista de temas
import 'resultados_screen_software.dart'; // Pantalla resultados para Software

// Pantalla que muestra el resultado final de un quiz
class ResultadoScreen extends StatelessWidget {
  final int score; // Puntaje obtenido
  final int totalQuestions; // Total de preguntas del quiz
  final String tiempoTotal; // Tiempo total que tomó el quiz (como texto)
  final List<Question>
  questions; // Lista de preguntas respondidas (para detalle)
  final String tema; // Tema actual (Hardware, Software, etc.)
  final String appBarTitle; // Título a mostrar en la AppBar

  const ResultadoScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.tiempoTotal,
    required this.questions,
    required this.tema,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    final double porcentaje =
        (score / totalQuestions) * 100; // Calcula porcentaje
    final theme = Theme.of(context); // Tema actual
    final isDark =
        theme.brightness == Brightness.dark; // Si está en modo oscuro

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ), // Barra superior
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icono de trofeo
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            const SizedBox(height: 8),

            // Contenedor con info del resultado con estilo adaptado a tema claro/oscuro
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(
                        0xFF2E2E2E,
                      ) // Fondo gris oscuro en modo oscuro
                    : const Color(0xFFF3F3F3), // Fondo gris claro en modo claro
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mensaje de felicitación
                  Text(
                    '🎉 ¡Felicidades! 🎉',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Texto indicando tema completado
                  Text(
                    'Has completado el tema:',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Nombre del tema
                  Text(
                    tema,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Fila con ícono de reloj y tiempo total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Tiempo total: $tiempoTotal',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Fila con ícono de check y puntaje
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Puntaje: $score / $totalQuestions (${porcentaje.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pregunta qué acción desea realizar el usuario
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '¿Qué acción desea realizar?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para ver resultados detallados
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () {
                  // Navega a pantalla resultados según el tema
                  if (tema == 'Hardware') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultadosScreenHardware(
                          score: score,
                          totalQuestions: totalQuestions,
                          tiempoTotal: tiempoTotal,
                          questions: questions,
                        ),
                      ),
                    );
                  } else if (tema == 'Software') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultadosScreenSoftware(
                          score: score,
                          totalQuestions: totalQuestions,
                          tiempoTotal: tiempoTotal,
                          questions: questions,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Ver resultados',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botón para pasar al siguiente tema con confirmación (AlertDialog)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Tema completado'),
                      content: Text(
                        '¡Has completado el tema $tema con éxito!\n¿Deseas continuar con el siguiente tema?',
                      ),
                      actions: [
                        // Botón para cancelar y cerrar diálogo
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        // Botón para continuar al siguiente tema
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Cierra el diálogo

                            // Actualiza la lista de categorías según el tema completado
                            final categoriasActualizadas = tema == 'Hardware'
                                ? [
                                    Categoria(
                                      nombre: 'Hardware',
                                      iconoPath: 'assets/icons/1_icon.png',
                                      activo: true,
                                      completado: true, // Marca como completado
                                    ),
                                    Categoria(
                                      nombre: 'Software',
                                      iconoPath: 'assets/icons/2_icon.png',
                                      activo: true, // Habilita Software
                                      completado: false,
                                    ),
                                    Categoria(
                                      nombre: 'Sistemas Operativos',
                                      iconoPath: 'assets/icons/3_icon.png',
                                      activo: false,
                                      completado: false,
                                    ),
                                    Categoria(
                                      nombre: 'Internet',
                                      iconoPath: 'assets/icons/4_icon.png',
                                      activo: false,
                                      completado: false,
                                    ),
                                    Categoria(
                                      nombre: 'Actualizaciones de sistema',
                                      iconoPath: 'assets/icons/5_icon.png',
                                      activo: false,
                                      completado: false,
                                    ),
                                  ]
                                : [
                                    // Si el tema fue Software, habilita siguiente nivel
                                    Categoria(
                                      nombre: 'Hardware',
                                      iconoPath: 'assets/icons/1_icon.png',
                                      activo: true,
                                      completado: true,
                                    ),
                                    Categoria(
                                      nombre: 'Software',
                                      iconoPath: 'assets/icons/2_icon.png',
                                      activo: true,
                                      completado: true,
                                    ),
                                    Categoria(
                                      nombre: 'Sistemas Operativos',
                                      iconoPath: 'assets/icons/3_icon.png',
                                      activo: true,
                                      completado: false,
                                    ),
                                    Categoria(
                                      nombre: 'Internet',
                                      iconoPath: 'assets/icons/4_icon.png',
                                      activo: false,
                                      completado: false,
                                    ),
                                    Categoria(
                                      nombre: 'Actualizaciones de sistema',
                                      iconoPath: 'assets/icons/5_icon.png',
                                      activo: false,
                                      completado: false,
                                    ),
                                  ];

                            // Navega reemplazando pantalla actual a Lecciones con categorías actualizadas
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeccionesScreen(
                                  categorias: categoriasActualizadas,
                                ),
                              ),
                            );
                          },
                          child: const Text('Continuar'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Siguiente tema',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
