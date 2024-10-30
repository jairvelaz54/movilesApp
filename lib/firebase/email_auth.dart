
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> createuser(String user, String email, String password) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      credentials.user!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return false;
  }

  Future<bool> validateUser(String email, String password) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user.user!.emailVerified) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
