import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:projet_developement_nesquik/backend/database.dart';
import 'package:projet_developement_nesquik/page/map.dart';
import 'package:http/http.dart' as http;

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart' as fltflow;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Parcour.dart';

Set<Polyline> lines2 = {};
Set<Marker> points2 = {};
List<LatLng> positions = [];

class CourseDetails extends StatefulWidget {
  CourseDetails({Key key, this.data, this.document}) : super(key: key);

  final DocumentSnapshot<Object> document;
  final Map<String, dynamic> data;
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  @override
  void initState() {
    getListPositions();

    super.initState();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService database = DatabaseService();
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          database.DeleteOneParcours(widget.document.id, context, data);
        },
        backgroundColor: Color.fromARGB(255, 187, 1, 1),
        elevation: 8,
        label: Text(
          'Supprimer',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: 'Lexend Deca',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
        ),
        icon: Icon(Icons.delete_forever),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 240,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Stack(
                    alignment: AlignmentDirectional(-0.95, -0.7),
                    children: [
                      GoogleMap(
                        // rotateGesturesEnabled: false,
                        // scrollGesturesEnabled: false,
                        // zoomGesturesEnabled: false,
                        // zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        // myLocationEnabled: false,
                        // myLocationButtonEnabled: false,
                        // mapToolbarEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                positions[0].latitude, positions[0].longitude),
                            zoom: 10),
                        markers: points2,
                        polylines: lines2,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.95, -0.55),
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color.fromARGB(255, 255, 255, 255),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF0669A9),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Titre',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF8B97A2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        data["title"],
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).title2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Etendue',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF8B97A2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        data['type'],
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).subtitle1.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF151B1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distance',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          "${data['distance'].toStringAsFixed(2)}Km",
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).subtitle1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF151B1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temps',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          data["temps"],
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).subtitle1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF151B1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vitesse Moyenne',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          "${data["vitesse"].toStringAsFixed(2)}Km/h",
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF151B1E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dénivelé Positif',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF8B97A2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        "${data['denivele'][0].toString()}m",
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).subtitle1.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF151B1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dénivelé Positif',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          "${data['denivele'][1].toString()}m",
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).subtitle1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF151B1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          data["date"],
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF151B1E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          data["description"],
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF151B1E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getListPositions() async {
    String url = widget.data['address'];
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      var parcours = Parcour.fromJson(resp);
      for (var y = 0; y < parcours.gpx.trk.trkseg.trkpt.length; y++) {
        double lat = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lat);
        double lng = double.parse(parcours.gpx.trk.trkseg.trkpt[y].lon);
        positions.add(LatLng(lat, lng));
      }
    }
    setState(() {
      lines2.clear();
      lines2.add(setPolyline(
        widget.data["title"],
        positions,
        Color.fromARGB(255, 55, 55, 55),
      ));
      points2.clear();
      points2.add(
        setMarker(
          MarkerId(widget.data['title']),
          InfoWindow(
            title: "${widget.data["title"]}",
            snippet:
                "${widget.data["type"]} - ${widget.data["distance"].toStringAsFixed(2)} Km",
          ),
          BitmapDescriptor.defaultMarker,
          LatLng(positions[0].latitude, positions[0].longitude),
        ),
      );
    });
  }
}
