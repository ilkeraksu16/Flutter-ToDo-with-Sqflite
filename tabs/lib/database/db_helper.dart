import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tabs/model/gorev.dart';

class DbHelper{

  static Database _db;
  
  Future<Database> get db async{
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async{
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder,"Gunluk.db");

    return openDatabase(path,onCreate: _onCreate,version: 1);
  }
    
  FutureOr<void> _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE Gorevler(id INTEGER PRIMARY KEY AUTOINCREMENT, onemlilik INTEGER, durum INTEGER, gorev TEXT, saat TEXT)");
  }

  Future<List<Gorev>> getTodo(int durum) async{
  
    var dbClient = await db;
    var result = await dbClient.query("Gorevler",where: 'durum = ?',whereArgs: [durum],orderBy: 'onemlilik DESC');
    return result.map((data)=>Gorev.fromMap(data)).toList();
  }

  Future<int> insertGorev(Gorev gorev) async{
    var dbClient = await db;
    return await dbClient.insert("Gorevler",gorev.toMap());
  }
  Future<int> updateDurum(Gorev gorev) async{
    var dbClient = await db;
    var result = await dbClient.update('Gorevler', gorev.toMap(), where: " id = ?",whereArgs: [gorev.id]);
    return result;
  }

  Future<int> deleteGorev(int id) async{
    var dbClient = await db;
    var result = await dbClient.delete('Gorevler',where: 'id = ?',whereArgs: [id]);
    return result;
  }
}