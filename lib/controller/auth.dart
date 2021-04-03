import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<dynamic> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    String _error;
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      _error = 'The password provided is too weak';
      return _error;
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      _error = 'The account already exists for that email';
      return _error;
    }
    //return false;
  } catch (e) {
    print(e.toString());
    //return false;
  }
}
