import 'package:flutter/material.dart';
import 'package:projet_developement_nesquik/screens/Map.dart';
import 'package:projet_developement_nesquik/screens/guest/Auth.dart';
import 'package:projet_developement_nesquik/screens/guest/Term.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  _GuestScreenState createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  List<Widget> _widgets = [];
  int _indexSelected = 0;

  @override
  void initState() {
    super.initState();

    _widgets.addAll([
      Authscreen(
          onChangedStep: (index) => setState(() => _indexSelected = index)),
      TermScreen(
          onChangedStep: (index) => setState(() => _indexSelected = index)),
      MapSample(
          onChangedStep: (index) => setState(() => _indexSelected = index))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _widgets.elementAt(_indexSelected),
    );
  }
}
