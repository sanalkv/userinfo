import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'user.dart';

class Dbhelper {
  Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initdb();
    return db;
  }

  initdb() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'User.db');
    var thedb = openDatabase(path, version: 1, onCreate: _onCreate);
    return thedb;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "create table User(fullname text , email text , mobile text,gender text , age text , password text)");
    print("table created");
    return db;
  }

  void savedetails(User object) async {
    var dbb = await db;
    await dbb.transaction((txn) async {
      return await txn.execute(
          "INSERT Into User (fullname,email,mobile,gender,age,password)"
          " VALUES (?,?,?,?,?,?)",
          [
            object.fullname,
            object.email,
            object.mobile,
            object.gender,
            object.age,
            object.password
          ]);
    });
  }

  Future<List<User>> getdetails() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');

    List<User> lists = new List();
    if (list.length != null) {
      for (var i = 0; i < (list.length); i++) {
        lists.add(User(list[i]["fullname"], list[i]["email"], list[i]["mobile"],
            list[i]["gender"], list[i]["age"], list[i]["password"]));
      }
    }
    return lists;
  }

  Future<bool> logincheck(String email, String password) async {
    var dbclient = await db;
    List<Map> list = await dbclient.rawQuery("select * from User");

    for (int i = 0; i < list.length; i++) {
      if (list[i]["email"] == email && list[i]["password"] == password) {
        return true;
      } else {
        continue;
      }
    }
    return false;
  }

  Future<bool> signup_check(String email, String mobile) async {
    var dbclient = await db;
    List<Map> list = await dbclient.rawQuery("select * from User");

    for (int i = 0; i < list.length; i++) {
      if (list[i]["email"] == email || list[i]["mobile"] == mobile) {
        return true;
      } else {
        continue;
      }
    }
    return false;
  }
}
