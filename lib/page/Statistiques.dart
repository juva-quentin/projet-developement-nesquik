import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  const Stats({Key key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
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
