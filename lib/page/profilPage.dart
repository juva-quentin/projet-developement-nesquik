import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:projet_developement_nesquik/auth/auth_util.dart';
import 'package:intl/intl.dart';

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
        bottom: false,
        child: _buildOverlayContent(context),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, -0.95);
    const end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

@override
Widget _buildOverlayContent(BuildContext context) {
  return Column(
    children: [
      Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.10),
          child: _buildFinalTopOverlayContent(context)),
      _buildBottomOverlay(context)
    ],
  );
}

@override
Widget _buildFinalTopOverlayContent(BuildContext context) {
  final top = MediaQuery.of(context).size.height * 0.22 -
      MediaQuery.of(context).size.height * 0.13 / 2;
  return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
    _buildTopOverlay(context),
    Positioned(
      top: MediaQuery.of(context).size.height * 0.04,
      child: IconButton(
        hoverColor: Colors.transparent,
        icon: Icon(
          Icons.keyboard_arrow_up,
          color: Colors.black,
          size: 40,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    Positioned(
        left: MediaQuery.of(context).size.width * 0.10,
        top: top - MediaQuery.of(context).size.height * 0.15 / 2.5,
        child: _buildNameOverlay()),
    Positioned(top: top, child: _buildObjectifOverlay(context))
  ]);
}

@override
Widget _buildTopOverlay(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.22,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 1, 132, 255),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
    ),
  );
}

@override
Widget _buildNameOverlay() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUserUid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.all(3),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.account_circle_rounded, size: 40),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text("${data['pseudo']}",
                        style: GoogleFonts.sen(
                            textStyle: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ))))
              ],
            ),
          );
        }

        return Text("loading");
      });
}

@override
Widget _buildObjectifOverlay(BuildContext context) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int nbrDays() {
    var date = DateFormat.EEEE().format(DateTime.now());
    print(date);
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Saturday",
      'Sunday'
    ];
    var index1 = days.indexWhere((element) => element == date);
    if (index1 >= 0) {
      return 7 - (index1 + 1);
    }
  }

  double _advencement(int objectif, int advencement) {
    var result = (advencement * 100) / objectif;
    if (result <= 0) {
      return 0;
    } else if (result > 100) {
      return 100;
    } else {
      return result;
    }
  }

  return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUserUid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          return Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                Row(children: [
                  Text("Objectif de la semaine: ",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ))),
                  Text("${data['objectif']}KM",
                      style: GoogleFonts.sen(
                          textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 81, 255),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ))),
                ]),
                Spacer(),
                Container(
                  child: Column(children: [
                    Row(
                      children: [
                        Text("${data['tdp']}KM",
                            style: GoogleFonts.sen(
                                textStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ))),
                        Spacer(),
                        Text("Plus que ${nbrDays()} jours..."),
                      ],
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 2500,
                      percent:
                          _advencement(data['objectif'], data['tdp']) / 100,
                      center: Text(_advencement(data['objectif'], data['tdp'])
                              .toString() +
                          "%"),
                      progressColor: Color.fromARGB(255, 0, 140, 255),
                    ),
                  ]),
                )
              ]));
        }

        return Text("loading");
      });
}

@override
Widget _buildBottomOverlay(BuildContext context) {
  var choices = [
    "Mes courses",
    "Mes favoris",
    "Mes amis",
    "Mes paramètres",
    "Mes statistiques",
  ];
  return Column(
    children: choices
        .map((item) => new Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: new Container(
                width: 250,
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 1, 132, 255),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: new Text(item,
                    style: GoogleFonts.sen(
                        textStyle: TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ))))))
        .toList(),
  );
}
