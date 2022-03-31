import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Parcour.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> urls_Protected = [
  "https://firebasestorage.googleapis.com/v0/b/projet-dev-neskique.appspot.com/o/parcoursProtected%2Fprotected1.txt?alt=media&token=9d8382fd-3c5b-49b9-893c-9ecd722e2157",
  "https://firebasestorage.googleapis.com/v0/b/projet-dev-neskique.appspot.com/o/parcoursProtected%2Fprotected2.txt?alt=media&token=ea972a28-9735-4de8-9203-f5a5e8b0707a"
];
List<String> urls_Private = [
  "https://firebasestorage.googleapis.com/v0/b/projet-dev-neskique.appspot.com/o/parcoursPrivate%2Fprivate2.txt?alt=media&token=95ee2051-0b68-4ba3-b8b3-6d0112af6572",
  "https://firebasestorage.googleapis.com/v0/b/projet-dev-neskique.appspot.com/o/parcoursPrivate%2Fprivate1.txt?alt=media&token=4a5bc54f-5a8f-4f81-9550-2cc400bf68f1"
];
List<String> urls_Public = [
  "https://firebasestorage.googleapis.com/v0/b/projet-dev-neskique.appspot.com/o/parcoursPublic%2Fpublic2.txt?alt=media&token=c5b9a195-ee76-48e3-9bb5-a37eb68cd1fc",
  "https://firebasestorage.googleapis.com/v0/b/projet-dev-neskique.appspot.com/o/parcoursPublic%2Fpublic3.txt?alt=media&token=dce5b713-17ca-48d6-a378-a8630b0ccf3b"
];

Future tt() async {
  getProtectedFromApi().then((value) => print("Protected_FromApi_Add"));
  getPrivateFromApi().then((value) => print("Private_FromApi_Add"));
  getPublicFromApi().then((value) => print("Public_FromApi_Add"));
}

Future getPrivateFromApi() async {
  for (var i = 0; i < urls_Private.length; i++) {
    var response = await http.get(Uri.parse(urls_Private[i]));
    if (response.statusCode == 200) {
      List<LatLng> positions = [];
      var resp = json.decode(response.body);
      var parcours = Parcour.fromJson(resp);

      for (var y = 0; y < parcours.gpx.trk.trkseg.trkpt.length; y++) {
        double lat = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lat);
        double lng = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lon);
        positions.add(LatLng(lat, lng));
      }
      listMarkerPrivate.add(setMarker(
        MarkerId("start"),
        InfoWindow.noText,
        BitmapDescriptor.defaultMarker,
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listPolylinePrivate.add(setPolyline(
        i.toString(),
        positions,
        Color.fromARGB(255, 161, 20, 79),
      ));
    }
  }
}

Future getProtectedFromApi() async {
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
        MarkerId("start"),
        InfoWindow.noText,
        BitmapDescriptor.defaultMarker,
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listPolylineProtected.add(setPolyline(
        i.toString(),
        positions,
        Color.fromARGB(255, 23, 73, 211),
      ));
    }
  }
}

Future getPublicFromApi() async {
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
        MarkerId("start"),
        InfoWindow.noText,
        BitmapDescriptor.defaultMarker,
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listPolylinePublic.add(setPolyline(
        i.toString(),
        positions,
        Color.fromARGB(255, 102, 15, 173),
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
    MarkerId markid, InfoWindow infowin, BitmapDescriptor ico, LatLng pos) {
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

//calcul distance

// Future<void> calculDistance(List<LatLng> listCoord) async {
//   double result = 0;
//   List<LatLng> listCoordoRad = List.empty(growable: true);

//   for (var y = 0; y < listCoordo.length; y++) {
//     listCoordoRad.add(LatLng(listCoordo[y].latitude * passageRad,
//         listCoordo[y].longitude * passageRad));
//   }

//   for (var i = 0; i < listCoordoRad.length - 1; i++) {
//     result += acos(sin(listCoordoRad[i].latitude) *
//                 sin(listCoordoRad[i + 1].latitude) +
//             cos(listCoordoRad[i].latitude) *
//                 cos(listCoordoRad[i + 1].latitude) *
//                 cos(listCoordoRad[i + 1].longitude -
//                     listCoordoRad[i].longitude)) *
//         6371;
//   }
  // result =
  //     acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1)) *
  //         6371;
// }
