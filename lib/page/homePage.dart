import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_developement_nesquik/page/map.dart';
import 'package:location/location.dart' as loc;
import 'package:projet_developement_nesquik/page/profilPage.dart';

class MapSample extends StatefulWidget {
  @override
  MapSampleState createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController _controller;
  StreamSubscription _locationSubscription;
  StreamSubscription _locationForRecord;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  bool geoloc = false;
  bool geoloc2 = false;
  bool activitie = false;
  int _protection = 1;
  final loc.Location location = loc.Location();

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(ProfilOverlay());
  }

  Set<Polyline> lines = {};
  Set<Marker> points = {};

  var _visible = true;
  @override
  void initState() {
    getLinksStorageParcours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGoogleMap(context),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          _buildCommunityBtn(),
          _buildProfilBtn(),
          _buildShadowOptionBox(),
          _buildOptionsBtn(),
          _buildGoBtn(),
        ],
      ),
    );
  }

//build

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      child: GoogleMap(
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            _controller = controller;
          });
        },
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        initialCameraPosition: kPositionnementInitial,
        markers: points,
        polylines: lines,
      ),
    );
  }

  Widget _buildCommunityBtn() {
    return Positioned(
      left: 40,
      top: 90,
      child: Container(
        width: 160,
        height: 55,
        child: FloatingActionButton.extended(
          heroTag: "CommunityBtn",
          onPressed: () {
            print(listPolylinePrivate.length);
          },
          label: Text("Community"),
          icon: Icon(Icons.connect_without_contact_sharp),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          backgroundColor: Color.fromRGBO(114, 176, 234, 1),
        ),
      ),
    );
  }

  Widget _buildProfilBtn() {
    return Positioned(
      right: 0,
      top: 90,
      child: Container(
        width: 160,
        height: 55,
        // margin: EdgeInsets.all(10),
        child: FloatingActionButton.extended(
          heroTag: "profil",
          onPressed: () {
            _showOverlay(context);
          },
          label: const Text("My Profil"),
          icon: Icon(Icons.account_box_rounded),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          backgroundColor: Color.fromRGBO(114, 176, 234, 1),
        ),
      ),
    );
  }

  Widget _buildOptionsBtn() {
    return Visibility(
        visible: _visible,
        child: Stack(
          children: [
            Positioned(
                width: 260,
                height: 55,
                left: 85,
                bottom: 130,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      // right: BorderSide(width: 0.65, color: Colors.black),
                      bottom: BorderSide(width: 0.7, color: Colors.black),
                    ),
                  ),
                  child: FloatingActionButton.extended(
                    heroTag: "OptionBtn1",
                    onPressed: () {
                      print("pressBt1");
                      if (activitie == false) {
                        setState(() {
                          activitie = true;
                        });
                      } else {
                        setState(() {
                          activitie = false;
                        });
                      }
                    },
                    label: !activitie ? Text("Bike") : Text("Motor"),
                    icon: !activitie
                        ? Icon(Icons.pedal_bike)
                        : Icon(Icons.motorcycle_rounded),
                    elevation: 0,
                    backgroundColor: !activitie
                        ? Color.fromARGB(255, 143, 11, 11)
                        : Color.fromARGB(255, 40, 151, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0)),
                    ),
                  ),
                )),
            Positioned(
                width: 130,
                height: 55,
                left: 215,
                bottom: 75,
                child: Container(
                  decoration: BoxDecoration(
                      // border: Border(
                      //   bottom: BorderSide(width: 0.7, color: Colors.black),
                      // ),
                      ),
                  child: FloatingActionButton.extended(
                    heroTag: "OptionBtn2",
                    onPressed: () {
                      print(_protection);
                      if (_protection == 1) {
                        affichagePublic();
                        setState(() {
                          _protection = 2;
                        });
                      } else if (_protection == 2) {
                        affichageProtected();
                        setState(() {
                          _protection = 3;
                        });
                      } else {
                        affichagePrivate();
                        setState(() {
                          _protection = 1;
                        });
                      }
                    },
                    icon: _protection == 1
                        ? Icon(Icons.lock)
                        : _protection == 2
                            ? Icon(Icons.shield)
                            : Icon(Icons.lock_open),
                    label: _protection == 1
                        ? Text("Private")
                        : _protection == 2
                            ? Text("Protected")
                            : Text("Public"),
                    elevation: 0,
                    backgroundColor: _protection == 1
                        ? Color.fromARGB(255, 143, 11, 11)
                        : _protection == 2
                            ? Color.fromARGB(255, 185, 187, 65)
                            : Color.fromARGB(255, 40, 151, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(0)),
                    ),
                  ),
                )),
            Positioned(
                width: 130,
                height: 55,
                left: 85,
                bottom: 75,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 0.65, color: Colors.black),
                    ),
                  ),
                  child: FloatingActionButton.extended(
                    heroTag: "OptionBtn3",
                    onPressed: () {
                      print(
                          "------------------------------:listPolylinePrivate.length");
                      if (geoloc == false) {
                        setState(() {
                          geoloc = true;
                        });
                        getCurrentLocation();
                      } else {
                        setState(() {
                          geoloc = false;
                        });
                        getCurrentLocation();
                      }
                    },
                    label: !geoloc ? Text("OFF") : Text("ON"),
                    icon: !geoloc
                        ? Icon(Icons.location_off)
                        : Icon(Icons.location_on),
                    elevation: 0,
                    backgroundColor: !geoloc
                        ? Color.fromARGB(255, 143, 11, 11)
                        : Color.fromARGB(255, 40, 151, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(20)),
                    ),
                  ),
                )),
          ],
        ));
  }

  Widget _buildShadowOptionBox() {
    return Visibility(
        visible: _visible,
        child: Positioned(
          height: 110,
          width: 260,
          bottom: 75,
          left: 85,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 183, 190, 197),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 139, 139, 139),
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildGoBtn() {
    return Visibility(
        visible: _visible,
        child: Positioned(
          width: 300,
          left: 65,
          bottom: 10,
          child: Container(
            width: 150,
            child: FloatingActionButton.extended(
              onPressed: () {
                print("pressGO");
                if (geoloc2 == false) {
                  setState(() {
                    geoloc2 = true;
                  });
                  getCoordoFromPos();
                } else {
                  setState(() {
                    geoloc2 = false;
                  });
                  getCoordoFromPos();
                }
              },
              label: !geoloc2 ? Text("GO") : Text("GO"),
              elevation: 0,
              backgroundColor: !geoloc2
                  ? Color.fromRGBO(114, 176, 234, 1)
                  : Color.fromARGB(255, 190, 69, 69),
              extendedTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 139, 139, 139),
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
          ),
        ));
  }

  void affichagePrivate() {
    if (lines.isNotEmpty) {
      lines.clear();
      points.clear();
    }

    setState(() {
      for (var item in listPolylinePrivate) {
        lines.add(item);
        print(lines.last.polylineId);
      }
      for (var item2 in listMarkerPrivate) {
        points.add(item2);
      }
    });
  }

  void affichageProtected() {
    if (lines.isNotEmpty) {
      lines.clear();
      points.clear();
    }
    setState(() {
      for (var item in listPolylineProtected) {
        lines.add(item);
      }
      for (var item2 in listMarkerProtected) {
        points.add(item2);
      }
    });
  }

  void affichagePublic() {
    if (lines.isNotEmpty) {
      lines.clear();
      points.clear();
    }
    setState(() {
      for (var item in listPolylinePublic) {
        lines.add(item);
      }
      for (var item2 in listMarkerPublic) {
        points.add(item2);
      }
    });
  }

  void updateMarkerAndCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5));
      circle = Circle(
          circleId: CircleId("circle"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    if (geoloc == false) {
      _locationSubscription.cancel();
    } else {
      try {
        var location = await _locationTracker.getLocation();

        updateMarkerAndCircle(location);

        _locationSubscription =
            _locationTracker.onLocationChanged.listen((newLocalData) {
          if (_controller != null) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    bearing: newLocalData.heading,
                    target:
                        LatLng(newLocalData.latitude, newLocalData.longitude),
                    zoom: 18.00)));
            updateMarkerAndCircle(newLocalData);
          }
        });
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          debugPrint("Permission Denied");
        }
      }
    }
  }

  void getCoordoFromPos() async {
    if (geoloc2 == false) {
      _locationForRecord.cancel();
      for (var item in parcourCreat) {
        print(item);
      }
      listPolylinePrivate.add(setPolyline(
        "romuald",
        parcourCreat,
        Color.fromARGB(255, 224, 78, 78),
      ));
      listMarkerPrivate.add(
        setMarker(
          MarkerId("paul "),
          InfoWindow(
            title: "romualdTrack",
            snippet:
                "Cycling - ${calculDistance(parcourCreat).toStringAsFixed(2)} Km",
          ),
          BitmapDescriptor.defaultMarker,
          LatLng(parcourCreat[0].latitude, parcourCreat[0].longitude),
        ),
      );
      parcourCreat.clear();
    } else {
      _locationForRecord = _locationTracker.onLocationChanged.listen((result) {
        parcourCreat.add(LatLng(result.latitude, result.longitude));
      });
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }
}
