import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_developement_nesquik/page/map.dart';
import '../flutter_flow/flutter_flow_choice_chips.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class AddParcour extends StatefulWidget {
  AddParcour({Key key, this.dataLocation, this.dataElevation})
      : super(key: key);
  final List<LatLng> dataLocation;
  final List<double> dataElevation;
  @override
  _AddParcour createState() => _AddParcour();
}

class _AddParcour extends State<AddParcour> {
  String choiceChipsValue;
  GoogleMapController _controller;
  @override
  void initState() {
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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
            )
          ]),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "titre"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Veuillez saisir un texte';
                      }
                      return null;
                    },
                  ),
                ),
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
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: Column(children: [
                      Text("States",
                          style: GoogleFonts.sen(
                              textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                          ))),
                      SizedBox(height: 20),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          child: Column(children: [
                            Wrap(
                              spacing: 20,
                              children: [
                                Container(
                                  color: Colors.yellow,
                                  width: 170,
                                  height: 50,
                                  child: Column(
                                    children: [
                                      Text("Temps"),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(255, 89, 52, 52),
                                  width: 170,
                                  height: 50,
                                  child: Column(
                                    children: [
                                      Text("Distance"),
                                      Text(
                                          "${calculDistance(widget.dataLocation).toStringAsFixed(2)} Km")
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
                                  color: Colors.yellow,
                                  width: 150,
                                  height: 50,
                                  child: Column(
                                    children: [
                                      Text("Dénivelé"),
                                      Text(
                                          "D+ = ${calculEle(widget.dataElevation)[0].toStringAsFixed(2)}\nD- = ${calculEle(widget.dataElevation)[1].toStringAsFixed(2)}")
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(255, 153, 54, 54),
                                  width: 150,
                                  height: 50,
                                )
                              ],
                            ),
                          ])),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(37, 30, 0, 0),
                        child: FlutterFlowChoiceChips(
                          initiallySelected: [choiceChipsValue],
                          options: [
                            ChipData('Privée'),
                            ChipData('Protégée'),
                            ChipData('Public')
                          ],
                          onChanged: (val) =>
                              setState(() => choiceChipsValue = val.first),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Retourne true si le formulaire est valide, sinon false
                      if (_formKey.currentState.validate()) {
                        // Affiche le Snackbar si le formulaire est valide
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Traitement en cours')));
                      }
                    },
                    child: Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          )
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
