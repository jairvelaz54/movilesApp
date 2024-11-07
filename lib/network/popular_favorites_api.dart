import 'package:dio/dio.dart';
import 'package:pmsn2024b/models/favorite_popular.dart';

class FavoritesApi {
  final Dio dio = Dio();
  final String baseUrl = 'https://api.themoviedb.org/3/list';
  final String bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjE5ODY4MDk1ZjI4YTBlYjVjY2QwYzhiN2JhNTIzMCIsIm5iZiI6MTczMDkyNTA0OS4wMzQxMzEzLCJqdGkiOiI2NzJiZDExMWNhMDYzYzJiYmY3ZmRhZWYiLCJzdWIiOiI2NzJiMGIwZjYwZjViOWVjZGZmMDc2ZjYiLCJzY29wZXMiOlsiYXBpX3JlYWQiLCJhcGlfd3JpdGUiXSwidmVyc2lvbiI6Mn0.UwJ1i5-RQpJT08TVIjvX5R-2qQ0k4HTQLKkSMx7clTc'; // Asegúrate de reemplazarlo con tu token real

  FavoritesApi() {
    dio.options.headers['Authorization'] = 'Bearer $bearerToken';
    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['content-type'] = 'application/json';
  }

  Future<bool> addItemToList(String listId, FavoritePopular item) async {
    final url = '$baseUrl/$listId/add_item';
    try {
      final response = await dio.post(
        url,
        data: item.toJson(),
      );
      return response.statusCode == 201; // Devuelve `true` si se añade exitosamente
    } catch (e) {
      print('Error adding item: $e');
      return false;
    }
  }

  Future<bool> removeItemFromList(String listId, FavoritePopular item) async {
    final url = '$baseUrl/$listId/remove_item';
    try {
      final response = await dio.post(
        url,
        data: item.toJson(),
      );
      return response.statusCode == 200; // Devuelve `true` si se elimina exitosamente
    } catch (e) {
      print('Error removing item: $e');
      return false;
    }
  }
}
