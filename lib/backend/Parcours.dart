import 'dart:ffi';

class Parcours {
  String owner = "";
  String title = "";
  String address = "";
  String type = "";
  String description = "";
  List<String> shareTo = [];
  double distance = 0.0;
  int temps = 0;
  List<double> denivele = [];
  double vitesse = 0.0;

  Parcours();
}
