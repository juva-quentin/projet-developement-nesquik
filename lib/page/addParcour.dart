import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_developement_nesquik/backend/Parcours.dart';
import 'package:projet_developement_nesquik/backend/schema/database.dart';
import 'package:projet_developement_nesquik/page/map.dart';
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
            )
          ]),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                                color: Colors.white,
                                width: 170,
                                height: 50,
                                child: Column(
                                  children: [
                                    Text("Temps"),
                                  ],
                                ),
                              ),
                              Container(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 170,
                                height: 50,
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
                                color: Colors.yellow,
                                width: 150,
                                height: 60,
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
                                height: 60,
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
                          switch (val.first) {
                            case 'Privée':
                              setState(() => parcours.type = "private");
                              break;
                            case 'Protégée':
                              setState(() => parcours.type = "protected");
                              break;
                            case 'Public':
                              setState(() => parcours.type = "public");
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
                    var type;
                    switch (parcours.type) {
                      case "Public":
                        type = "Public";
                        break;
                      case "Protégée":
                        type = "Protected";
                        break;
                      case "Privée":
                        type = "Private";
                        break;
                      default:
                        type = "Private";
                        break;
                    }
                    print(parcours.title);
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
