import 'package:flutter/material.dart';

// Pantalla Stateful para enviar soporte o reportar problemas
class SoporteScreen extends StatefulWidget {
  const SoporteScreen({super.key});

  @override
  State<SoporteScreen> createState() => _SoporteScreenState();
}

class _SoporteScreenState extends State<SoporteScreen> {
  // Controladores para manejar el texto ingresado en cada campo
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController mensajeController = TextEditingController();

  // Key para manejar el estado y validación del formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para almacenar las opciones seleccionadas en los dropdowns
  String? categoriaSeleccionada;
  String? asuntoSeleccionado;

  // Listas con las opciones disponibles para los dropdowns
  final List<String> categorias = ['Accesibilidad', 'Errores técnicos', 'Otro'];
  final List<String> asuntos = ['Bug', 'Sugerencia', 'Consulta'];

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema actual es oscuro, para adaptar colores
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Soporte')), // Barra superior con título
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Espaciado general de la pantalla
        child: Form(
          key:
              _formKey, // Asigna la key para control y validación del formulario
          child: Column(
            children: [
              const SizedBox(height: 10), // Espacio superior pequeño
              // Texto introductorio centrado y en negrita
              const Text(
                'Por favor, no dudes en reportar cualquier problema que notes\n'
                'para que podamos ayudarte y/o ayudar a los demás',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24), // Espacio entre texto y formulario
              // Card que agrupa los campos "Nombre" y "Correo"
              _buildCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Etiqueta para el campo nombre
                    const Text(
                      'Nombre de usuario',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Campo de texto para ingresar el nombre
                    TextFormField(
                      controller: nombreController, // Controlador del campo
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _inputDecoration(isDark).copyWith(
                        hintText:
                            'Escriba su nombre de usuario', // Texto indicativo
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      // Validador que verifica que el campo no esté vacío
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre no puede estar vacío';
                        }
                        return null; // Campo válido
                      },
                    ),
                    const SizedBox(height: 16),

                    // Etiqueta para el campo correo electrónico
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Campo de texto para correo electrónico
                    TextFormField(
                      controller: correoController,
                      keyboardType: TextInputType
                          .emailAddress, // Tipo teclado específico para email
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _inputDecoration(isDark).copyWith(
                        hintText: 'Escriba su correo electrónico',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      // Validador para correo válido y no vacío
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El correo no puede estar vacío';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Card que agrupa los dropdowns y el mensaje
              _buildCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Etiqueta categoría
                    const Text(
                      'Categoría',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown para seleccionar la categoría
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(isDark),
                      value:
                          categoriaSeleccionada, // Valor seleccionado actualmente
                      hint: const Text('Seleccione una categoría'),
                      dropdownColor: isDark
                          ? Colors.grey.shade800
                          : Colors.white,
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
                          categoriaSeleccionada =
                              value; // Actualiza valor seleccionado
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione una categoría' : null,
                    ),
                    const SizedBox(height: 16),

                    // Etiqueta asunto
                    const Text(
                      'Asunto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Widget Semantics para accesibilidad del dropdown "Asunto"
                    Semantics(
                      label:
                          'Selector de asunto', // Etiqueta accesible para lectores de pantalla
                      hint:
                          'Despliega una lista de asuntos disponibles', // Indicaciones adicionales
                      child: DropdownButtonFormField<String>(
                        decoration: _inputDecoration(isDark),
                        value: asuntoSeleccionado,
                        hint: const Text('Seleccione un asunto'),
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
                        validator: (value) =>
                            value == null ? 'Seleccione un asunto' : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Etiqueta mensaje
                    const Text(
                      'Mensaje',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Campo multilinea para el mensaje
                    TextFormField(
                      controller: mensajeController,
                      maxLines: 5,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _inputDecoration(isDark).copyWith(
                        hintText: 'Escriba su mensaje o comentario',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      // Validador para evitar campo vacío
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El mensaje no puede estar vacío';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botón para enviar el formulario
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Valida el formulario antes de enviar
                    if (_formKey.currentState!.validate()) {
                      // Muestra un diálogo accesible de confirmación
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Semantics(
                              header: true,
                              child: const Text('Confirmación'),
                            ),
                            content: Semantics(
                              liveRegion: true,
                              child: const Text('¡Soporte enviado con éxito!'),
                            ),
                            actions: [
                              FocusScope(
                                autofocus: true,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Limpia campos y resetea valores
                                    setState(() {
                                      nombreController.clear();
                                      correoController.clear();
                                      categoriaSeleccionada = null;
                                      asuntoSeleccionado = null;
                                      mensajeController.clear();
                                    });
                                  },
                                  child: const Text('OK'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
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

  // Método que retorna la decoración común para inputs y dropdowns
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

  // Método que genera un contenedor tipo card con estilos adaptados
  Widget _buildCard(Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16), // Espaciado interno
      margin: const EdgeInsets.only(bottom: 16), // Margen inferior
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        border: Border.all(color: Colors.grey.shade400), // Borde gris claro
      ),
      child: child, // Contenido pasado como parámetro
    );
  }
}
