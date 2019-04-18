import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:tabs/database/db_helper.dart';
import 'package:tabs/model/gorev.dart';

class Yapiliyor extends StatefulWidget {
  @override
  _YapiliyorState createState() => _YapiliyorState();
}

class _YapiliyorState extends State<Yapiliyor> {

  DbHelper _dbHelper;
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

    return FutureBuilder (
      future: _dbHelper.getTodo(2),
      builder: (BuildContext context, AsyncSnapshot<List<Gorev>> veriler) {
        if(!veriler.hasData)  return Center(child: CircularProgressIndicator(),);
        if(veriler.data.isEmpty) return Center(child: Text("Yapılıyor Listesi Boş",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.teal),),);
        return ListView.builder(
          itemCount: veriler.data.length,
          itemBuilder: (BuildContext context,int index){
            Gorev gorev = veriler.data[index];
            return Dismissible(
              background: Container(
                alignment: Alignment.centerLeft,
                color: Colors.lightBlue.shade200,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.chevron_right,color: Colors.white,),
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.chevron_left,color: Colors.white,),
                ),
              ),
              key: UniqueKey(),
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: onemliColor(gorev.onemlilik),
                    child: Icon(Icons.assignment_late,color: Colors.white,),
                  ),
                title: Text(gorev.gorev ==null ? "bunusil":gorev.gorev),
                subtitle: Text(gorev.saat),
                trailing: GestureDetector(
                  child:Icon(Icons.delete,color:Colors.grey),
                  onTap: (){
                    setState(() {
                     _deleteGorev(gorev); 
                    });
                  },
                ),
                ),
              ),
              onDismissed: (direction){
                if(direction == DismissDirection.endToStart){
                  setState(() {
                    _save(gorev, 1,2); 
                  });
                } else{
                  setState(() {
                    _save(gorev, 3,2); 
                  });
                }
              },
            );
          },
        );
      },);
  }

  void _save(Gorev gorev,int yeniDurum,int eskiDurum) async{

    Gorev yeniGorev = gorev;
    setState(() {
      yeniGorev.durum = yeniDurum;
      yeniGorev.saat = formatDate(DateTime.now(),[HH,':',nn,':',ss]);  
    });
    
    var result = await _dbHelper.updateDurum(yeniGorev);
    if(result != 0){ //başarılı
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1500),
        content: yeniDurum==1 ? Text("${gorev.gorev} \nYapılacak."):Text("${gorev.gorev} \nBitti."),
        action: SnackBarAction(
          label: 'Geri Al',
          onPressed: (){
            setState(() {
             geriAlUpdate(gorev,eskiDurum); 
            });          
          },
        ),
      ),
    );
    }else{ //hatalı
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("İşlem başarısız"),
        ),
      );
    }
  }
  void _deleteGorev(Gorev gorev) async{
    var result =await _dbHelper.deleteGorev(gorev.id);
    if(result !=0){
      Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1200),
        content: Text("${gorev.gorev} \nSilindi"),
        action: SnackBarAction(
          label: 'Geri Al',
          onPressed: (){
            setState(() {
            insertGorev(gorev);  
            });
          },
        ),
      ),
    );
    }
    else{
      Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("İşlem başarısız"),
      ),
    );
    }
  }

  void insertGorev(Gorev gorev) async{
    var result = await _dbHelper.insertGorev(gorev);
    if(result != 0){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1200),
          content: Text("${gorev.gorev} \nGeri alındı."),
        ),
      );
    }
  }

  void geriAlUpdate(Gorev gorev,int durum) async{
    setState(() {
     gorev.durum = durum; 
    });
    var result = await _dbHelper.updateDurum(gorev);
    if(result != 0){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1200),
          content: Text("${gorev.gorev} \nGeri alındı."),
        ),
      );
    }
    
  }

 Color onemliColor(int onemlilik) {
   switch(onemlilik){
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.orange;
        break;
      default:
        return Colors.red;
        
    }  
 }
}