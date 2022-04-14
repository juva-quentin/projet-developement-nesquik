import 'package:intl/intl.dart';

class Parcours {
  String owner = "";
  String title = "";
  String address = "";
  String type = "private";
  String description = "";
  List<String> shareTo = [];
  double distance = 0.0;
  String temps = "";
  List<double> denivele = [];
  double vitesse = 0.0;
  String date = "";
  List<double> startPoint = [];

  Parcours([
    String owner,
    String title,
    String address,
    String type,
    String description,
    double distance,
    String temps,
    double vitesse,
    String date,
  ]) {
    this.owner = owner;
    this.title = title;
    this.address = address;
    this.type = type;
    this.description = description;

    this.distance = distance;
    this.temps = temps;

    this.vitesse = vitesse;
    this.date = date;
  }
}

class AddParcours {
  String owner = "";
  String title = "";
  String address = "";
  String type = "private";
  String description = "";
  List<String> shareTo = [];
  double distance = 0.0;
  String temps = "";
  List<double> denivele = [];
  double vitesse = 0.0;
  String date = "";
  List<double> startPoint = [];
}
