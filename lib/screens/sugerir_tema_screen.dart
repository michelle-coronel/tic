import 'package:flutter/material.dart';

// Pantalla para que el usuario sugiera un nuevo tema para la aplicación
class SugerirTemaScreen extends StatefulWidget {
  const SugerirTemaScreen({super.key});

  @override
  State<SugerirTemaScreen> createState() => _SugerirTemaScreenState();
}

class _SugerirTemaScreenState extends State<SugerirTemaScreen> {
  // Controlador para el campo de texto donde el usuario escribe el título del tema
  final TextEditingController tituloController = TextEditingController();

  // Variable para almacenar la categoría seleccionada del dropdown
  String? categoriaSeleccionada;

  // Lista de categorías disponibles para la sugerencia
  final List<String> categorias = [
    'Programación',
    'Desarrollo web',
    'Redes',
    'Seguridad',
    'Bases de datos',
  ];

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema actual es oscuro para adaptar colores
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerir tema'),
      ), // Barra superior con título
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Espaciado general
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              '¿Te gustaría que incluyéramos algún tema en nuestra aplicación? ¡No esperes más y cuéntanos cuál es!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ), // Texto introductorio motivando al usuario a sugerir un tema
            const SizedBox(height: 24),

            // Contenedor con borde y fondo adaptado a modo claro u oscuro
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiqueta para el campo del título
                  const Text(
                    'Título del tema',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Campo de texto para ingresar el título del tema sugerido
                  TextFormField(
                    controller: tituloController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: _inputDecoration(isDark).copyWith(
                      hintText: 'Ej. Almacenamiento de archivos',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Etiqueta para el dropdown de categoría
                  const Text(
                    'Categoría',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown para seleccionar la categoría del tema
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration(isDark),
                    value: categoriaSeleccionada,
                    hint: const Text('Seleccione una categoría'),
                    dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    items: categorias
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        categoriaSeleccionada = value; // Actualiza la selección
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botón para enviar la sugerencia
            SizedBox(
              width: double.infinity, // Ancho completo
              child: ElevatedButton(
                onPressed: () {
                  // Valida que ambos campos estén completos
                  if (tituloController.text.isEmpty ||
                      categoriaSeleccionada == null) {
                    // Muestra mensaje de error si falta algún dato
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor completa todos los campos'),
                      ),
                    );
                  } else {
                    // Aquí podrías agregar código para enviar o guardar la sugerencia
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Tema sugerido con éxito!'),
                      ),
                    );
                    // Limpia el campo y resetea el dropdown después de enviar
                    tituloController.clear();
                    setState(() {
                      categoriaSeleccionada = null;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Fondo amarillo
                  foregroundColor: Colors.black, // Texto negro
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Enviar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para decoración uniforme de inputs, adaptando para modo oscuro
  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? Colors.grey.shade700 : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
