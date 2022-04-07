import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/services.dart';
import 'Parcour.dart';
import 'map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_developement_nesquik/page/addParcour.dart';
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
  int kCooldownLong_ms = 700;
  double kButtonSize = 100;
  int _counter = 0;
  double _cooldown = 0;
  int _cooldownStarted = DateTime.now().millisecondsSinceEpoch;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                    label: !activitie ? Text("Bike") : Text("Motorbike"),
                    icon: !activitie
                        ? Icon(Icons.pedal_bike)
                        : Icon(Icons.motorcycle_rounded),
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(114, 176, 234, 1),
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
                      if (_protection == 3) {
                        affichagePublic();
                        print("affichagePublic()");

                        setState(() {
                          _protection = 1;
                        });
                        print(_protection);
                      } else if (_protection == 1) {
                        affichageProtected();
                        print("affichageProtected()");
                        setState(() {
                          _protection = 2;
                        });
                        print(_protection);
                      } else if (_protection == 2) {
                        affichagePrivate();
                        print("affichagePrivate()");
                        setState(() {
                          _protection = 3;
                        });
                        print(_protection);
                      }
                    },
                    icon: _protection == 1
                        ? Icon(Icons.lock_open)
                        : _protection == 2
                            ? Icon(Icons.shield)
                            : Icon(Icons.lock),
                    label: _protection == 1
                        ? Text("Public")
                        : _protection == 2
                            ? Text("Protégé")
                            : Text("Privé"),
                    elevation: 0,
                    backgroundColor: _protection == 1
                        ? Color.fromARGB(255, 40, 151, 60)
                        : _protection == 2
                            ? Color.fromARGB(255, 185, 187, 65)
                            : Color.fromARGB(255, 143, 11, 11),
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
                  child: SizedBox(
                      width: kButtonSize,
                      height: kButtonSize,
                      child: TapDebouncer(
                        onTap: () async {
                          _startCooldownIndicator(kCooldownLong_ms);

                          _incrementCounter();
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
                          await Future<void>.delayed(
                            Duration(milliseconds: kCooldownLong_ms),
                          );
                        },
                        builder: (_, TapDebouncerFunc onTap) {
                          return FloatingActionButton.extended(
                            heroTag: "OptionBtn3",
                            onPressed: onTap,
                            label: !geoloc ? Text("OFF") : Text("ON"),
                            icon: !geoloc
                                ? Icon(Icons.location_off)
                                : Icon(Icons.location_on),
                            elevation: 0,
                            backgroundColor: !geoloc
                                ? Color.fromARGB(255, 190, 69, 69)
                                : Color.fromRGBO(114, 176, 234, 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(20)),
                            ),
                          );
                        },
                      )),
                ))
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
                  print("object");
                  setState(() {
                    geoloc2 = false;
                  });
                  getCoordoFromPos();
                  if (_protection == 1) {
                    affichagePublic();
                  } else if (_protection == 2) {
                    affichageProtected();
                  } else if (_protection == 3) {
                    affichagePrivate();
                  }
                }
              },
              label: !geoloc2 ? Text("GO") : Text("STOP"),
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
    google.LatLng latlng =
        google.LatLng(newLocalData.latitude, newLocalData.longitude);
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
                    target: google.LatLng(
                        newLocalData.latitude, newLocalData.longitude),
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

  List<Trkpt> maurice = [];

  void getCoordoFromPos() async {
    if (geoloc2 == false) {
      _locationForRecord.cancel();
      Trkseg jack = new Trkseg(maurice);
      Trk alain = new Trk("alain", "Cycling", jack);
      Gpx jp = new Gpx(alain);
      Parcour jean = new Parcour(jp);
      var greg = jean.toJson();
      var erve = jsonEncode(greg);
      _write(erve);
      validateCoordo();
    } else {
      parcourCreat.clear();
      elevationCreat.clear();
      _locationForRecord =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        parcourCreat.add(LatLng(newLocalData.latitude, newLocalData.longitude));
        elevationCreat.add(newLocalData.altitude);
        Trkpt paul = new Trkpt(newLocalData.latitude.toString(),
            newLocalData.latitude.toString(), newLocalData.altitude.toString());
        maurice.add(paul);
      });
    }
  }

  _write(String text) async {
    print("in _write");
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }

  void validateCoordo() async {
    Polyline polyline = setPolyline(
      "romuald",
      parcourCreat,
      Color.fromARGB(255, 224, 78, 78),
    );
    listPolylinePrivate.add(polyline);
    listMarkerPrivate.add(
      setMarker(
        MarkerId("romuald"),
        InfoWindow(
          title: "romuald",
          snippet:
              "Cycling - ${calculDistance(parcourCreat).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarker,
        LatLng(parcourCreat[0].latitude, parcourCreat[0].longitude),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddParcour(
                dataLocation: parcourCreat,
                dataElevation: elevationCreat,
              )),
    );
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  void _startCooldownIndicator(int timeMs) {
    _cooldownStarted = DateTime.now().millisecondsSinceEpoch;
    _updateCooldown(timeMs);
  }

  void _updateCooldown(int timeMs) {
    final int current = DateTime.now().millisecondsSinceEpoch;
    int delta = current - _cooldownStarted;
    if (delta > timeMs) {
      delta = timeMs;
    }

    setState(() {
      _cooldown = delta.roundToDouble() / timeMs;
    });

    Future<void>(() {
      if (delta < timeMs) {
        _updateCooldown(timeMs);
      } else {
        setState(() {
          _cooldown = 0.0;
        });
      }
    });
  }
}
