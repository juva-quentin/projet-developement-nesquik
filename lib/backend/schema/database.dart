import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projet_developement_nesquik/auth/firebase_user_provider.dart';
import 'package:projet_developement_nesquik/backend/Parcours.dart';
import 'package:projet_developement_nesquik/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final storageRef = FirebaseStorage.instance.ref();
  UploadToStorage(String ref, String name, String data, Parcours parcours,
      BuildContext context) async {
    final mountainsRef = storageRef.child("${ref}/${name}.txt");
    final uploadTask =
        mountainsRef.putString(data, format: PutStringFormat.raw);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          print("Upload was erreur");
          break;
        case TaskState.success:
          await mountainsRef.getDownloadURL().then((value) {
            parcours.address = value;
            UploadParcours(mountainsRef, parcours, context);
          });

          break;
      }
    });
  }

  UploadParcours(Reference ref, Parcours parcours, BuildContext context) async {
    print("debug1");
    parcours.owner = currentUser.user.uid;
    CollectionReference parcour =
        FirebaseFirestore.instance.collection('parcours');
    parcour.doc().set({
      "owner": parcours.owner,
      "title": parcours.title,
      "address": parcours.address,
      "type": parcours.type,
      "description": parcours.description,
      "shareTo": parcours.shareTo,
      "distance": parcours.distance,
      "temps": parcours.temps,
      "denivele": parcours.denivele,
      "vitesse": parcours.vitesse,
    }).then((value) {
      print("Pacours Added");
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
