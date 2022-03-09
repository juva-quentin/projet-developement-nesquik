// ignore: file_names
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
      buildTopBar(),
    ]));
  }

  Widget buildTopBar() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.22,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          // ignore: prefer_const_constructors
          color: Color(0xFF72B0EA),
          borderRadius: BorderRadius.only(
            // ignore: prefer_const_constructors
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
      );
}
