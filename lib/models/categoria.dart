/*class Categoria {
  final String nombre;
  final String iconoPath;
  final bool activo;

  Categoria({
    required this.nombre,
    required this.iconoPath,
    required this.activo,
  });
}*/
class Categoria {
  final String nombre;
  final String iconoPath;
  final bool activo;
  final bool completado; // NUEVO

  Categoria({
    required this.nombre,
    required this.iconoPath,
    required this.activo,
    this.completado = false, // valor por defecto
  });
}
