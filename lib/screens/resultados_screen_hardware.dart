import 'package:flutter/material.dart';
import '../models/question.dart'; // Modelo que define las preguntas

// Pantalla que muestra los resultados detallados del quiz de Hardware
class ResultadosScreenHardware extends StatelessWidget {
  final int score; // Puntaje obtenido en el quiz
  final int totalQuestions; // Total de preguntas realizadas
  final String tiempoTotal; // Tiempo total empleado en el quiz (texto)
  final List<Question> questions; // Lista con todas las preguntas y datos

  const ResultadosScreenHardware({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.tiempoTotal,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula el porcentaje obtenido en base al puntaje y total preguntas
    final double porcentaje = (score / totalQuestions) * 100;
    final theme = Theme.of(context); // Tema actual (claro u oscuro)
    final isDark =
        theme.brightness == Brightness.dark; // Si está en modo oscuro

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Resultado'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Contenedor con resumen del tiempo y puntaje
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E2E2E) // Fondo oscuro en modo oscuro
                    : const Color(
                        0xFFD1ECF1,
                      ), // Fondo celeste claro en modo claro
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : const Color(0xFFBEE5EB),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto indicando que el módulo de Hardware fue completado
                  Text(
                    'Has completado el módulo de Hardware.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Muestra tiempo total y puntaje obtenido
                  Text(
                    'Tiempo: $tiempoTotal\nPuntaje: $score / $totalQuestions (${porcentaje.toStringAsFixed(1)}%)',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Título para sección de respuestas detalladas
            Text(
              'Respuestas:',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            // Lista con cada pregunta y sus detalles
            ...List.generate(questions.length, (index) {
              final question = questions[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 44, 44, 44) // Fondo oscuro
                      : const Color.fromARGB(255, 201, 247, 203), // Verde claro
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(255, 80, 80, 80)
                        : const Color.fromARGB(255, 186, 240, 188),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pregunta con índice y texto
                    Text(
                      'Pregunta ${index + 1}: ${question.question}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Respuesta correcta, adaptando el texto según tipo de pregunta
                    Text(
                      'Respuesta correcta: ${question.type == 'completar' ? question.answerText : question.options?[question.answerIndex ?? 0] ?? 'No disponible'}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),

                    // Si hay explicación, mostrarla debajo con formato destacado
                    if (question.explanation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Explicación: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: question.explanation),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
