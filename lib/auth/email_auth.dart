import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_util.dart';

Future<User> signInWithEmail(
    BuildContext context, String email, String password) async {
  final signInFunc = () => FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email.trim(), password: password);
  return signInOrCreateAccount(context, signInFunc);
}

Future<User> createAccountWithEmail(
    BuildContext context, String email, String password) async {
  final createAccountFunc = () => FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email.trim(), password: password);

  return signInOrCreateAccount(context, createAccountFunc);
}

Future<void> addNewUsertoDataBase(
    User user, String email, String pseudo, String genre) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users
      .doc(user.uid)
      .set({
        "pseudo": pseudo,
        "email": email,
        "genre": genre,
        "objectif": 0,
        "tdp": 0
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
