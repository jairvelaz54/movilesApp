import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseMovies {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;

  DatabaseMovies() {
    collectionReference = firebaseFirestore.collection('movies');
  }
  Future<bool> insertar(Map<String, dynamic> movies) async {
    try{
      collectionReference!.doc().set(movies);
      return true;
    } catch (e) {
      kDebugMode ? print(e) : print(e);
      print(e);
    }
    return false;
  }

  Future<bool> eliminar(String uid) async {
    try{
        collectionReference!.doc(uid).delete();   
        return true;
    }catch(e){
      kDebugMode ? print(e) : print(e);
      print(e);
      return false;
    }
      return false;
    
  }
  Stream<QuerySnapshot> select()  {
    return collectionReference!.snapshots();
  }
  Future<bool> update(Map<String, dynamic> movies, String uid) async {
    try{
      collectionReference!.doc(uid).update(movies);
      return true;
    } catch (e) {
      kDebugMode ? print(e) : print(e);
      print(e);
    }
    return false;
   
    }
    
  }