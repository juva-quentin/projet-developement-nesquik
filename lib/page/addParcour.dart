import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../flutter_flow/flutter_flow_choice_chips.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class AddParcour extends StatefulWidget {
  AddParcour({Key key, this.dataLocation}) : super(key: key);
  final LocationData dataLocation;
  @override
  _AddParcour createState() => _AddParcour();
}

class _AddParcour extends State<AddParcour> {
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
          children: [MyCustomForm()],
        ));
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  String choiceChipsValue;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
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
              decoration: BoxDecoration(color: Color.fromARGB(255, 82, 82, 82)),
              child: Center(
                  child: Text("Preview",
                      style: TextStyle(fontSize: 40, color: Colors.white70)))),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.all(20),
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
                Table(
                  border: TableBorder.all(
                      width: 1.0, color: Color.fromARGB(179, 0, 0, 0)),
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                            Text("Temps total du trajet"),
                            Text("Miam")
                          ])),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                            Text("Temps total du trajet"),
                            Text("Miam")
                          ])),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                            Text("Temps total du trajet"),
                            Text("Miam")
                          ])),
                    ])
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(35, 30, 0, 0),
                  child: FlutterFlowChoiceChips(
                    initiallySelected: [choiceChipsValue],
                    options: [
                      ChipData('Homme'),
                      ChipData('Femme'),
                      ChipData('Autres')
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
    );
  }
}
