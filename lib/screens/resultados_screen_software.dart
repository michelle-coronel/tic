import 'package:flutter/material.dart';
import '../models/question.dart'; // Modelo que define las preguntas y sus propiedades

// Pantalla que muestra los resultados detallados del quiz de Software
class ResultadosScreenSoftware extends StatelessWidget {
  final int score; // Puntaje obtenido en el quiz
  final int totalQuestions; // Total de preguntas en el quiz
  final String tiempoTotal; // Tiempo total que tomó el quiz (formato String)
  final List<Question> questions; // Lista con las preguntas respondidas

  const ResultadosScreenSoftware({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.tiempoTotal,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula el porcentaje de aciertos
    final double porcentaje = (score / totalQuestions) * 100;
    final theme = Theme.of(context); // Tema actual (claro/oscuro)
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Software'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Contenedor resumen con tiempo y puntaje
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E2E2E) // Fondo oscuro
                    : const Color(0xFFD1ECF1), // Fondo claro (celeste suave)
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
                  // Texto indicando módulo completado
                  Text(
                    'Has completado el módulo de Software.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Texto con tiempo y puntaje
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

            // Título sección respuestas
            Text(
              'Respuestas:',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            // Genera lista de contenedores para cada pregunta con su respuesta correcta
            ...List.generate(questions.length, (index) {
              final question = questions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 44, 44, 44) // Fondo oscuro
                      : const Color.fromARGB(
                          255,
                          255,
                          244,
                          208,
                        ), // Fondo amarillo suave
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(255, 80, 80, 80)
                        : const Color.fromARGB(255, 255, 234, 164),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Muestra el número y texto de la pregunta
                    Text(
                      'Pregunta ${index + 1}: ${question.question}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Muestra la respuesta correcta según el tipo de pregunta
                    if (question.type == 'completar') ...[
                      Text(
                        'Respuesta correcta: ${question.answerText ?? 'No disponible'}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ] else if (question.type == 'opcion_multiple' ||
                        question.type == 'verdadero_falso' ||
                        question.type == 'ordenar') ...[
                      Text(
                        'Respuesta correcta: ${question.options?[question.answerIndex ?? 0] ?? 'No disponible'}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ] else if (question.type == 'arrastrar') ...[
                      Text(
                        'Respuesta correcta:',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Lista con las correspondencias correctas en preguntas tipo arrastrar
                      ...question.items!.map(
                        (item) => Text(
                          '${item.text} → ${item.categoriaCorrecta}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],

                    // Muestra explicación si está disponible
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
