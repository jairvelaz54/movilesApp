import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pmsn2024b/models/cast_popular.dart';
import 'package:pmsn2024b/models/popular_moviedao.dart';
import 'package:pmsn2024b/network/popular_cast_api.dart';
import 'package:pmsn2024b/network/popular_video_api.dart';
import 'package:pmsn2024b/provider/test_provider.dart';
import 'package:provider/provider.dart';
import 'package:pmsn2024b/models/video_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPopularScreen extends StatefulWidget {
  const DetailPopularScreen({super.key});

  @override
  State<DetailPopularScreen> createState() => _DetailPopularScreenState();
}

class _DetailPopularScreenState extends State<DetailPopularScreen> {
  late Future<VideoPopular> _trailerFuture;
  late Future<List<Actor>> _castFuture;
  YoutubePlayerController? _youtubeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final popular =
        ModalRoute.of(context)!.settings.arguments as PopularMoviedaoDart;
    _trailerFuture = _fetchTrailer(popular.id);
    _castFuture = _fetchCast(popular.id);
  }

  Future<VideoPopular> _fetchTrailer(int movieId) async {
    final api = PopularVideoApi();
    return await api.getMovieVideos(movieId);
  }

  Future<List<Actor>> _fetchCast(int movieId) async {
    final api = PopularCastApi();
    return await api.getMovieCast(movieId);
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  // Dentro del widget `build` en la columna de detalles de la película
  @override
  Widget build(BuildContext context) {
    final popular =
        ModalRoute.of(context)!.settings.arguments as PopularMoviedaoDart;
    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => testProvider.name = "Rubensin",
      ),
      body: FutureBuilder<VideoPopular>(
        future: _trailerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el trailer.'));
          } else if (snapshot.hasData) {
            final trailer = snapshot.data!;
            _youtubeController = YoutubePlayerController(
              initialVideoId: trailer.key,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );

            return SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${popular.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              popular.title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              popular.overview,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Aquí se muestra el rating de estrellas
                            RatingBarIndicator(
                              rating: popular.voteAverage /
                                  2, // Escala de 5 estrellas
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 60.0,
                              direction: Axis.horizontal,
                              
                            ),
                            const SizedBox(height: 20),
                            // Aquí va el FutureBuilder para el elenco y otros elementos
                            FutureBuilder<List<Actor>>(
                              future: _castFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Error al cargar el elenco.');
                                } else if (snapshot.hasData) {
                                  final actors = snapshot.data!;
                                  return SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: actors.length,
                                      itemBuilder: (context, index) {
                                        final actor = actors[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: actor
                                                            .profilePath !=
                                                        null
                                                    ? NetworkImage(
                                                        'https://image.tmdb.org/t/p/w500${actor.profilePath}')
                                                    : const AssetImage(
                                                            'assets/image.png')
                                                        as ImageProvider,
                                              ),
                                              const SizedBox(height: 8),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  actor.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Text(
                                      'No se encontraron actores.');
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: YoutubePlayer(
                                controller: _youtubeController!,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.red,
                                onReady: () {
                                  _youtubeController!.addListener(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No se encontró el trailer.'));
          }
        },
      ),
    );
  }
}
