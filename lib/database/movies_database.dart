import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:pmsn2024b/models/moviedao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
class MoviesDatabase {
  
  static final NAMEDB="MOVIESDB";
  static final VERSIONDB= 1;

  static Database? _database;
  Future <Database> get database async{
    if (_database != null) return _database!;
    return _database = await initDatabase();
  }
  
  Future<Database> initDatabase() async {
    Directory folder= await getApplicationDocumentsDirectory();
    String path=join(folder.path,NAMEDB);
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version)  {
        String query = '''
CREATE TABLE tblgenre(
idGenre char(1) PRIMARY KEY,
dscgenre varchar(50)

);

CREATE TABLE tblmovies(
        idMovie INTEGER PRIMARY KEY,
        nameMovie varchar(100),
        overview TEXT,
        idGenre char(1),
        imgMovie varchar(150),
        releaseDate char(10),
        CONSTRAINT fk_gen FOREIN KEY(idGenre) references tblgenre(idGenre)
        );''';
        db.execute(query);
      },
    );
  }//initDatabase

  Future<int> INSERT(String table, Map<String, dynamic> row )async {
    var con=  await database ;
    return await con.insert(table, row);
  }
  Future<int> UPDATE(String table, Map<String, dynamic> row)async {
    var con = await database ;
    return  await con.update(table, row, where: 'idMovie=?',whereArgs: [row['idMovie']]);
    
  }
  Future<int> DELETE(String table , int idMovie)async{
    var con= await database ;
    return await con.delete(table, where: 'idMovie=?',whereArgs: [idMovie]);
  }
  Future<List<MoviesDAO>> SELECT()async{
    var con = await database ;
    var result= await con.query('tblmovies');
    return  result.map((movie)=>MoviesDAO.fromMap(movie)).toList();

  }
}