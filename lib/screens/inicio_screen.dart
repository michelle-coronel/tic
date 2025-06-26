import 'package:flutter/material.dart';

// Pantalla de inicio de la app, sin estado (StatelessWidget)
class InicioScreen extends StatelessWidget {
  // Callback que se ejecuta cuando se presiona el botón INICIAR
  final VoidCallback onIniciarPressed;

  // Constructor que recibe el callback obligatorio
  const InicioScreen({super.key, required this.onIniciarPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos el color de fondo definido en el tema para el scaffold
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // Cuerpo centrado vertical y horizontalmente
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ), // Margen horizontal
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centrar contenido verticalmente
            children: [
              // Imagen que se muestra arriba, con ancho fijo
              Image.asset('assets/images/inicio1.png', width: 180),

              const SizedBox(
                height: 30,
              ), // Espacio vertical entre imagen y botón
              // Botón principal para iniciar, usa el callback recibido
              ElevatedButton(
                onPressed: onIniciarPressed, // Acción al presionar el botón
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Fondo amarillo
                  foregroundColor: Colors.black, // Texto negro
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70,
                    vertical: 20,
                  ), // Espaciado interno del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // Bordes redondeados
                  ),
                  elevation: 20, // Sombra del botón para efecto de profundidad
                  // ignore: deprecated_member_use
                  shadowColor: Colors.amber.withOpacity(
                    0.4,
                  ), // Color sombra amarilla translúcida
                ),
                child: const Text(
                  'INICIAR',
                  style: TextStyle(fontSize: 18), // Tamaño del texto del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
