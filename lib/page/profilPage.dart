import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProfilOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

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
    const begin = Offset(0.0, -0.95);
    const end = Offset.zero;
    // You can add your own animations for the overlay content
    var tween = Tween(begin: begin, end: end);
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
