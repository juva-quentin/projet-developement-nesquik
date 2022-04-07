import 'package:flutter/material.dart';


class Favoris extends StatefulWidget {
  const Favoris({Key key}) : super(key: key);

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Mes Favoris"),

        backgroundColor: Color(0xFF72B0EA),
      ),
    );
  }
}
