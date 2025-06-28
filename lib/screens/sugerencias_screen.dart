import 'package:flutter/material.dart';

// Pantalla Stateful que permite al usuario enviar sugerencias
class SugerenciasScreen extends StatefulWidget {
  const SugerenciasScreen({super.key});

  @override
  State<SugerenciasScreen> createState() => _SugerenciasScreenState();
}

class _SugerenciasScreenState extends State<SugerenciasScreen> {
  // Variables para guardar la opción seleccionada en los dropdowns
  String? categoriaSeleccionada;
  String? asuntoSeleccionado;

  // Controlador para el campo de texto donde el usuario escribe su mensaje
  final TextEditingController mensajeController = TextEditingController();

  // Llave para controlar y validar el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Listas de opciones para los dropdowns de categoría y asunto
  final List<String> categorias = ['Accesibilidad', 'Contenido', 'Otro'];
  final List<String> asuntos = ['Error', 'Mejora', 'Consulta'];

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema actual es oscuro para adaptar los colores
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Sugerencias')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Asocia el formulario con la llave para validación
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Texto introductorio motivando al usuario a escribir sugerencias
              const Text(
                'Escríbenos si tienes algún comentario o sugerencia para poder mejorar BitySoft',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Contenedor principal del formulario con fondo y borde adaptados
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
                    // Etiqueta para el dropdown de categoría
                    const Text(
                      'Categoría',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Semantics para mejorar la accesibilidad, describiendo el dropdown
                    Semantics(
                      label: 'Selector de categoría',
                      hint: 'Despliega una lista de categorías disponibles',
                      child: DropdownButtonFormField<String>(
                        decoration: _inputDecoration(isDark),
                        value: categoriaSeleccionada,
                        hint: const Text('Seleccione una categoría'),
                        dropdownColor: isDark
                            ? Colors.grey.shade800
                            : Colors.white,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        // Mapea cada categoría a un DropdownMenuItem
                        items: categorias
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            categoriaSeleccionada =
                                value; // Actualiza selección
                          });
                        },
                        // Validador que obliga a seleccionar una categoría
                        validator: (value) =>
                            value == null ? 'Seleccione una categoría' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Etiqueta para el dropdown de asunto
                    const Text(
                      'Asunto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Semantics para accesibilidad del dropdown asunto
                    Semantics(
                      label: 'Selector de asunto',
                      hint: 'Despliega una lista de asuntos disponibles',
                      child: DropdownButtonFormField<String>(
                        decoration: _inputDecoration(isDark),
                        value: asuntoSeleccionado,
                        hint: const Text('Asunto'),
                        dropdownColor: isDark
                            ? Colors.grey.shade800
                            : Colors.white,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        items: asuntos
                            .map(
                              (asu) => DropdownMenuItem(
                                value: asu,
                                child: Text(asu),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            asuntoSeleccionado = value; // Actualiza selección
                          });
                        },
                        // Validador para obligar selección de asunto
                        validator: (value) =>
                            value == null ? 'Seleccione un asunto' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Etiqueta para el campo de texto mensaje
                    const Text(
                      'Mensaje',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Semantics para accesibilidad del campo de texto mensaje
                    Semantics(
                      label: 'Campo para escribir mensaje',
                      hint:
                          'Escribe aquí tu sugerencia, comentario o mensaje detallado',
                      child: TextFormField(
                        controller: mensajeController,
                        maxLines: 5, // Múltiples líneas para texto largo
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(isDark).copyWith(
                          hintText: 'Escribe lo que deseas transmitirnos',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                          ),
                        ),
                        // Validador para que el mensaje no esté vacío
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El mensaje no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botón para enviar el formulario
              SizedBox(
                width: double.infinity, // Ancho completo del botón
                child: ElevatedButton(
                  onPressed: () {
                    // Valida el formulario completo
                    if (_formKey.currentState!.validate()) {
                      // Si es válido, muestra un snackbar con mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Mensaje enviado!')),
                      );

                      // Limpia las selecciones y el mensaje
                      setState(() {
                        categoriaSeleccionada = null;
                        asuntoSeleccionado = null;
                        mensajeController.clear();
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
      ),
    );
  }

  // Método auxiliar para la decoración uniforme de los campos de texto y dropdown
  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true, // Fondo relleno para el input
      fillColor: isDark ? Colors.grey.shade700 : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        borderSide: BorderSide(color: Colors.grey.shade300), // Color del borde
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
