import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:projet_developement_nesquik/page/map.dart';

import 'package:projet_developement_nesquik/page/profilPage.dart';

class MapSample extends StatefulWidget {
  @override
  MapSampleState createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(ProfilOverlay());
  }

  Set<Polyline> lines = {};
  Set<Marker> points = {};

  @override
  void initState() {
    super.initState();
    tt();
    var flag = 0;
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
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: kPositionnementInitial,
        markers: points,
        polylines: lines,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
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
    return Stack(
      children: [
        Positioned(
            width: 130,
            height: 55,
            left: 85,
            bottom: 130,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 0.65, color: Colors.black),
                  bottom: BorderSide(width: 0.7, color: Colors.black),
                ),
              ),
              child: FloatingActionButton.extended(
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
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0)),
                ),
              ),
            )),
        Positioned(
            width: 130,
            height: 55,
            left: 215,
            bottom: 130,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.7, color: Colors.black),
                ),
              ),
              child: FloatingActionButton.extended(
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
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
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
                onPressed: () {
                  print("pressBt3");
                },
                label: Text("3"),
                icon: Icon(Icons.wifi),
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 183, 190, 197),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20)),
                ),
              ),
            )),
        Positioned(
            width: 130,
            height: 55,
            left: 215,
            bottom: 75,
            child: Container(
              child: FloatingActionButton.extended(
                onPressed: () {
                  print("pressBt4");
                },
                label: Text("4"),
                extendedTextStyle: TextStyle(color: Colors.black),
                icon: Icon(Icons.location_searching),
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
      ],
    );
  }

  Widget _buildShadowOptionBox() {
    return Positioned(
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
    );
  }

  Widget _buildGoBtn() {
    return Positioned(
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
    );
  }

  var flag = 0;

  void affichagePrivate() {
    if (flag != 1) {
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
    flag = 1;
  }

  void affichageProtected() {
    if (flag != 2) {
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
    flag = 2;
  }

  void affichagePublic() {
    if (flag != 3) {
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
    flag = 3;
  }
}
