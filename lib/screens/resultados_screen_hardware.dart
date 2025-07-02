import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- Importa provider
import '../models/question.dart';
import 'settings_provider.dart'; // Ajusta ruta según ubicación

class ResultadosScreenHardware extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String tiempoTotal;
  final List<Question> questions;

  const ResultadosScreenHardware({
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

    // Obtener tamaño de fuente dinámico del provider
    final settings = Provider.of<SettingsProvider>(context);
    final fontSize = settings.fontSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Resultado'),
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
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    container: true,
                    label: 'Has completado el módulo de Hardware.',
                    child: const Text(
                      'Has completado el módulo de Hardware.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiempo: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Semantics(
                        container: true,
                        label: 'Tiempo total empleado: $tiempoTotal',
                        child: Text(
                          tiempoTotal,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    container: true,
                    label:
                        'Puntaje obtenido: $score de $totalQuestions. Porcentaje: ${porcentaje.toStringAsFixed(1)} por ciento',
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Puntaje: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text:
                                '$score / $totalQuestions (${porcentaje.toStringAsFixed(1)}%)',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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
            ...List.generate(questions.length, (index) {
              final question = questions[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 44, 44, 44)
                      : const Color.fromARGB(255, 201, 247, 203),
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
                    Text(
                      'Pregunta ${index + 1}: ${question.question}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Respuesta correcta: ${question.type == 'completar' ? question.answerText : question.options?[question.answerIndex ?? 0] ?? 'No disponible'}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),

                    // Aquí la única modificación: explicación con tamaño dinámico
                    if (question.explanation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: fontSize, // <- tamaño dinámico aquí
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
