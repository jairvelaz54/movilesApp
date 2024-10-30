import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMovies {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;
  DatabaseMovies() {
    collectionReference = firebaseFirestore.collection('movies');
  }
  Future<void> insertar(Map<String, dynamic> movies) async {
    return collectionReference!.doc().set(movies);
  }

  Future<void> eliminar(String uid) async {
    return collectionReference!.doc(uid).delete();
  }
  Stream<QuerySnapshot> select() {
    return collectionReference!.snapshots();
  }

  Future<void> update(Map<String, dynamic> movies, String uid) async {
    return collectionReference!.doc(uid).update(movies);
  }
}
