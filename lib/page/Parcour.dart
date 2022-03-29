class Parcour {
  Gpx gpx;

  Parcour({this.gpx});

  Parcour.fromJson(Map<String, dynamic> json) {
    gpx = (json['gpx'] != null ? new Gpx.fromJson(json['gpx']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gpx != null) {
      data['gpx'] = this.gpx.toJson();
    }
    return data;
  }
}

class Gpx {
  Trk trk;

  Gpx({this.trk});

  Gpx.fromJson(Map<String, dynamic> json) {
    trk = (json['trk'] != null ? new Trk.fromJson(json['trk']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trk != null) {
      data['trk'] = this.trk.toJson();
    }
    return data;
  }
}

class Trk {
  String name;
  String type;
  Trkseg trkseg;

  Trk({this.name, this.type, this.trkseg});

  Trk.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    trkseg =
        (json['trkseg'] != null ? new Trkseg.fromJson(json['trkseg']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.trkseg != null) {
      data['trkseg'] = this.trkseg.toJson();
    }
    return data;
  }
}

class Trkseg {
  List<Trkpt> trkpt;

  Trkseg({this.trkpt});

  Trkseg.fromJson(Map<String, dynamic> json) {
    if (json['trkpt'] != null) {
      trkpt = <Trkpt>[];
      json['trkpt'].forEach((v) {
        trkpt.add(new Trkpt.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trkpt != null) {
      data['trkpt'] = this.trkpt.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trkpt {
  String lat;
  String lon;
  String ele;

  Trkpt({this.lat, this.lon, this.ele});

  Trkpt.fromJson(Map<String, dynamic> json) {
    lat = json['-lat'];
    lon = json['-lon'];
    ele = json['ele'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['-lat'] = this.lat;
    data['-lon'] = this.lon;
    data['ele'] = this.ele;
    return data;
  }
}
