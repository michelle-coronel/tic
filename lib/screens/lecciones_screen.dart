import 'package:flutter/material.dart';
import '../models/categoria.dart';
import 'detalle_categoria_screen.dart';
import 'detalle_software_screen.dart';

class LeccionesScreen extends StatelessWidget {
  final List<Categoria> categorias;

  const LeccionesScreen({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;

    final Color colorActivo = theme.brightness == Brightness.dark
        ? Colors.amberAccent
        : Colors.black;
    final Color colorInactivo = Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Temas de Informática',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 20, 15),
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Continúa los patrones',
              style: TextStyle(
                fontSize: 20,
                color: textColor.withAlpha((0.6 * 255).round()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return ListTile(
                  onTap: () {
                    if (categoria.completado) {
                      // Mostrar mensaje nivel completado
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¡Felicidades!'),
                          content: Text(
                            'El nivel "${categoria.nombre}" ya está completado.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    } else if (categoria.activo) {
                      if (categoria.nombre == 'Software') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleSoftwareScreen(categoria: categoria),
                          ),
                        );
                      } else if (categoria.nombre == 'Sistemas Operativos') {
                        // Mostrar mensaje personalizado para Sistemas Operativos
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('¡Muy amable!'),
                            content: const Text('Gracias por usar la app'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleCategoriaScreen(categoria: categoria),
                          ),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Atención'),
                          content: const Text(
                            'Completa el nivel anterior para habilitar este nivel.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  title: Row(
                    children: [
                      Image.asset(
                        categoria.iconoPath,
                        width: 85,
                        height: 85,
                        color: categoria.activo ? colorActivo : colorInactivo,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoria.nombre,
                              style: TextStyle(
                                fontSize: 18,
                                color: categoria.activo
                                    ? colorActivo
                                    : colorInactivo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (categoria.completado)
                              const Text(
                                '¡Completado!',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
