import 'package:flutter/material.dart';
import 'package:pmsn2024b/models/favorite_popular.dart';
import 'package:pmsn2024b/models/popular_moviedao.dart';
import 'package:pmsn2024b/network/popular_api.dart';

import 'package:pmsn2024b/network/popular_favorites_api.dart';
import 'package:pmsn2024b/screens/favorite_movies_screen.dart';
import 'package:pmsn2024b/settings/FavoriteMovies.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  PopularApi? popularApi;
  FavoritesApi favoritesApi = FavoritesApi();
  final String listId = '8496012'; // Reemplaza con tu ID de lista de favoritos

  // Set para almacenar los IDs de las películas favoritas
  List<int> favoriteMovieIds = []; // Aquí almacenaremos las películas favoritas

  @override
  void initState() {
    super.initState();
    popularApi = PopularApi();
    _loadFavorites(); // Cargar los favoritos al inicio
  }

  void _loadFavorites() async {
    List<int> loadedFavorites = await FavoriteMovies.getFavoriteMovies();
    setState(() {
      favoriteMovieIds = loadedFavorites;
    });
  }

  void _toggleFavorite(int movieId) async {
    setState(() {
      if (favoriteMovieIds.contains(movieId)) {
        favoritesApi.removeItemFromList(
          listId,
          FavoritePopular(mediaId: movieId),
        );
        favoriteMovieIds.remove(movieId);
      } else {
        favoriteMovieIds.add(movieId);
        favoritesApi.addItemToList(
          listId,
          FavoritePopular(mediaId: movieId),
        );
      }
    });

    // Guardar los favoritos actualizados
    await FavoriteMovies.saveFavoriteMovies(favoriteMovieIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Navegar a la pantalla de películas favoritas
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteMoviesScreen(favoriteMovieIds: favoriteMovieIds),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: popularApi!.getPopularMovies(),
        builder: (context, AsyncSnapshot<List<PopularMoviedaoDart>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.7, // Este debe coincidir con el aspecto en AspectRatio
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return cardPopular(snapshot.data![index]);
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Hubo un error'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }

  Widget cardPopular(PopularMoviedaoDart popular) {
    bool isFavorite = favoriteMovieIds.contains(popular.id);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: popular),
      child: Hero(
        tag: 'moviePoster_${popular.id}',
        child: AspectRatio(
          aspectRatio: 0.7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${popular.posterPath}',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _toggleFavorite(popular.id);
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      popular.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
