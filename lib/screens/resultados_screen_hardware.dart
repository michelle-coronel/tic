import 'package:flutter/material.dart';
import '../models/question.dart'; // Importa el modelo Question que define las preguntas

// Pantalla que muestra los resultados detallados del quiz de Hardware
class ResultadosScreenHardware extends StatelessWidget {
  // Variables que recibe el widget para mostrar resultados
  final int score; // Puntaje obtenido en el quiz
  final int totalQuestions; // Total de preguntas del quiz
  final String tiempoTotal; // Tiempo total empleado (en formato texto)
  final List<Question> questions; // Lista con todas las preguntas y sus datos

  // Constructor que requiere todos los parámetros para funcionar
  const ResultadosScreenHardware({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.tiempoTotal,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula el porcentaje de aciertos (puntaje dividido entre total preguntas)
    final double porcentaje = (score / totalQuestions) * 100;
    // Obtiene el tema actual para ajustar estilos según modo claro u oscuro
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del Resultado',
        ), // Título en la barra superior
        centerTitle: true, // Centra el título
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // Espaciado alrededor del contenido
        child: ListView(
          children: [
            // Contenedor con resumen de tiempo y puntaje
            Container(
              padding: const EdgeInsets.all(16), // Espacio interno
              margin: const EdgeInsets.only(
                bottom: 24,
              ), // Margen debajo para separar del resto
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E2E2E) // Color fondo para modo oscuro
                    : const Color(
                        0xFFD1ECF1,
                      ), // Color fondo para modo claro (celeste)
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
                border: Border.all(
                  color: isDark
                      ? Colors.grey[700]!
                      : const Color(0xFFBEE5EB), // Color borde según tema
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(
                      (0.05 * 255).round(),
                    ), // Sombra ligera
                    blurRadius: 5,
                    offset: const Offset(0, 2), // Desplazamiento sombra
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto accesible para lectores de pantalla
                  Semantics(
                    container: true,
                    label: 'Has completado el módulo de Hardware.',
                    child: const Text(
                      'Has completado el módulo de Hardware.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 6), // Espaciado vertical
                  // Fila que muestra la etiqueta "Tiempo" y el valor con semántica para accesibilidad
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
                  const SizedBox(height: 4), // Espaciado pequeño
                  // Texto que muestra el puntaje y porcentaje con accesibilidad
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

            // Título para la sección de respuestas detalladas
            Text(
              'Respuestas:',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(), // Línea separadora
            // Genera una lista con cada pregunta y su detalle
            ...List.generate(questions.length, (index) {
              final question = questions[index];

              return Container(
                margin: const EdgeInsets.only(
                  bottom: 16,
                ), // Margen inferior entre preguntas
                padding: const EdgeInsets.all(12), // Padding interno
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(
                          255,
                          44,
                          44,
                          44,
                        ) // Fondo oscuro para modo oscuro
                      : const Color.fromARGB(
                          255,
                          201,
                          247,
                          203,
                        ), // Fondo verde claro para modo claro
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(255, 80, 80, 80)
                        : const Color.fromARGB(255, 186, 240, 188),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(
                        (0.05 * 255).round(),
                      ), // Sombra ligera
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Muestra el número de pregunta y el texto
                    Text(
                      'Pregunta ${index + 1}: ${question.question}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10), // Espaciado vertical
                    // Muestra la respuesta correcta, diferenciando el tipo de pregunta
                    Text(
                      'Respuesta correcta: ${question.type == 'completar' ? question.answerText : question.options?[question.answerIndex ?? 0] ?? 'No disponible'}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),

                    // Si la pregunta tiene explicación, la muestra con formato RichText
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
