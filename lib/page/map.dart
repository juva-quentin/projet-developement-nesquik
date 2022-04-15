import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:projet_developement_nesquik/auth/firebase_user_provider.dart';
import 'package:projet_developement_nesquik/backend/Parcours.dart';
import 'dart:convert';
import 'Parcour.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Parcours> urls_Protected = [];
List<Parcours> urls_Private = [];
List<Parcours> urls_Public = [];

List<LatLng> parcourCreat = [];
List<double> elevationCreat = [];

List listPolylinePrivate = [];
List listPolylineProtected = [];
List listPolylinePublic = [];

List listMarkerPrivate = [];
List listMarkerProtected = [];
List listMarkerPublic = [];

List<List<double>> listElePrivate = [];
List<List<double>> listEleProtected = [];
List<List<double>> listElePublic = [];
int chrono;
bool sportType = false;

final courses = FirebaseFirestore.instance.collection('parcours');

//Parcours

Future getAllParcoursFromApi() async {
  getProtectedFromApi().then((value) => print("Protected_FromApi_Add"));
  getPrivateFromApi().then((value) => print("Private_FromApi_Add"));

  getPublicFromApi().then((value) => print("Public_FromApi_Add"));
}

getLinksStorageParcours() async {
  await courses.get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((DocumentSnapshot doc) {
      var mapCourseFireBase = Map<String, dynamic>.from(doc.data());
      switch (mapCourseFireBase['type']) {
        case "public":
          {
            Parcours parcours = new Parcours(
                mapCourseFireBase['owner'],
                mapCourseFireBase['title'],
                mapCourseFireBase['address'],
                mapCourseFireBase['type'],
                mapCourseFireBase['description'],
                mapCourseFireBase['distance'],
                mapCourseFireBase['temps'],
                mapCourseFireBase['vitesse'],
                mapCourseFireBase['date']);
            urls_Public.add(parcours);
            break;
          }
        case "protected":
          {
            if (mapCourseFireBase['shareTo'].contains(currentUser.user.uid) ||
                mapCourseFireBase['owner'] == currentUser.user.uid) {
              Parcours parcours = new Parcours(
                  mapCourseFireBase['owner'],
                  mapCourseFireBase['title'],
                  mapCourseFireBase['address'],
                  mapCourseFireBase['type'],
                  mapCourseFireBase['description'],
                  mapCourseFireBase['distance'],
                  mapCourseFireBase['temps'],
                  mapCourseFireBase['vitesse'],
                  mapCourseFireBase['date']);
              urls_Protected.add(parcours);
            }
            break;
          }
        case "private":
          {
            if (mapCourseFireBase['owner'] == currentUser.user.uid) {
              Parcours parcours = new Parcours(
                  mapCourseFireBase['owner'],
                  mapCourseFireBase['title'],
                  mapCourseFireBase['address'],
                  mapCourseFireBase['type'],
                  mapCourseFireBase['description'],
                  mapCourseFireBase['distance'],
                  mapCourseFireBase['temps'],
                  mapCourseFireBase['vitesse'],
                  mapCourseFireBase['date']);
              urls_Private.add(parcours);
            }
            break;
          }

          break;
        default:
      }
    });
    getAllParcoursFromApi();
  });
}

Future getPrivateFromApi() async {
  for (var i = 0; i < urls_Private.length; i++) {
    var response = await http.get(Uri.parse(urls_Private[i].address));
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
        eles.add(ele);
      }
      BitmapDescriptor pinNewParcour;
      listMarkerPrivate.add(
        setMarker(
          MarkerId(i.toString()),
          InfoWindow(
            title: "${urls_Private[i].title}",
            snippet:
                "${parcours.gpx.trk.type} - ${calculDistance(positions).toStringAsFixed(2)} Km",
          ),
          pinNewParcour = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 30.0),
              "assets/images/markerPrivate.png"),
          LatLng(positions.first.latitude, positions.first.longitude),
        ),
      );
      listElePrivate.add(eles);
      listPolylinePrivate.add(setPolyline(
        i.toString(),
        positions,
        Color.fromARGB(255, 190, 69, 69),
      ));
    }
  }
}

Future getProtectedFromApi() async {
  for (var i = 0; i < urls_Protected.length; i++) {
    var response = await http.get(Uri.parse(urls_Protected[i].address));
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

        eles.add(ele);
      }

      BitmapDescriptor pinNewParcour;
      listMarkerProtected.add(setMarker(
        MarkerId((i + 2).toString()),
        InfoWindow(
          title: "${urls_Protected[i].title}",
          snippet:
              "${parcours.gpx.trk.type} - ${calculDistance(positions).toStringAsFixed(2)} Km",
        ),
        pinNewParcour = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 30.0),
            "assets/images/markerProtected.png"),
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listEleProtected.add(eles);
      listPolylineProtected.add(setPolyline(
          i.toString(), positions, Color.fromARGB(255, 150, 114, 234)));
    }
  }
}

Future getPublicFromApi() async {
  for (var i = 0; i < urls_Public.length; i++) {
    var response = await http.get(Uri.parse(urls_Public[i].address));
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
        eles.add(ele);
      }
      BitmapDescriptor pinNewParcour;
      listMarkerPublic.add(setMarker(
        MarkerId((i + 3).toString()),
        InfoWindow(
          title: "${urls_Public[i].title}",
          snippet:
              "${parcours.gpx.trk.type} - ${calculDistance(positions).toStringAsFixed(2)} Km",
        ),
        pinNewParcour = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 30.0),
            "assets/images/markerPublic.png"),
        LatLng(positions.first.latitude, positions.first.longitude),
      ));
      listElePublic.add(eles);
      listPolylinePublic.add(setPolyline(
        i.toString(),
        positions,
        Color.fromRGBO(114, 176, 234, 1),
      ));
    }
  }
}

//Camera

final CameraPosition kPositionnementInitial = CameraPosition(
  target: LatLng(45.764043, 4.835659),
  zoom: 8,
);

//condition avec des étendue différente qui sont définir (en dessous de 10km alors zoom=12   /   eentre 10 et 50 alors zoom=9)
final CameraPosition kPositionnementMap = CameraPosition(
    target: LatLng(parcourCreat[(parcourCreat.length) ~/ 2].latitude,
        parcourCreat[(parcourCreat.length) ~/ 2].longitude),
    zoom: 11);

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

calculEle(List<double> listParcour) {
  var positif = 0.0;
  var negatif = 0.0;

  for (var y = 0; y < listParcour.length - 1; y++) {
    if (listParcour[y] > listParcour[y + 1]) {
      negatif -= listParcour[y] - listParcour[y + 1];
      [y - 1];
    } else if (listParcour[y] < listParcour[y + 1]) {
      positif += listParcour[y] - listParcour[y + 1];
      [y - 1];
    }
    return [positif, negatif];
  }
}
