import 'package:flutter/material.dart';
import '../models/question.dart'; // Importa el modelo Question que define la estructura de las preguntas y sus propiedades

// Widget Stateless que muestra los resultados detallados del quiz de Software
class ResultadosScreenSoftware extends StatelessWidget {
  // Variables que recibe el widget para mostrar los resultados
  final int score; // Puntaje obtenido por el usuario
  final int totalQuestions; // Total de preguntas del quiz
  final String
  tiempoTotal; // Tiempo total que tomó el usuario en completar el quiz (en formato String)
  final List<Question>
  questions; // Lista con las preguntas respondidas, para mostrar detalle

  // Constructor que recibe los parámetros requeridos
  const ResultadosScreenSoftware({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.tiempoTotal,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula el porcentaje de aciertos en base al puntaje y total de preguntas
    final double porcentaje = (score / totalQuestions) * 100;

    // Obtiene el tema actual (modo claro u oscuro)
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resultados de Software',
        ), // Título en la barra superior
        centerTitle: true, // Centrar el título
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ), // Espaciado alrededor del contenido principal
        child: ListView(
          children: [
            // Contenedor que muestra el resumen con tiempo y puntaje
            Container(
              padding: const EdgeInsets.all(16), // Padding interno
              margin: const EdgeInsets.only(
                bottom: 24,
              ), // Margen inferior para separar del resto
              decoration: BoxDecoration(
                // Cambia el color de fondo según el tema (oscuro o claro)
                color: isDark
                    ? const Color(0xFF2E2E2E) // Gris oscuro para modo oscuro
                    : const Color(0xFFD1ECF1), // Celeste suave para modo claro
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
                border: Border.all(
                  color: isDark
                      ? Colors.grey[700]!
                      : const Color(0xFFBEE5EB), // Borde diferente según tema
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
                  // Texto con descripción accesible para lectores de pantalla
                  Semantics(
                    container: true,
                    label: 'Has completado el módulo de Software.',
                    child: const Text(
                      'Has completado el módulo de Software.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 6), // Espaciado vertical
                  // Fila que muestra el tiempo total
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
                      // Texto con semántica para accesibilidad
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
                  const SizedBox(height: 4), // Pequeño espaciado
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

            // Título para la sección que mostrará las respuestas detalladas
            Text(
              'Respuestas:',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(), // Línea separadora
            // Genera una lista de widgets para cada pregunta con su respuesta correcta
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
                          255,
                          244,
                          208,
                        ), // Fondo amarillo suave para modo claro
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(255, 80, 80, 80)
                        : const Color.fromARGB(255, 255, 234, 164),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Muestra el número de la pregunta y el texto de la misma
                    Text(
                      'Pregunta ${index + 1}: ${question.question}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ), // Espaciado entre pregunta y respuesta
                    // Muestra la respuesta correcta dependiendo del tipo de pregunta
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
                      const SizedBox(height: 4), // Pequeño espacio
                      // Muestra la lista con las correspondencias correctas en preguntas tipo arrastrar
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

                    // Muestra la explicación de la pregunta si existe
                    if (question.explanation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          'Explicación: ${question.explanation}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
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
