import 'package:flutter/material.dart';
import 'package:pmsn2024b/models/popular_moviedao.dart';
import 'package:pmsn2024b/network/popular_api.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  final List<int> favoriteMovieIds;

  const FavoriteMoviesScreen({super.key, required this.favoriteMovieIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Películas Favoritas'),
      ),
      body: FutureBuilder(
        future: PopularApi().getPopularMovies(),  // O tu método para obtener las películas
        builder: (context, AsyncSnapshot<List<PopularMoviedaoDart>> snapshot) {
          if (snapshot.hasData) {
            // Filtrar las películas favoritas
            List<PopularMoviedaoDart> favoriteMovies = snapshot.data!
                .where((movie) => favoriteMovieIds.contains(movie.id))
                .toList();

            return GridView.builder(
              itemCount: favoriteMovies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return cardPopular(context, favoriteMovies[index]);
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

  // Pasar 'context' a cardPopular
  Widget cardPopular(BuildContext context, PopularMoviedaoDart popular) {
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
