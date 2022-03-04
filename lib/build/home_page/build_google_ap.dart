import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final CameraPosition kLyon = CameraPosition(
  target: LatLng(45.764043, 4.835659),
  zoom: 11,
);

final CameraPosition kSainteConsorce = CameraPosition(
  target: LatLng(45.777, 4.69),
  zoom: 13,
);

Marker markSainte = Marker(
  markerId: MarkerId("markSainte"),
  infoWindow: InfoWindow(title: "sainte consorce"),
  icon: BitmapDescriptor.defaultMarker,
  position: LatLng(45.777, 4.69),
);
Marker markLyon = Marker(
  markerId: MarkerId("markLyon"),
  infoWindow: InfoWindow(title: "Lyon"),
  icon: BitmapDescriptor.defaultMarker,
  position: LatLng(45.764043, 4.835659),
);

final Polyline k1erTrajet = Polyline(
  polylineId: PolylineId("k1erTrajet"),
  points: [LatLng(45.764043, 4.835659), LatLng(45.777, 4.69)],
  width: 3,
  color: Colors.blue,
);
