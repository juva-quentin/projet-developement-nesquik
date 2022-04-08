import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projet_developement_nesquik/auth/auth_util.dart';
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

  AddFriend(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.user.uid)
        .update({
      "friends": FieldValue.arrayUnion([uid])
    }).then((_) {
      print("success!");
      FirebaseFirestore.instance.collection("users").doc(uid).update({
        "friends": FieldValue.arrayUnion([currentUser.user.uid])
      }).then((_) {
        print("success!2");
      });
    });
  }

  RemoveFriend(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.user.uid)
        .update({
      "friends": FieldValue.arrayRemove([uid])
    }).then((_) {
      print("success!remove");
      FirebaseFirestore.instance.collection("users").doc(uid).update({
        "friends": FieldValue.arrayRemove([currentUser.user.uid])
      }).then((_) {
        print("success!2remove");
      });
    });
  }

  UpdateObjectif(
    String pseudo,
    String email,
    String objectif,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.user.uid)
        .update({
      "pseudo": pseudo,
      "email": email,
      "objectif": int.parse(objectif)
    }).then((_) {
      print("success!new objectif");
    });
  }

  DeleteUser(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.user.uid)
        .delete()
        .then((_) {
      print("success!delete user");
      DeleteUserParcoursStorage(context);
    });
  }

  DeleteUserParcoursStorage(BuildContext context) async {
    final storageRef = FirebaseStorage.instance.ref();
    final courses = FirebaseFirestore.instance
        .collection('parcours')
        .where("owner", isEqualTo: currentUser.user.uid);
    await courses.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) async {
        var mapCourseFireBase = Map<String, dynamic>.from(doc.data());
        var ref;
        switch (mapCourseFireBase['type']) {
          case "public":
            {
              ref = "parcoursPublic";
              break;
            }
          case "protected":
            {
              ref = "parcoursProtected";
              break;
            }
          case "private":
            {
              ref = "parcoursPrivate";
              break;
            }

            break;
          default:
        }
        DeleteUserParcoursData(doc.id);
        print("parcours" + "${ref}/${mapCourseFireBase["title"]}");
        final desertRef =
            storageRef.child("${ref}/${mapCourseFireBase["title"]}.txt");
        try {
          final listResult = await desertRef.delete();
        } on FirebaseException catch (e) {
          // Caught an exception from Firebase.
          print("Failed with error '${e.code}': ${e.message}");
          if (e == null) {
            print("success!delete all user parcours");
            DeleteUserParcoursData(doc.id);
          }
        }
      });
    }).then((_) => deleteUser(context));
  }

  DeleteUserParcoursData(String id) async {
    await FirebaseFirestore.instance.collection('parcours').doc(id).delete();
  }
}
