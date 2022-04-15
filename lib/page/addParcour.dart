import '../flutter_flow/flutter_flow_choice_chips.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projet_developement_nesquik/auth/firebase_user_provider.dart';
import 'package:projet_developement_nesquik/backend/Parcours.dart';
import 'package:projet_developement_nesquik/backend/database.dart';
import 'package:projet_developement_nesquik/page/map.dart';
import '../backend/loader.dart';

class AddParcour extends StatefulWidget {
  AddParcour({Key key, this.dataLocation, this.dataElevation, this.jsonData})
      : super(key: key);
  final String jsonData;
  final List<LatLng> dataLocation;
  final List<double> dataElevation;

  @override
  _AddParcour createState() => _AddParcour();
}

class _AddParcour extends State<AddParcour> {
  String choiceChipsValue;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _controller;
  TextEditingController titleController;
  TextEditingController descriptionController;
  AddParcours parcours = AddParcours();
  bool protected = false;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('friends', arrayContains: currentUser.user.uid)
      .snapshots();

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    //affichage parcours sur preview
    lines.add(
      setPolyline("polID", parcourCreat, Color.fromARGB(255, 53, 53, 53)),
    );

    //affichage marker sur preview
    points.add(
      setMarker(
        MarkerId(
          parcours.title,
        ),
        InfoWindow(
          title: parcours.title,
          snippet:
              "${!sportType ? "Bike" : "Motorbike"} - ${calculDistance(parcourCreat).toStringAsFixed(2)} Km",
        ),
        BitmapDescriptor.defaultMarkerWithHue(240),
        LatLng(parcourCreat[0].latitude, parcourCreat[0].longitude),
      ),
    );
    super.initState();
  }

  Color getColor(Set<MaterialState> states) {
    return Color(0xFF72B0EA);
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    //calcul et mise a jour de la distance du parcour
    setState(() {
      parcours.distance = calculDistance(widget.dataLocation);
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF72B0EA),
        automaticallyImplyLeading: false,
        title: Text(
          'Votre Parcours',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Lexend Deca',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: IconButton(
              iconSize: 48,
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: _buildGoogleMap(context),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
                child: TextFormField(
                  controller: titleController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Titre',
                    hintStyle: FlutterFlowTheme.of(context).title2.override(
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(133, 97, 97, 97),
                        ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x2472B0EA),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x2472B0EA),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).title2.override(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(200, 0, 0, 0),
                      ),
                  textAlign: TextAlign.start,
                  onChanged: (val) => setState(() {
                    parcours.title = titleController.text;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un titre';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: 350,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFF72B0EA),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Color(0x8757636C),
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 10, 10, 0),
                            width: 150,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Temps",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 176, 176, 176),
                                    )),
                                SizedBox(height: 3),
                                Text(
                                  formatTime(chrono),
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        letterSpacing: .5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 10, 10, 0),
                            width: 150,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Distance",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 176, 176, 176),
                                    )),
                                SizedBox(height: 3),
                                Text(
                                  "${parcours.distance.toStringAsFixed(2)} Km",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        letterSpacing: .5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(children: [
                            Container(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              width: 150,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("D+",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 176, 176, 176),
                                      )),
                                  Text(
                                    "${calculEle(widget.dataElevation)[0].toStringAsFixed(2)}m",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          letterSpacing: .5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              width: 150,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("D-",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 176, 176, 176),
                                      )),
                                  Text(
                                    "${calculEle(widget.dataElevation)[1].toStringAsFixed(2)}m",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          letterSpacing: .5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                          Container(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 10, 10, 0),
                            width: 150,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("V/Moyenne",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 176, 176, 176),
                                    )),
                                SizedBox(height: 3),
                                Text(
                                  "${((parcours.distance / chrono) * 3.6e+6).toStringAsFixed(2)} Km/h",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        letterSpacing: .5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(28, 35, 0, 20),
                //3 état du bt : private / protected / public
                child: FlutterFlowChoiceChips(
                  initiallySelected: ["Privé"],
                  options: [
                    ChipData('Privé', Icons.privacy_tip),
                    ChipData('Protégé', Icons.shield),
                    ChipData('Public', Icons.public)
                  ],
                  onChanged: (val) {
                    switch (val.first) {
                      case 'Privé':
                        setState(() => parcours.type = "private");
                        setState(() => protected = false);
                        setState(() => parcours.shareTo.clear());
                        break;
                      case 'Protégé':
                        setState(() => parcours.type = "protected");
                        setState(() => protected = true);
                        break;
                      case 'Public':
                        setState(() => parcours.type = "public");
                        setState(() => protected = false);
                        setState(() => parcours.shareTo.clear());
                        break;
                    }
                  },
                  selectedChipStyle: ChipStyle(
                    backgroundColor: Color(0xFF487DAE),
                    textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                    iconColor: Colors.white,
                    iconSize: 20,
                    elevation: 4,
                  ),
                  unselectedChipStyle: ChipStyle(
                    backgroundColor: Colors.white,
                    textStyle: FlutterFlowTheme.of(context).bodyText2.override(
                          fontFamily: 'Poppins',
                          color: Color(0xFF262D34),
                        ),
                    iconColor: Color(0xFF487DAE),
                    iconSize: 18,
                    elevation: 4,
                  ),
                  chipSpacing: 20,
                  multiselect: false,
                ),
              ),
              Visibility(
                maintainSize: protected,
                maintainAnimation: protected,
                maintainState: protected,
                visible: protected,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ColorLoader(
                            [Colors.black, Colors.white, Colors.blue],
                            Duration(seconds: 3));
                      }

                      return ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          return Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 8, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 60,
                                          height: 60,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 40,
                                            color: Color(0xFF72B0EA),
                                          )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            data['pseudo'],
                                            style: FlutterFlowTheme.of(context)
                                                .subtitle1
                                                .override(
                                                  fontFamily: 'Lexend Deca',
                                                  color: Color(0xFF15212B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 4, 0),
                                              child: Text(
                                                data['email'],
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyText2
                                                    .override(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF72B0EA),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
                                        value: parcours.shareTo
                                            .contains(document.id),
                                        onChanged: (bool value) {
                                          setState(() {
                                            parcours.shareTo
                                                    .contains(document.id)
                                                ? parcours.shareTo
                                                    .remove(document.id)
                                                : parcours.shareTo
                                                    .add(document.id);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                child: TextFormField(
                  controller: descriptionController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Description...',
                    hintStyle: FlutterFlowTheme.of(context).bodyText2.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF8B97A2),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDBE2E7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDBE2E7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                  ),
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  onChanged: (val) => setState(() {
                    parcours.description = descriptionController.text;
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                child: FFButtonWidget(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enregistrement ...')),
                      );

                      var type;
                      switch (parcours.type) {
                        case "public":
                          type = "Public";
                          break;
                        case "protected":
                          type = "Protected";
                          break;
                        case "private":
                          type = "Private";
                          break;
                      }
                      print(type);
                      parcours.temps = formatTime(chrono);
                      parcours.vitesse = (parcours.distance / chrono) * 3.6e+6;
                      parcours.denivele.add(calculEle(widget.dataElevation)[0]);
                      parcours.denivele.add(calculEle(widget.dataElevation)[1]);
                      parcours.date = DateFormat.yMMMEd('fr')
                          .add_jm()
                          .format(DateTime.now());
                      parcours.startPoint.add(widget.dataLocation[0].latitude);
                      parcours.startPoint.add(widget.dataLocation[0].longitude);
                      parcours.creationDate =
                          new DateTime.now().microsecondsSinceEpoch;
                      DatabaseService database = DatabaseService();
                      database.UploadToStorage("parcours${type}",
                          parcours.title, widget.jsonData, parcours, context);
                    }
                  },
                  text: 'Enregistrer',
                  options: FFButtonOptions(
                    width: 200,
                    height: 50,
                    color: Color(0xFF72B0EA),
                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                          fontFamily: 'Lexend Deca',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Polyline> lines = {};
  Set<Marker> points = {};

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      child: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        initialCameraPosition: kPositionnementMap,
        markers: points,
        polylines: lines,
      ),
    );
  }
}

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}
