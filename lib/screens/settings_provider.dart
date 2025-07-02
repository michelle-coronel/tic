import 'package:flutter/material.dart';

/// `SettingsProvider` es una clase que extiende `ChangeNotifier`,
/// permitiendo gestionar el tamaño de letra de forma centralizada
/// y notificar a los widgets que lo usan cuando este cambia.
class SettingsProvider extends ChangeNotifier {
  // Valor privado que almacena el tamaño actual de la fuente.
  double _fontSize = 16.0;

  /// Getter para obtener el tamaño de fuente actual
  double get fontSize => _fontSize;

  /// Método para actualizar el tamaño de la fuente
  /// y notificar a todos los widgets que escuchan este cambio.
  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners(); // Notifica a todos los widgets que usan esta configuración
  }
}
