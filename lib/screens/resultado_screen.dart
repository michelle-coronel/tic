import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/question.dart';
import 'resultados_screen_hardware.dart';
import 'lecciones_screen.dart';
import 'resultados_screen_software.dart';

class ResultadoScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String tiempoTotal;
  final List<Question> questions;
  final String tema;
  final String appBarTitle;

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
    final double porcentaje = (score / totalQuestions) * 100;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E2E2E)
                    : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Text(
                    'Has completado el tema:',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
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

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '¿Qué acción desea realizar?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Botón: Ver resultados
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () {
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

            // Botón: Siguiente tema con AlertDialog
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
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Cierra el diálogo

                            final categoriasActualizadas = tema == 'Hardware'
                                ? [
                                    Categoria(
                                      nombre: 'Hardware',
                                      iconoPath: 'assets/icons/1_icon.png',
                                      activo: true,
                                      completado: true, // <-- Aquí el cambio
                                    ),
                                    Categoria(
                                      nombre: 'Software',
                                      iconoPath: 'assets/icons/2_icon.png',
                                      activo: true,
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
                                    Categoria(
                                      nombre: 'Hardware',
                                      iconoPath: 'assets/icons/1_icon.png',
                                      activo: true,
                                      completado:
                                          true, // si quieres que siga marcado
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
