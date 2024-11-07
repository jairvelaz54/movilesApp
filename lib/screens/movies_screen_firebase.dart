import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024b/firebase/database_movies.dart';
import 'package:pmsn2024b/models/moviedao.dart';
import 'package:pmsn2024b/views/movie_view_firebase.dart';
import 'package:pmsn2024b/views/movie_view_item_firebase.dart';
import 'package:pmsn2024b/views/new_movie_view_firebase.dart';

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
         appBar: AppBar(
        title: const Text('Movies List'),
        actions: [
          IconButton(
            onPressed: (){

              WoltModalSheet.show(
                context: context, 
                pageListBuilder: (context) => [
                  WoltModalSheetPage(
                    child: NewMoviewViewFireabase()
                  )
                ]
              );

            }, 
            icon: const Icon(Icons.add) 
          )
        ],
      ),
      body: StreamBuilder(
          stream: databaseMovies!.select(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var movie = snapshot.data!.docs;
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var movieData= movie[index];
                 return MovieViewItemFirebase(
                  moviesDAO: MoviesDAO.fromMap({
                  'idMovie': 0,
                  'imgMovie': movieData.get('imgMovie') ,
                  'nameMovie': movieData.get('nameMovie') ,
                  'overview': movieData.get('overview') ,'releaseDate': movieData.get('releaseDate').toString()
                  },
                  ),
                  Uid: movieData.id
                  );
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
