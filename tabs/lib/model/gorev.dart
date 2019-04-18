class Gorev{
  int id;
  int onemlilik;
  int durum;
  String gorev;
  String saat;

  Gorev({this.gorev,this.onemlilik,this.saat,this.durum});

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    map["id"] = id;
    map["gorev"] = gorev;
    map["onemlilik"] = onemlilik;
    map["saat"] = saat;
    map["durum"] = durum;

    return map;
  }

  Gorev.fromMap(Map<String,dynamic> map){
    id = map["id"];
    gorev = map["gorev"];
    onemlilik = map["onemlilik"];
    saat = map["saat"];
    durum = map["durum"];
  }
}