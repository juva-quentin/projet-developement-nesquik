import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:projet_developement_nesquik/build/home_page/build_google_ap.dart';
import 'package:projet_developement_nesquik/page/profilPage.dart';
import 'package:google_fonts/google_fonts.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // ignore: prefer_final_fields
  Completer<GoogleMapController> _controller = Completer();
  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(TutorialOverlay());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      body: _buildGoogleMap(context),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          _buildCommunityBtn(),
          _buildProfilBtn(),
          // _buildPopUp(0),
          _buildShadowOptionBox(),
          _buildOptionsBtn(),
          _buildGoBtn(),
        ],
      ),
    );
  }

  //-----

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: kLyon,
        zoomControlsEnabled: false,
        markers: {
          markSainte,
          markLyon,
        },
        polylines: {
          k1erTrajet,
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
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
                  goToSainteConsorce();
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
                  goToLyon();
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
                  /*_buildPopUp(1);*/
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

//-------------

  Future<void> goToSainteConsorce() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kSainteConsorce));
  }

  Future<void> goToLyon() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLyon));
  }
}

class TutorialOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        top: false,
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Column(
            children: [
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    buildTop(context),
                    Positioned(
                      right: 10,
                      top: 40,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                                IconData(0xe16a, fontFamily: 'MaterialIcons'),
                                size: 40),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 50,
                      top: 85,
                      child: Row(
                        children: <Widget>[
                          Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),
                              size: 40),
                          Text("Thomas GAULLE",
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 17,
                              )))
                        ],
                      ),
                    ),
                    Positioned(
                      top: 130,
                      child: buildObjectifSection(context),
                    ),
                  ]),
              buildListChoice(),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTop(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.22,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          // ignore: prefer_const_constructors
          color: Color(0xFF72B0EA),
          borderRadius: BorderRadius.only(
            // ignore: prefer_const_constructors
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
      );

  Widget buildObjectifSection(BuildContext context) => Container(
      width: 300,
      height: 110,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        // ignore: prefer_const_constructors
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.only(
          // ignore: prefer_const_constructors
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Text("Objectif de la semaine: ",
                      style: GoogleFonts.sen(
                        fontSize: 17,
                      )),
                  SizedBox(width: 10),
                  Text("80Km",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF72B0EA),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(top: 15.0, left: 13.0),
              child: Row(
                children: <Widget>[
                  Text("40Km",
                      style: GoogleFonts.sen(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF484848))),
                  SizedBox(width: 120),
                  Text("plus que 2 jours ...",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF9F9A9A),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      )))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 122, 122, 122).withOpacity(1),
                        spreadRadius: 0.2,
                        blurRadius: 3,
                        offset: Offset(-3, 7), // changes position of shadow
                      ),
                    ],
                  ),
                  child: (new LinearPercentIndicator(
                    width: 280,
                    lineHeight: 14.0,
                    percent: 0.5,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ))))
        ],
      ));

  buildListChoice() => Container(
      child: Padding(
          padding: EdgeInsets.only(top: 70.0),
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              width: 220,
              height: 90,
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                color: Color(0xFF72B0EA),
                borderRadius: BorderRadius.only(
                  // ignore: prefer_const_constructors
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Mes courses",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )))),
            ),
            SizedBox(height: 20),
            Container(
              width: 220,
              height: 90,
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                color: Color(0xFF72B0EA),
                borderRadius: BorderRadius.only(
                  // ignore: prefer_const_constructors
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Mes favoris",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )))),
            ),
            SizedBox(height: 20),
            Container(
              width: 220,
              height: 90,
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                color: Color(0xFF72B0EA),
                borderRadius: BorderRadius.only(
                  // ignore: prefer_const_constructors
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Mes amis",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )))),
            ),
            SizedBox(height: 20),
            Container(
              width: 220,
              height: 90,
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                color: Color(0xFF72B0EA),
                borderRadius: BorderRadius.only(
                  // ignore: prefer_const_constructors
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Mes Paramètres",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )))),
            ),
            SizedBox(height: 20),
            Container(
              width: 220,
              height: 90,
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                color: Color(0xFF72B0EA),
                borderRadius: BorderRadius.only(
                  // ignore: prefer_const_constructors
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Mes Statistiques",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )))),
            ),
          ]))));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
