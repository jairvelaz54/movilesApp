import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMovies {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;
  DatabaseMovies() {
    collectionReference = firebaseFirestore.collection('movies');
  }
  Future<bool> insertar(Map<String, dynamic> movies) async {
    try {
      collectionReference!.doc().set(movies);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> eliminar(String uid) async {
    return collectionReference!.doc(uid).delete();
  }

  Stream<QuerySnapshot> select() {
    return collectionReference!.snapshots();
  }

  Future<bool> update(Map<String, dynamic> movies, String uid) async {
    try {
      collectionReference!.doc(uid).update(movies);
    } catch (e) {
      return false;
    }
    return true;
  }
}
