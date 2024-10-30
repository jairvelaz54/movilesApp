import 'package:flutter/material.dart';
import 'package:pmsn2024b/firebase/database_movies.dart';
import 'package:pmsn2024b/models/moviedao.dart';
import 'package:pmsn2024b/views/movie_view_firebase.dart';
import 'package:pmsn2024b/views/movie_view_item_firebase.dart';

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
                    child: MovieViewFirebase()
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
              var movie = snapshot.data;
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                 return MovieViewItemFirebase(moviesDAO: MoviesDAO.fromMap({
                  'idMovie': snapshot.data!.docs[index].id,
                  'imgMovie': snapshot.data!.docs[index].get('imgMovie') ,'nameMovie': snapshot.data!.docs[index].get('nameMovie') ,'overview': snapshot.data!.docs[index].get('overview') ,'releaseDate': snapshot.data!.docs[index].get('releaseDate')}));
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
