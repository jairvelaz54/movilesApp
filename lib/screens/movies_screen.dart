import 'package:flutter/material.dart';
import 'package:pmsn2024b/database/movies_database.dart';
import 'package:pmsn2024b/models/moviedao.dart';
import 'package:pmsn2024b/views/movie_view_item.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late MoviesDatabase moviesDB;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies List'), actions: [
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (context) =>
                      [WoltModalSheetPage(child: Text('Aqui debe aparecer'))]);
            })
      ]),
      body: FutureBuilder(
          future: moviesDB.SELECT(),
          builder: (context, AsyncSnapshot<List<MoviesDAO>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MovieViewItem(moviesDAO: snapshot.data![index]);
                },
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something was wrong!'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }
}
