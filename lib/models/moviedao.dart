class MoviesDAO{
  int? idMovie;
  String? nameMovie;
  String? overview;
  String? idGenero;
  String? imgMovie;
  String? releaseDate;

  MoviesDAO({this.idMovie, this.nameMovie, this.overview, this.idGenero, this.imgMovie, this.releaseDate});

  factory MoviesDAO.fromMap(Map<String, dynamic> movie){
    return MoviesDAO(
      idMovie: 0,
      nameMovie: movie['nameMovie'],
      overview: movie['overview'],
      idGenero: movie['idGenero'],
      imgMovie: movie['imgMovie'],
      releaseDate: movie['releaseDate']
    );
  }
  
}