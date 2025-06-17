import 'package:flutter/material.dart';
import 'detalle_categoria_screen.dart'; // Asegúrate de que esta clase use la versión correcta de Categoria
import '../models/categoria.dart'; // Asegúrate de tener el modelo actualizado

class LeccionesScreen extends StatelessWidget {
  const LeccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;

    // Define colores para activo e inactivo según tema claro u oscuro
    final Color colorActivo = theme.brightness == Brightness.dark
        ? Colors.amberAccent
        : Colors.black;
    final Color colorInactivo = Colors.grey;

    final categorias = [
      Categoria(
        nombre: 'Hardware',
        iconoPath: 'assets/icons/1_icon.png',
        activo: true,
      ),
      Categoria(
        nombre: 'Software',
        iconoPath: 'assets/icons/2_icon.png',
        activo: false,
      ),
      Categoria(
        nombre: 'Sistemas Operativos',
        iconoPath: 'assets/icons/3_icon.png',
        activo: false,
      ),
      Categoria(
        nombre: 'Internet',
        iconoPath: 'assets/icons/4_icon.png',
        activo: false,
      ),
      Categoria(
        nombre: 'Actualizaciones de sistema',
        iconoPath: 'assets/icons/5_icon.png',
        activo: false,
      ),
    ];

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
              style: TextStyle(fontSize: 20, color: textColor.withOpacity(0.6)),
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
                    if (categoria.activo) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleCategoriaScreen(categoria: categoria),
                        ),
                      );
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
                        child: Text(
                          categoria.nombre,
                          style: TextStyle(
                            fontSize: 18,
                            color: categoria.activo
                                ? colorActivo
                                : colorInactivo,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
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
