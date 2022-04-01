import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:projet_developement_nesquik/auth/firebase_user_provider.dart';
import 'dart:convert';
import 'Parcour.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> urls_Protected = [];
List<String> urls_Private = [];
List<String> urls_Public = [];

Future tt() async {
  getProtectedFromApi().then((value) => print("Protected_FromApi_Add"));
  getPrivateFromApi().then((value) => print("Private_FromApi_Add"));
  getPublicFromApi().then((value) => print("Public_FromApi_Add"));
}

Future getPrivateFromApi() async {
  await FirebaseFirestore.instance
      .collection('parcours')
      .where('owner', isEqualTo: currentUser.user.uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      var address = doc['address'];
      urls_Private.add(address);
    });
  });
  for (var i = 0; i < urls_Private.length; i++) {
    var response = await http.get(Uri.parse(urls_Private[i]));
    if (response.statusCode == 200) {
      List<LatLng> positions = [];
      List<double> eles = [];
      var resp = json.decode(response.body);
      var parcours = Parcour.fromJson(resp);

      for (var y = 0; y < parcours.gpx.trk.trkseg.trkpt.length; y++) {
        double lat = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lat);
        double lng = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lon);
        double ele = double.parse(parcours.gpx.trk.trkseg.trkpt[y].ele);
        positions.add(LatLng(lat, lng));
      }
      listMarkerPrivate.add(
        setMarker(
          MarkerId(i.toString()),
          InfoWindow(
            title: "${parcours.gpx.trk.name}",
            snippet:
                "${parcours.gpx.trk.type} - ${calculDistance(positions).toStringAsFixed(2)} Km",
          ),
          BitmapDescriptor.defaultMarker,
          LatLng(positions.first.latitude, positions.first.longitude),
        ),
      );
      listPolylinePrivate.add(setPolyline(
        i.toString(),
        positions,
        Color.fromRGBO(114, 176, 234, 1),
      ));
    }
  }
}

Future getProtectedFromApi() async {
  await FirebaseFirestore.instance
      .collection('parcours')
      .where('shareTo', arrayContains: currentUser.user.uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      var address = doc['address'];
      urls_Protected.add(address);
    });
  });
  for (var i = 0; i < urls_Protected.length; i++) {
    var response = await http.get(Uri.parse(urls_Protected[i]));
    if (response.statusCode == 200) {
      List<LatLng> positions = [];
      var resp = json.decode(response.body);
      var parcours = Parcour.fromJson(resp);

      for (var y = 0; y < parcours.gpx.trk.trkseg.trkpt.length; y++) {
        double lat = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lat);
        double lng = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lon);
        positions.add(LatLng(lat, lng));
      }
      listMarkerProtected.add(setMarker(
        MarkerId((i + 2).toString()),
        InfoWindow(
          title: "${parcours.gpx.trk.name}",
          snippet:
              "${parcours.gpx.trk.type} - ${calculDistance(positions).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarker,
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listPolylineProtected.add(setPolyline(
        i.toString(),
        positions,
        Color.fromARGB(255, 224, 78, 78),
      ));
    }
  }
}

Future getPublicFromApi() async {
  await FirebaseFirestore.instance
      .collection('parcours')
      .where('type', isEqualTo: "public")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      var address = doc['address'];
      urls_Public.add(address);
    });
  });

  for (var i = 0; i < urls_Public.length; i++) {
    var response = await http.get(Uri.parse(urls_Public[i]));
    if (response.statusCode == 200) {
      List<LatLng> positions = [];
      var resp = json.decode(response.body);
      var parcours = Parcour.fromJson(resp);
      for (var y = 0; y < parcours.gpx.trk.trkseg.trkpt.length; y++) {
        double lat = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lat);
        double lng = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lon);
        positions.add(LatLng(lat, lng));
      }
      listMarkerPublic.add(setMarker(
        MarkerId((i + 3).toString()),
        InfoWindow(
          title: "${parcours.gpx.trk.name}",
          snippet:
              "${parcours.gpx.trk.type} - ${calculDistance(positions).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarker,
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listPolylinePublic.add(setPolyline(
        i.toString(),
        positions,
        Color.fromARGB(255, 79, 219, 51),
      ));
    }
  }
}

//Camera

final CameraPosition kPositionnementInitial = CameraPosition(
  target: LatLng(45.764043, 4.835659),
  zoom: 8,
);

//marker

Marker setMarker(
    MarkerId markid, InfoWindow infowin, BitmapDescriptor ico, LatLng pos,
    {bool consumeTapEvents, bool mapToolbarEnabled}) {
  return Marker(
    markerId: markid,
    infoWindow: infowin,
    icon: ico,
    position: pos,
  );
}

//polyline

Polyline setPolyline(String polID, List<LatLng> listCoord, Color colo) {
  return Polyline(
    polylineId: PolylineId(polID),
    points: listCoord,
    width: 3,
    color: colo,
    onTap: () {},
  );
}

List listPolylinePrivate = [];
List listPolylineProtected = [];
List listPolylinePublic = [];

List listMarkerPrivate = [];
List listMarkerProtected = [];
List listMarkerPublic = [];

// calcul distance

double calculDistance(List<LatLng> listCoord) {
  double result = 0;
  List<LatLng> listCoordoRad = List.empty(growable: true);

  for (var y = 0; y < listCoord.length; y++) {
    listCoordoRad.add(LatLng(listCoord[y].latitude * (3.14 / 180),
        listCoord[y].longitude * (3.14 / 180)));
  }

  for (var i = 0; i < listCoordoRad.length - 1; i++) {
    result += acos(sin(listCoordoRad[i].latitude) *
                sin(listCoordoRad[i + 1].latitude) +
            cos(listCoordoRad[i].latitude) *
                cos(listCoordoRad[i + 1].latitude) *
                cos(listCoordoRad[i + 1].longitude -
                    listCoordoRad[i].longitude)) *
        6371;
  }

  return result;
  // result =
  //     acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1)) *
  //         6371;
}
