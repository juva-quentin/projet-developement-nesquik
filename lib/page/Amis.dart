import 'package:flutter/material.dart';

class Amis extends StatefulWidget {
  const Amis({Key key}) : super(key: key);

  @override
  State<Amis> createState() => _AmisState();
}

class _AmisState extends State<Amis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Amis"),
        backgroundColor: Color(0xFF72B0EA),
      ),
    );
  }
}
