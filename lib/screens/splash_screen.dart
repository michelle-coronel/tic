import 'package:flutter/material.dart';
import 'dart:async'; // Importa Timer para manejar el tiempo

// Widget SplashScreen que mantiene estado para manejar el temporizador
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Al iniciar el estado, configura un Timer de 3 segundos
    Timer(const Duration(seconds: 3), () {
      // Después de 3 segundos, navega reemplazando la pantalla actual por '/home'
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBB318), // Fondo amarillo personalizado
      body: Center(
        // Centra el contenido: una imagen cargada desde assets
        child: Image.asset('assets/images/logo.jpg', width: 200),
      ),
    );
  }
}
