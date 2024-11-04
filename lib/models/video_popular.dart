class VideoPopular {
  final String name;
  final String key;
  final String site;

  // Constructor
  VideoPopular({
    required this.name,
    required this.key,
    required this.site,
  });

  // Método para crear una instancia de VideoPopular a partir de un mapa JSON
  factory VideoPopular.fromMap(Map<String, dynamic> map) {
    // Obtenemos la lista de videos
    final List<dynamic> results = map['results'];

    // Filtramos solo los videos que sean de tipo "Trailer"
    final Map<String, dynamic>? trailer = results.firstWhere(
      (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
      orElse: () => null,
    );

    // Si no hay ningún trailer, lanzamos un error o retornamos un valor nulo
    if (trailer == null) {
      throw Exception('No se encontró ningún trailer');
    }

    // Creamos la instancia de VideoPopular con los datos del trailer
    return VideoPopular(
      name: trailer['name'],
      key: trailer['key'],
      site: trailer['site'],
    );
  }
}
