import 'package:flutter/material.dart';
import 'package:pmsn2024b/models/popular_moviedao.dart';
import 'package:pmsn2024b/provider/test_provider.dart';
import 'package:provider/provider.dart';

class DetailPopularScreen extends StatefulWidget {
  const DetailPopularScreen({super.key});

  @override
  State<DetailPopularScreen> createState() => _DetailPopularScreenState();
}

class _DetailPopularScreenState extends State<DetailPopularScreen> {
  @override
  Widget build(BuildContext context) {
    final popular =
        ModalRoute.of(context)!.settings.arguments as PopularMoviedaoDart;
    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      floatingActionButton:
          FloatingActionButton(onPressed: () => testProvider.name = "Rubensin"),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: .3,
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500/${popular.posterPath}'))),
      ),
    );
  }
}
