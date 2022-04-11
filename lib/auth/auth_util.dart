import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_user_provider.dart';

export 'email_auth.dart';

/// Tries to sign in or create an account using Firebase Auth.
/// Returns the User object if sign in was successful.
Future<User> signInOrCreateAccount(
    BuildContext context, Future<UserCredential> Function() signInFunc) async {
  try {
    final userCredential = await signInFunc();
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
    return null;
  }
}

Future<void> signOut() async {
  _currentJwtToken = '';
  FirebaseAuth.instance.signOut();
}

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
                'Too long since most recent sign in. Sign in again before deleting your account.')),
      );
    }
  }
}

Future resetPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
    return null;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Password reset email sent')),
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

// Set when using phone verification (after phone number is provided).
// Set when using phone sign in in web mode (ignored otherwise).
