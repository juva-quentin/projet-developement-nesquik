import 'package:flutter/material.dart';

class AddParcour extends StatefulWidget {
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
        body: ListView());
  }
}
