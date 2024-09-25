import 'package:flutter/material.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  TextEditingController conName = TextEditingController();
  TextEditingController conOverview = TextEditingController();
  TextEditingController conImgMovie = TextEditingController();
  TextEditingController conRelease = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final txtNameMovie = TextFormField(
      controller: conName,
    );
    final txtOverview = TextFormField(
      controller: conOverview,
    );
    final txtImgMovie = TextFormField(
      controller: conImgMovie,
    );
    final txtRelease = TextFormField(
      controller: conRelease,
    );
    return ListView(
      shrinkWrap: true,
      children: [
        txtNameMovie,
        txtOverview,
        txtImgMovie,
        txtRelease,
      ],
    );
  }
}
