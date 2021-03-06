import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_user_provider.dart';

export 'email_auth.dart';

/// Essaye de connecter l'utilisateur ou de creer un compte
/// Retour si l'utilisateur c'est bien connecté
Future<User> signInOrCreateAccount(
    BuildContext context, Future<UserCredential> Function() signInFunc) async {
  try {
    final userCredential = await signInFunc();
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: ${e.message}')),
    );
    return null;
  }
}

//Déconnecte l'utilisateur
Future<void> signOut() async {
  _currentJwtToken = '';
  FirebaseAuth.instance.signOut();
}

//Supprime l'utilisateur connecté
Future deleteUser(BuildContext context) async {
  try {
    if (currentUser?.user == null) {
      print('Error: delete user attempted with no logged in user!');
      return;
    }

    print("del user");
    await currentUser?.user?.delete()?.then((_) => signOut());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Cela fait trop longtemps que vous êtes connécté, reconnectez-vous')),
      );
    }
  }
}

//Envoi d'un mail de réinitialisation du mot de passe
Future resetPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: ${e.message}')),
    );
    return null;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Un mail de réinitialisation vous à été envoyé ')),
  );
}

Future sendEmailVerification() async =>
    currentUser?.user?.sendEmailVerification();

String _currentJwtToken = '';

String get currentUserEmail => currentUser?.user?.email ?? '';

String get currentUserUid => currentUser?.user?.uid ?? '';

String get currentUserDisplayName => currentUser?.user?.displayName ?? '';

String get currentUserPhoto => currentUser?.user?.photoURL ?? '';

String get currentPhoneNumber => currentUser?.user?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.user?.emailVerified ?? false;
