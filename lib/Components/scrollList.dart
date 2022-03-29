import 'package:percent_indicator/linear_percent_indicator.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class ProfilOverlay extends StatefulWidget {
//   const ProfilOverlay({Key key}) : super(key: key);

//   @override
//   _ProfilOverlay createState() => _ProfilOverlay();
// }

// class _ProfilOverlay extends State<ProfilOverlay> {
//   TextEditingController textController;
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     textController = TextEditingController();
//   }

//   @override
Widget buildProfilOverlay(BuildContext context) {
  return SingleChildScrollView(
      child: Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        height: MediaQuery.of(context).size.height * 1,
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(-0.39, -1.00),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  color: Color(0xFF72B0EA),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 70, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              'https://picsum.photos/seed/702/600',
                            ),
                          ),
                          Text(
                            'Quentin JUVET',
                            style: FlutterFlowTheme.of(context).bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 27, 0, 30),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 15, 10, 25),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Objectif de la semaine: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                    Text(
                                      '80 KM',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '40KM',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                    Text(
                                      'Plus que 2 jours...',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: LinearPercentIndicator(
                                  percent: 0.5,
                                  lineHeight: 20,
                                  animation: true,
                                  progressColor: Color(0xFF72B0EA),
                                  backgroundColor: Color(0xFFF1F4F8),
                                  center: Text(
                                    '50%',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Playfair Display',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryColor,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
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
                                child: Text("Mes courses",
                                    style: GoogleFonts.sen(
                                        textStyle: TextStyle(
                                      color: Color(0xFF121212),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    )))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.95, -0.90),
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
          ],
        ),
      ),
    ],
  ));

  // );
}
// }
