class VentaServicio {
  final int id;
  final String descripcion;
  final DateTime fecha;
  final String estatus; // "por cumplir", "cancelado", "completado"

  VentaServicio({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.estatus,
  });

  // Método para convertir un registro de SQLite a un objeto de la clase
  factory VentaServicio.fromMap(Map<String, dynamic> json) => VentaServicio(
        id: json['id'],
        descripcion: json['descripcion'],
        fecha: DateTime.parse(json['fecha']),
        estatus: json['estatus'],
      );
}
