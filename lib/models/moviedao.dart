class MoviesDAO {
  int? idMovie;
  String? nameMovie;
  String? overview;
  String? idGenre;
  String? imgMovie;
  String? releaseDate;
  
  MoviesDAO({this.idMovie, this.nameMovie, this.overview, this.idGenre, this.imgMovie, this.releaseDate});
  factory MoviesDAO.fromMap(Map<String,dynamic> movie){
    return MoviesDAO(
      idMovie: movie['idMovie'],
      nameMovie: movie['title'],
      overview: movie['overview'],
      idGenre: movie['idGenre'],
      imgMovie: movie['imgMovie'],
      releaseDate: movie['releaseDate']
    );
   }

}