import 'package:flutter/material.dart';
import 'package:pmsn2024b/database/movies_database.dart';
import 'package:pmsn2024b/firebase/database_movies.dart';
import 'package:pmsn2024b/settings/global_values.dart';
import 'package:pmsn2024b/views/movie_view.dart';
import 'package:pmsn2024b/views/new_movie_view_firebase.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../models/moviedao.dart';
class MovieViewItemFirebase extends StatefulWidget {
  const MovieViewItemFirebase(
      {super.key, required this.moviesDAO, required this.Uid});

  final MoviesDAO moviesDAO;
  
  final Uid;
  @override
  State<MovieViewItemFirebase> createState() => _MovieViewItemFirebaseState();
}

class _MovieViewItemFirebaseState extends State<MovieViewItemFirebase> {
  DatabaseMovies? moviesDatabase;

  @override
  void initState() {
    super.initState();
    moviesDatabase = DatabaseMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(68, 138, 255, 1)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                widget.moviesDAO.imgMovie!,
                width: 100,
                height: 100,
              ),
              Expanded(
                child: ListTile(
                  title: Text(widget.moviesDAO.nameMovie!),
                  subtitle: Text(
                    widget.moviesDAO.releaseDate != null
                        ? widget.moviesDAO.releaseDate!
                        : 'Unknown Date',
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    WoltModalSheet.show(
                        context: context,
                        pageListBuilder: (context) => [
                              WoltModalSheetPage(
                                  child: NewMoviewViewFireabase(
                                moviesDAO: widget.moviesDAO,
                                uid: widget.Uid,
                              ))
                            ]);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    moviesDatabase!.eliminar(widget.Uid).then((value) {
                      if (true) {
                        return QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Transaction Completed Successfully!',
                          autoCloseDuration: const Duration(seconds: 2),
                          showConfirmBtn: true,
                        );
                      } else {
                        return QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Something was wrong! :()',
                          autoCloseDuration: const Duration(seconds: 2),
                          showConfirmBtn: false,
                        );
                      }
                    });
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
          const Divider(),
          Text(widget.moviesDAO.overview!),
        ],
      ),
    );
  }
}

//