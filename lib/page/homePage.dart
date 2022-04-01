import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  bool geoloc = false;
  final loc.Location location = loc.Location();

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(ProfilOverlay());
  }

  Set<Polyline> lines = {};
  Set<Marker> points = {};

  var _visible = true;
  @override
  void initState() {
    super.initState();
    tt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGoogleMap(context),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          _build1Btn(),
          _build2Btn(),
          _build3Btn(),
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
        initialCameraPosition: kPositionnementInitial,
        markers: points,
        polylines: lines,
      ),
    );
  }

  Widget _build1Btn() {
    return Positioned(
      left: 40,
      top: 150,
      child: Container(
        width: 50,
        height: 55,
        child: FloatingActionButton.extended(
          heroTag: "private",
          onPressed: () {
            affichagePrivate();
          },
          label: Text("1"),
          backgroundColor: Color.fromRGBO(114, 176, 234, 1),
        ),
      ),
    );
  }

  Widget _build2Btn() {
    return Positioned(
      left: 150,
      top: 150,
      child: Container(
        width: 50,
        height: 55,
        child: FloatingActionButton.extended(
          heroTag: "protected",
          onPressed: () {
            affichageProtected();
          },
          label: Text("2"),
          backgroundColor: Color.fromARGB(255, 224, 78, 78),
        ),
      ),
    );
  }

  Widget _build3Btn() {
    return Positioned(
      left: 250,
      top: 150,
      child: Container(
        width: 50,
        height: 55,
        child: FloatingActionButton.extended(
          heroTag: "public",
          onPressed: () {
            affichagePublic();
          },
          label: Text("3"),
          backgroundColor: Color.fromARGB(255, 79, 219, 51),
        ),
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
          onPressed: () {},
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
                      // calculDistance();
                    },
                    icon: Icon(Icons.pedal_bike),
                    label: Text("1"),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 183, 190, 197),
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
                      print("pressBt2");
                      // calculDistance();
                    },
                    icon: Icon(Icons.lock),
                    label: Text("2"),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 183, 190, 197),
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
                      print("pressBt3");
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
            // Positioned(
            //     width: 130,
            //     height: 55,
            //     left: 215,
            //     bottom: 75,
            //     child: Container(
            //       child: FloatingActionButton.extended(
            //         heroTag: "OptionBtn4",
            //         onPressed: () {
            //           getCurrentLocation();
            //         },
            //         label: Text("4"),
            //         extendedTextStyle: TextStyle(color: Colors.black),
            //         icon: Icon(Icons.location_searching),
            //         elevation: 0,
            //         backgroundColor: Color.fromARGB(255, 183, 190, 197),
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(0),
            //               topRight: Radius.circular(0),
            //               bottomRight: Radius.circular(20),
            //               bottomLeft: Radius.circular(0)),
            //         ),
            //       ),
            //     )),
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
              onPressed: () {},
              label: Text("GO"),
              backgroundColor: Color.fromRGBO(114, 176, 234, 1),
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
      for (var i = 0; i < lines.length; i++) {
        lines.remove(lines.first);
        for (var y = 0; y < points.length; y++) {
          points.remove(points.first);
        }
      }
    }
    setState(() {
      for (var item in listPolylinePrivate) {
        lines.add(item);
        for (var item2 in listMarkerPrivate) {
          points.add(item2);
        }
      }
    });
  }

  void affichageProtected() {
    if (lines.isNotEmpty) {
      for (var i = 0; i < lines.length; i++) {
        lines.remove(lines.first);
        for (var y = 0; y < points.length; y++) {
          points.remove(points.first);
        }
      }
    }
    setState(() {
      for (var item in listPolylineProtected) {
        lines.add(item);
        for (var item2 in listMarkerProtected) {
          points.add(item2);
        }
      }
    });
  }

  void affichagePublic() {
    if (lines.isNotEmpty) {
      for (var i = 0; i < lines.length; i++) {
        lines.remove(lines.first);
        for (var y = 0; y < points.length; y++) {
          points.remove(points.first);
        }
      }
    }
    setState(() {
      for (var item in listPolylinePublic) {
        lines.add(item);
        for (var item2 in listMarkerPublic) {
          points.add(item2);
        }
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
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    print(geoloc);
    if (geoloc == false) {
      _locationSubscription.cancel();
    } else {
      try {
        var location = await _locationTracker.getLocation();

        updateMarkerAndCircle(location);

        if (_locationSubscription != null) {
          _locationSubscription.cancel();
        }

        _locationSubscription =
            _locationTracker.onLocationChanged.listen((newLocalData) {
          if (_controller != null) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    bearing: 192.8334901395799,
                    target:
                        LatLng(newLocalData.latitude, newLocalData.longitude),
                    tilt: 0,
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

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }
}
