import 'package:flutter/material.dart';
import 'package:pmsn2024b/firebase/database_movies.dart';

import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MoviesScreenFirebase extends StatefulWidget {
  const MoviesScreenFirebase({super.key});

  @override
  State<MoviesScreenFirebase> createState() => _MoviesScreenStateFirebase();
}

class _MoviesScreenStateFirebase extends State<MoviesScreenFirebase> {
  late DatabaseMovies databaseMovies;

  void initState() {
    databaseMovies = DatabaseMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: databaseMovies!.select(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Image.network(snapshot.data!.docs[index].get('imgMovie '));
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error en la base de datos');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
