import 'package:flutter/material.dart';
import '../models/categoria.dart'; // Importa el modelo Categoria
import 'detalle_categoria_screen.dart'; // Pantalla de detalle para categorías generales
import 'detalle_software_screen.dart'; // Pantalla de detalle específica para Software

// Pantalla que muestra la lista de lecciones o temas disponibles
class LeccionesScreen extends StatelessWidget {
  final List<Categoria>
  categorias; // Lista de categorías recibida como parámetro

  const LeccionesScreen({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtiene el tema actual
    final textColor =
        theme.textTheme.bodyLarge?.color ??
        Colors.black; // Color de texto adaptativo
    final backgroundColor =
        theme.scaffoldBackgroundColor; // Color de fondo adaptativo

    // Colores para estado activo/inactivo según tema claro u oscuro
    final Color colorActivo = theme.brightness == Brightness.dark
        ? Colors.amberAccent
        : Colors.black;
    final Color colorInactivo = Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // No muestra botón de regresar automáticamente
        backgroundColor: backgroundColor,
        elevation: 0, // Sin sombra
        title: Text(
          'Temas de Informática', // Título de la appbar
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        iconTheme: IconThemeData(
          color: textColor,
        ), // Color de íconos adaptativo
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Categorías" con padding
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

          // Subtítulo o mensaje debajo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Continúa los patrones',
              style: TextStyle(
                fontSize: 20,
                color: textColor.withAlpha((0.6 * 255).round()), // Opacidad 60%
              ),
            ),
          ),

          const SizedBox(height: 16), // Espacio vertical
          // Lista expandida que ocupa todo el espacio restante
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length, // Número de categorías a mostrar
              itemBuilder: (context, index) {
                final categoria = categorias[index];

                final bool esActivo =
                    categoria.activo; // Si está habilitada para el usuario
                final bool estaCompletado =
                    categoria.completado; // Si ya completó esta categoría

                // Color para icono y texto: activo o inactivo
                Color iconColor = esActivo ? colorActivo : colorInactivo;
                // Color del borde: verde si completado, si no, color normal según activo/inactivo
                Color bordeColor = estaCompletado ? Colors.green : iconColor;

                // Fondo dinámico según tema (claro u oscuro)
                Color fondoColor = theme.brightness == Brightness.dark
                    ? Colors.grey[800]! // Gris oscuro en modo oscuro
                    : const Color.fromARGB(
                        255,
                        251,
                        248,
                        248,
                      ); // Blanco grisáceo claro

                return ListTile(
                  onTap: () {
                    // Si ya completó esta categoría, muestra un mensaje felicitando
                    if (categoria.completado) {
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
                    }
                    // Si está activo, se permite entrar a detalle según categoría
                    else if (categoria.activo) {
                      if (categoria.nombre == 'Software') {
                        // Navega a pantalla detalle Software
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleSoftwareScreen(categoria: categoria),
                          ),
                        );
                      } else if (categoria.nombre == 'Sistemas Operativos') {
                        // Para esta categoría muestra mensaje simple
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
                        // Para otras categorías muestra su detalle general
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleCategoriaScreen(categoria: categoria),
                          ),
                        );
                      }
                    }
                    // Si no está activo ni completado, muestra alerta para avanzar primero
                    else {
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

                  // Vista de cada elemento de la lista (ListTile)
                  title: Row(
                    children: [
                      // Contenedor que muestra el ícono con fondo y borde
                      Container(
                        width: 85,
                        height: 85,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: fondoColor,
                          border: Border.all(color: bordeColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset(
                          categoria.iconoPath,
                          color: iconColor,
                        ),
                      ),

                      const SizedBox(width: 14), // Espacio horizontal
                      // Columna con nombre y estado de completado
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoria.nombre,
                              style: TextStyle(
                                fontSize: 18,
                                color: iconColor,
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
