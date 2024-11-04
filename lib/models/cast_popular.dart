class Actor {
  final int id;
  final String name;
  final String? profilePath; // Puede ser nulo si no hay imagen

  Actor({
    required this.id,
    required this.name,
    this.profilePath,
  });
}
