// Clase que representa una categoría (por ejemplo: Hardware, Software, etc.)
class Categoria {
  // Nombre de la categoría
  final String nombre;

  // Ruta del ícono asociado a la categoría (por ejemplo: assets/icons/hardware.png)
  final String iconoPath;

  // Indica si la categoría está activa (habilitada para ser seleccionada o no)
  final bool activo;

  // NUEVO: Indica si la categoría ha sido completada (por ejemplo, si ya se terminó el quiz de esa categoría)
  final bool completado;

  // Constructor de la clase Categoria
  Categoria({
    required this.nombre, // Requiere un nombre al crear la categoría
    required this.iconoPath, // Requiere una ruta de ícono
    required this.activo, // Requiere un valor para saber si está activa
    this.completado = false, // Por defecto, la categoría no está completada
  });
}
