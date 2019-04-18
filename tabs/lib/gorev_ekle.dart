import 'package:flutter/material.dart';
import 'package:tabs/database/db_helper.dart';
import 'package:tabs/model/gorev.dart';
import 'package:date_format/date_format.dart';


class GorevEkle extends StatefulWidget {
  @override
  _GorevEkleState createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {
  static List<String> _oncelik = ["Çok Önemli","Normal","Değil"];
  final _kontrol = GlobalKey<FormState>();
  String gorev,saat;
  int onemlilik,durum;
  DbHelper _dbHelper;
  String oncelik = _oncelik[0];
  @override
  void initState(){
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
    void dispose(){
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yapılacaklar Ekle"),
      ),
      body: Card(
        child: ListView(
          children:<Widget>[
            ListTile(
              title: Text("Yapılacağın Önceliği"),
              trailing: DropdownButton(
                items: _oncelik.map((String ogeler){
                  return DropdownMenuItem<String>(
                    value: ogeler,
                    child: Text(ogeler),
                  );
                }).toList(),
                value: oncelik,//veritabanından çekilecek
                onChanged: (value){
                  setState(() {
                    oncelik = value;
                    onemlilik = oncelikToInt(value);
                  });
                print("$onemlilik");
                },
              ),
            ),
            Form(
              key:_kontrol,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Bazı Hedefler Yazınız",
                        labelText: "Yapılacak Hedefler Yaz",
                      ),
                      validator: (value){
                        if(value.isEmpty)
                        return "yazı yazınız";
                      },
                      onSaved: (value){
                        setState(() {
                         gorev = value; 
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:RaisedButton(
                                color: Colors.blue,
                                child: Text("Kaydet",style: TextStyle(color: Colors.white),),
                                onPressed: () async{
                                  if(_kontrol.currentState.validate()){
                      _kontrol.currentState.save();

                      durum = 1;
                      saat = formatDate(DateTime.now(),[HH,':',nn,':',ss]);
                      var todo = Gorev(gorev: gorev,onemlilik: onemlilik,durum: durum,saat: saat);
                      await _dbHelper.insertGorev(todo);

                    Navigator.pop(context);
                                  }}                        
                  ),
                      ),
                      
                  SizedBox(width: 10.0,),
                  Expanded(
                      child:RaisedButton(
                                color: Colors.red,
                                child: Text("İptal",style: TextStyle(color: Colors.white),),
                                onPressed: (){
                                  
                    Navigator.pop(context);
                                  }                        
                  ),
                  ),
                  
                    ],
                  ),
                  
                ],
              ),
          
            ),
          ],
          ),
          
        ), 
    );
  }

  int oncelikToInt(String value){
    int oncelik;
    switch(value){
      case "Çok Önemli":
        oncelik = 3;
        break;
      case "Normal":
        oncelik = 2;
        break;
      case "Değil":
        oncelik = 1;
        break;  
    }
    print("fonksiyon oncelik $oncelik");
    return oncelik;
      
  }
}