import 'package:http/http.dart' as http;
import 'package:pmsn2024b/models/cast_popular.dart';
import 'dart:convert';
import 'package:pmsn2024b/models/video_popular.dart';

class PopularCastApi {
  final String apiKey = '5019e68de7bc112f4e4337a500b96c56';


  Future<List<Actor>> getMovieCast(int movieId) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=es-MX&append_to_response=credits'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['credits']['cast'] as List).map((actor) {
        return Actor(
          id: actor['id'],
          name: actor['name'],
          profilePath: actor['profile_path'],
        );
      }).toList();
    } else {
      throw Exception('Error al cargar el reparto.');
    }
  }
}
