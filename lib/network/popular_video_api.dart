import 'package:dio/dio.dart';
import 'package:pmsn2024b/models/video_popular.dart';

class PopularVideoApi {
  final dio = Dio();
// Método para obtener los videos de una película específica
  Future<VideoPopular> getMovieVideos(int movieId) async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX',
    );

    // Pasamos el mapa completo a VideoPopular desde el método fromMap
    return VideoPopular.fromMap(response.data);
  }
}
