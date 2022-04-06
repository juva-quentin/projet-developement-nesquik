import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  const Courses({Key key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
        backgroundColor: Color(0xFF72B0EA),
      ),
    );
  }
}
