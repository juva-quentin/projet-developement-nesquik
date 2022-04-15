import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_developement_nesquik/auth/firebase_user_provider.dart';
import 'package:projet_developement_nesquik/backend/loader.dart';
import 'package:projet_developement_nesquik/backend/database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class Classement extends StatefulWidget {
  @override
  _Classement createState() => _Classement();
}

class _Classement extends State<Classement> {
  DatabaseService database = new DatabaseService();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .orderBy('tdp', descending: true)
      .snapshots();

  IconData addIcon;
  @override
  Widget build(BuildContext context) {
    var i = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text("Classement de la semaine"),
          backgroundColor: Color(0xFF72B0EA),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Il y a eu un problème');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return ColorLoader([Colors.black, Colors.white, Colors.blue],
                    Duration(seconds: 3));
              }

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  i++;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  return Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 4, 4, 0),
                                      child: Text(
                                        "${data['tdp'].toStringAsFixed(2)}Km",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF72B0EA),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (() {
                                if (i == 1) {
                                  return Icon(MdiIcons.trophy,
                                      color: Colors.yellow);
                                } else if (i == 2) {
                                  return Icon(MdiIcons.trophy,
                                      color: Colors.grey);
                                } else if (i == 3) {
                                  return Icon(
                                    MdiIcons.trophy,
                                    color: Colors.brown,
                                  );
                                } else {
                                  return Text("${i.toString()} ème");
                                }
                              }())
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
