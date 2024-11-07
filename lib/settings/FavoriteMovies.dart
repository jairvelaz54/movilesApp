
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMovies {
  // Método para obtener los favoritos guardados
  static Future<List<int>> getFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorite_movies');
    return favoriteList?.map((e) => int.parse(e)).toList() ?? [];
  }

  // Método para guardar los favoritos
  static Future<void> saveFavoriteMovies(List<int> favoriteMovies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = favoriteMovies.map((e) => e.toString()).toList();
    prefs.setStringList('favorite_movies', favoriteList);
  }
}
