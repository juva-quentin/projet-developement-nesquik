import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:page_transition/page_transition.dart';

import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';
import 'package:projet_developement_nesquik/backend/database.dart';
import 'package:projet_developement_nesquik/page/Community.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/services.dart';
import 'Parcour.dart';
import 'map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_developement_nesquik/page/addParcour.dart';
import 'package:projet_developement_nesquik/page/map.dart';
import 'package:location/location.dart' as loc;
import 'package:projet_developement_nesquik/page/profilPage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  int idError = 1;
  int kCooldownLong_ms = 700;
  double kButtonSize = 100;
  int _counter = 0;
  double _cooldown = 0;
  int _cooldownStarted = DateTime.now().millisecondsSinceEpoch;
  bool timerRunning = false;
  Timer timer;
  int stopwatch = 0;
  DatabaseService database = DatabaseService();

  void _startTimer() async {
    if (!timerRunning) {
      timerRunning = true;
      timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
        stopwatch = timer.tick;
      });
    } else {
      print("startTimer $stopwatch");
      bouuuuu = stopwatch;
      timer.cancel();
    }
  }

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
    database.UpdateObjectif();
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
            Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  child: Community(),
                ));
          },
          label: Text("Communauté"),
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
                      bottom: BorderSide(
                          width: 0.7,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  child: FloatingActionButton.extended(
                    heroTag: "OptionBtn1",
                    onPressed: () {
                      if (geoloc2) {
                        setState(() {
                          idError = 1;
                        });
                        showMyAlertDialog(context);
                      } else {
                        print("pressBt1");
                        if (activitie == false) {
                          setState(() {
                            activitie = true;
                            boxeeeeee = activitie;
                          });
                        } else {
                          setState(() {
                            activitie = false;
                            boxeeeeee = activitie;
                          });
                        }
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
                      if (geoloc2) {
                        setState(() {
                          idError = 2;
                        });
                        showMyAlertDialog(context);
                      } else {
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
                        ? Color.fromRGBO(114, 176, 234, 1)
                        : _protection == 2
                            ? Color.fromARGB(255, 150, 114, 234)
                            : Color.fromARGB(255, 190, 69, 69),
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
                      right: BorderSide(
                          width: 0.65,
                          color: Color.fromARGB(255, 255, 255, 255)),
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
          height: 113.5,
          width: 263.5,
          bottom: 73,
          left: 83,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 255, 255, 255),
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
            child: TapDebouncer(onTap: () async {
              _startCooldownIndicator(kCooldownLong_ms);

              _incrementCounter();
              print("pressGO");
              _startTimer();
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
              await Future<void>.delayed(
                Duration(milliseconds: kCooldownLong_ms),
              );
            }, builder: (_, TapDebouncerFunc onTap) {
              return FloatingActionButton.extended(
                onPressed: onTap,
                label: !geoloc2 ? Text("GO") : Text("STOP"),
                elevation: 0,
                backgroundColor: !geoloc2
                    ? Color(0xFF72B0EA)
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
              );
            }),
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
      print(urls_Private.length);
      for (var item in listPolylinePrivate) {
        lines.add(item);
        print(item);
      }
      print("${lines.length} --------------------");
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
      print(urls_Protected.length);
      for (var item in listPolylineProtected) {
        lines.add(item);
      }
      print("${lines.length} --------------------");
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
      print(urls_Public.length);
      for (var item in listPolylinePublic) {
        lines.add(item);
      }
      print("${lines.length} --------------------");
      for (var item2 in listMarkerPublic) {
        points.add(item2);
      }
    });
  }

  showMyAlertDialog(BuildContext context) {
    // Create AlertDialog
    if (idError == 1) {
      AlertDialog dialog = AlertDialog(
          title: Text("STOP !"),
          content: Text(
              "Vous ne pouvez pas changer de moyen de déplacement si une activité est déjà en cours !"),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop("Compris");
              },
            ),
          ]);
      Future<String> futureValue = showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
      Stream<String> stream = futureValue.asStream();
      stream.listen((String data) {}, onDone: () {
        print("Done!");
      }, onError: (error) {
        print("Error! " + error.toString());
      });
    } else {
      AlertDialog dialog = AlertDialog(
          title: Text("STOP !"),
          content: Text(
              "Vous ne pouvez pas changer de type de Parcours pendant qu\'un autre parcours est en cours !"),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop("Compris");
              },
            ),
          ]);
      Future<String> futureValue = showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
      Stream<String> stream = futureValue.asStream();
      stream.listen((String data) {}, onDone: () {
        print("Done!");
      }, onError: (error) {
        print("Error! " + error.toString());
      });
    }
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

      Trk alain = new Trk("alain", !activitie ? "Bike" : "Motorbike", jack);

      Gpx jp = new Gpx(alain);
      Parcour jean = new Parcour(jp);
      var greg = jean.toJson();
      var erve = jsonEncode(greg);
      validateCoordo(erve);
    } else {
      parcourCreat.clear();
      elevationCreat.clear();
      _locationForRecord =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        parcourCreat.add(LatLng(newLocalData.latitude, newLocalData.longitude));
        elevationCreat.add(newLocalData.altitude);
        Trkpt paul = new Trkpt(
            newLocalData.latitude.toString(),
            newLocalData.longitude.toString(),
            newLocalData.altitude.toString());
        maurice.add(paul);
      });
    }
  }

  void validateCoordo(String erve) async {
    Polyline polyline = setPolyline(
      "New Traject",
      parcourCreat,
      Color.fromARGB(255, 110, 110, 110),
    );
    print("erve: ${erve}");

    listPolylinePrivate.add(polyline);
    listMarkerPrivate.add(
      setMarker(
        MarkerId("romuald"),
        InfoWindow(
          title: "New Traject",
          snippet:
              "${!activitie ? "Bike" : "Motorbike"} - ${calculDistance(parcourCreat).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarker,
        LatLng(parcourCreat[0].latitude, parcourCreat[0].longitude),
      ),
    );
    listPolylineProtected.add(polyline);
    listMarkerProtected.add(
      setMarker(
        MarkerId("romuald"),
        InfoWindow(
          title: "New Traject",
          snippet:
              "${!activitie ? "Bike" : "Motorbike"} - ${calculDistance(parcourCreat).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarker,
        LatLng(parcourCreat[0].latitude, parcourCreat[0].longitude),
      ),
    );
    listPolylinePublic.add(polyline);
    listMarkerPublic.add(
      setMarker(
        MarkerId("romuald"),
        InfoWindow(
          title: "New Traject",
          snippet:
              "${!activitie ? "Bike" : "Motorbike"} - ${calculDistance(parcourCreat).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarker,
        LatLng(parcourCreat[0].latitude, parcourCreat[0].longitude),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddParcour(
                jsonData: erve,
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
