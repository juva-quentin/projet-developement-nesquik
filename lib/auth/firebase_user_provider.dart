import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

//Class utilisateur
class ProjetDevFirebaseUser {
  ProjetDevFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

ProjetDevFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<ProjetDevFirebaseUser> projetDevFirebaseUserStream() => FirebaseAuth
    .instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<ProjetDevFirebaseUser>(
        (user) => currentUser = ProjetDevFirebaseUser(user));
