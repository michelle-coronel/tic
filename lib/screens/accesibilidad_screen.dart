import 'package:flutter/material.dart';

/// Pantalla informativa sobre accesibilidad de la aplicación.
/// Muestra un texto con detalles sobre las características y cumplimiento
/// de accesibilidad según WCAG 2.2, junto con recomendaciones y agradecimientos.
class AccesibilidadScreen extends StatelessWidget {
  const AccesibilidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con el título de la pantalla
      appBar: AppBar(title: const Text('Accesibilidad')),

      // Cuerpo de la pantalla con padding alrededor
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // Permite hacer scroll vertical si el contenido es muy largo
        child: SingleChildScrollView(
          // Texto descriptivo con información sobre accesibilidad
          child: const Text(
            'Esta aplicación cumple con los estándares de accesibilidad respectivos según la WCAG 2.2 para mejorar la experiencia de todos los usuarios.\n\n'
            'Permite ajustar el tamaño de letra, el modo oscuro, zoom, lectura en voz y más.\n\n'
            'Si usted tiene sugerencias las puede enviar desde las opciones correspondientes.\n\n'
            'Gracias por usar BitySoft.',
            style: TextStyle(fontSize: 16), // Tamaño de fuente legible
          ),
        ),
      ),
    );
  }
}
