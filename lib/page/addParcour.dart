// ignore_for_file: deprecated_member_use

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
import '../flutter_flow/flutter_flow_choice_chips.dart';
import '../flutter_flow/flutter_flow_theme.dart';

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
  GoogleMapController _controller;
  TextEditingController titleController;
  TextEditingController descriptionController;
  Parcours parcours = Parcours();
  bool protected = false;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('friends', arrayContains: currentUser.user.uid)
      .snapshots();

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    lines.add(
      setPolyline(
        "polID",
        parcourCreat,
        Color.fromARGB(255, 224, 78, 78),
      ),
    );
    points.add(
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
    super.initState();
  }

  Color getColor(Set<MaterialState> states) {
    return Color(0xFF72B0EA);
  }

  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    setState(() {
      parcours.distance = calculDistance(widget.dataLocation);
    });
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF72B0EA),
          title: Text("Enregistrement Parcours"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
              ),
              onPressed: () {},
            )
          ]),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 82, 82, 82)),
                child: Center(
                  child: _buildGoogleMap(context),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Titre"),
                  onChanged: (val) => setState(() {
                    parcours.title = titleController.text;
                  }),
                ),
              ),
              Container(
                  color: Color.fromRGBO(114, 176, 234, 1),
                  alignment: Alignment.center,
                  child: Column(children: [
                    Text("Le résumé de votre Parcours",
                        style: GoogleFonts.sen(
                            textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ))),
                    SizedBox(height: 20),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Wrap(
                            spacing: 20,
                            children: [
                              Container(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 170,
                                height: 51,
                                child: Column(
                                  children: [
                                    Text("Temps"),
                                    Text(formatTime(bouuuuu)),
                                  ],
                                ),
                              ),
                              Container(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 170,
                                height: 51,
                                child: Column(
                                  children: [
                                    Text("Distance"),
                                    Text(
                                        "${parcours.distance.toStringAsFixed(2)} Km")
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 20,
                            children: [
                              Container(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 170,
                                height: 51,
                                child: Column(
                                  children: [
                                    Text("Dénivelé"),
                                    Text(
                                        "D+ = ${calculEle(widget.dataElevation)[0].toStringAsFixed(2)}\nD- = ${calculEle(widget.dataElevation)[1].toStringAsFixed(2)}")
                                  ],
                                ),
                              ),
                              Container(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 170,
                                height: 51,
                                child: Column(
                                  children: [
                                    Text("Vitesse moyenne"),
                                    Text(
                                        "${((parcours.distance / bouuuuu) * 3.6e+6).toStringAsFixed(2)}Km/h")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ])),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(60, 30, 0, 0),
                      child: FlutterFlowChoiceChips(
                        initiallySelected: ["Privée"],
                        options: [
                          ChipData('Privée'),
                          ChipData('Protégée'),
                          ChipData('Public')
                        ],
                        onChanged: (val) {
                          print(val.first);
                          print("ok");
                          print(parcours.type);
                          switch (val.first) {
                            case 'Privée':
                              setState(() => parcours.type = "private");
                              setState(() => protected = false);
                              setState(() => parcours.shareTo.clear());
                              break;
                            case 'Protégée':
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
                          textStyle:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                          iconColor: Colors.white,
                          iconSize: 20,
                          elevation: 4,
                        ),
                        unselectedChipStyle: ChipStyle(
                          backgroundColor: Colors.white,
                          textStyle:
                              FlutterFlowTheme.of(context).bodyText2.override(
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
                  ])),
              Visibility(
                maintainSize: protected,
                maintainAnimation: protected,
                maintainState: protected,
                visible: protected,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ColorLoader(
                                [Colors.black, Colors.white, Colors.blue],
                                Duration(seconds: 3));
                          }

                          return ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                data['pseudo'],
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .subtitle1
                                                    .override(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF15212B),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                          fontFamily:
                                                              'Lexend Deca',
                                                          color:
                                                              Color(0xFF72B0EA),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty
                                                .resolveWith(getColor),
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
                                                print(parcours.shareTo
                                                    .contains(document.id));
                                                print(parcours.shareTo);
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
                        })),
              ),
              Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration.collapsed(
                          hintText: "Entrer votre decription"),
                      onChanged: (val) => setState(() {
                        parcours.description = descriptionController.text;
                      }),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    print("ok");
                    print(parcours.type);
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
                    parcours.temps = formatTime(bouuuuu);
                    parcours.vitesse = (parcours.distance / bouuuuu) * 3.6e+6;
                    parcours.denivele.add(calculEle(widget.dataElevation)[0]);
                    parcours.denivele.add(calculEle(widget.dataElevation)[1]);
                    parcours.date =
                        DateFormat.yMMMEd().add_jm().format(DateTime.now());
                    DatabaseService database = DatabaseService();
                    database.UploadToStorage("parcours${type}", parcours.title,
                        widget.jsonData, parcours, context);
                    // Retourne true si le formulaire est valide, sinon false
                  },
                  child: Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ],
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
