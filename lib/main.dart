import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projet_developement_nesquik/page/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}
