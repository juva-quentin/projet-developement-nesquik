import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_developement_nesquik/screens/Guest.dart';
import 'package:projet_developement_nesquik/screens/guest/Auth.dart';
import 'package:projet_developement_nesquik/screens/guest/Term.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theo\'file Tracker',
      home: GuestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
