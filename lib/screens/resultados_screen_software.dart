import 'package:flutter/material.dart';
import '../models/question.dart';

class ResultadosScreenSoftware extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String tiempoTotal;
  final List<Question> questions;

  const ResultadosScreenSoftware({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.tiempoTotal,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final double porcentaje = (score / totalQuestions) * 100;
    final theme = Theme.of(context);
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
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E2E2E)
                    : const Color(0xFFD1ECF1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : const Color(0xFFBEE5EB),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Has completado el módulo de Software.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
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

            Text(
              'Respuestas:',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            // Lista de preguntas y respuestas correctas
            ...List.generate(questions.length, (index) {
              final question = questions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 44, 44, 44)
                      : const Color.fromARGB(255, 255, 244, 208),
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
                    Text(
                      'Pregunta ${index + 1}: ${question.question}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Mostrar respuesta correcta según tipo
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

                    // Mostrar explicación si existe
                    if (question.explanation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          'Explicación: ${question.explanation}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onPrimaryContainer,
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
