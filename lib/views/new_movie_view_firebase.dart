import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024b/firebase/database_movies.dart';
import 'package:pmsn2024b/models/moviedao.dart';
import 'package:pmsn2024b/settings/global_values.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class NewMoviewViewFireabase extends StatefulWidget {
  final String? uid;
  NewMoviewViewFireabase({super.key, this.moviesDAO, this.uid});

  MoviesDAO? moviesDAO;

  @override
  State<NewMoviewViewFireabase> createState() => _MoviewViewFireabaseState();
}

class _MoviewViewFireabaseState extends State<NewMoviewViewFireabase> {
  TextEditingController conName = TextEditingController();
  TextEditingController conOverview = TextEditingController();
  TextEditingController conImgMovie = TextEditingController();
  TextEditingController conRelease = TextEditingController();
  DatabaseMovies? moviesDatabase;

  @override
  void initState() {
    super.initState();
    moviesDatabase = DatabaseMovies();

    if (widget.moviesDAO != null) {
      conName.text = widget.moviesDAO!.nameMovie!;
      conOverview.text = widget.moviesDAO!.overview!;
      conImgMovie.text = widget.moviesDAO!.imgMovie!;
      conRelease.text = widget.moviesDAO!.releaseDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameMovie = TextFormField(
      controller: conName,
      decoration: const InputDecoration(hintText: 'Nombre de la película'),
    );
    final txtOverview = TextFormField(
      controller: conOverview,
      maxLines: 5,
      decoration: const InputDecoration(hintText: 'Sinapsis de la película'),
    );
    final txtImgMovie = TextFormField(
      controller: conImgMovie,
      decoration: const InputDecoration(hintText: 'Poster de la película'),
    );
    final txtRelease = TextFormField(
      readOnly: true,
      controller: conRelease,
      decoration: const InputDecoration(hintText: 'Fecha de lanzamiento'),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime(2050));

        if (pickedDate != null) {
          String formatDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          conRelease.text = formatDate;
          setState(() {});
        }
      },
    );

    final btnSave = ElevatedButton(
      onPressed: () {
        if (widget.moviesDAO == null) {
          moviesDatabase!.insertar({
            "nameMovie": conName.text,
            "overview": conOverview.text,
            "imgMovie": conImgMovie.text,
            "releaseDate": conRelease.text
          }).then((value) {
            if (value != 0) {
              GlobalValues.banUpdListMovie.value =
                  !GlobalValues.banUpdListMovie.value;
              return QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Transaction Completed Successfully!',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            } else {
              return QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Something went wrong! :(',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            }
          });
        } else {
          moviesDatabase!.update({
            "nameMovie": conName.text,
            "overview": conOverview.text,
            "imgMovie": conImgMovie.text,
            "releaseDate": conRelease.text
          }, widget.uid.toString()).then((value) {
            if (value) {
              setState(() {
                GlobalValues.banUpdListMovie.value =
                    !GlobalValues.banUpdListMovie.value;
              });
              QuickAlert.show( 
                context: context,
                type: QuickAlertType.success,
                text: 'Movie updated successfully!',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            } else {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Something went wrong during the update!',
                autoCloseDuration: const Duration(seconds: 2),
                showConfirmBtn: false,
              );
            }
          });
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
      child: const Text('Guardar'),
    );

    return ListView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      children: [txtNameMovie, txtOverview, txtImgMovie, txtRelease, btnSave],
    );
  }
}