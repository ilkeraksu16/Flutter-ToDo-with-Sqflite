import 'package:flutter/material.dart';
import 'package:tabs/gorev_ekle.dart';
import 'gorevler/yapilacaklar.dart';
import 'gorevler/yapiliyor.dart';
import 'gorevler/bitti.dart';
class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Yapilacaklar(),
    Yapiliyor(),
    Bitti(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Günlük Liste"),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: tiklama, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
          icon: Icon(Icons.today),
          title: Text("Yapılacaklar"),
           ),
          BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          title: Text("Yapılıyor"),
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          title: Text("Bitti"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GorevEkle()));
        },
      ),
    );
  }
        
    void tiklama(int index) {
      setState(() {
       _currentIndex = index; 
      });
  }
}