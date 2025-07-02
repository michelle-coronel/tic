import 'package:flutter/material.dart';

class AccesibilidadScreen extends StatelessWidget {
  const AccesibilidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accesibilidad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: const Text(
            'Esta aplicación cumple con los estándares de accesibilidad respectivos según la WCAG 2.2 para mejorar la experiencia de todos los usuarios.\n\n'
            'Permite ajustar el tamaño de letra, el modo oscuro, zoom, lectura en voz y más\n\n'
            'Si se tiene sugerencias se puede enviar desde las opciones correspondientes\n\n'
            'Gracias por usar BitySoft.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
