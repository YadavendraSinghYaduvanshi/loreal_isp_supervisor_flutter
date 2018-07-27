import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'dart:io';

import 'package:path/path.dart';
import 'package:loreal_isp_supervisor_flutter/gettersetter/all_gettersetter.dart';
import 'dart:convert';


class DatabaseISP {
  Database db;
  String visit_date = "VISIT_DATE";

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
    /*      await db.execute('''
create table $tableTodo (
  $columnId integer primary key autoincrement,
  $columnTitle text not null,
  $columnDone integer not null)
''');*/
        });
  }

   create(var query) async {
     db.execute(query);
  }

 /*Future<JOURNEY_PLAN_SUP> insert(JOURNEY_PLAN_SUP todo) async {
    todo.id = await db.insert("JOURNEY_PLAN_SUP", todo.toMap());
    return todo;
  }*/
Future insertData(String responseBody, String table_name) async {

  await db.delete(table_name);

  var test = JSON.decode(responseBody);

  var test_map = json.decode(test);
  var list = test_map[table_name] as List;

  var primary_key;
  for(int i=0;i<list.length;i++){
    primary_key = db.insert(table_name, list[i]);
  }
    return primary_key;
  }

/*  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }*/

  /*Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }*/

/*  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }*/

  Future close() async => db.close();

  // Retrieving employees from JCP Tables
  Future<List<JCPGetterSetter>> getJCPList(String visit_date) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM JOURNEY_PLAN_SUP where VISIT_DATE= '" + visit_date +"'");
    List<JCPGetterSetter> storelist = new List();
    for (int i = 0; i < list.length; i++) {
      storelist.add(new JCPGetterSetter(list[i]["STORE_CD"], list[i]["EMP_CD"], list[i]["VISIT_DATE"], list[i]["KEYACCOUNT"], list[i]["STORENAME"], list[i]["CITY"], list[i]["STORETYPE"],
        list[i]["UPLOAD_STATUS"],list[i]["CHECKOUT_STATUS"],list[i]["LATTITUDE"],list[i]["LONGITUDE"],list[i]["GEO_TAG"],list[i]["CHANNEL_CD"],list[i]["CHANNEL"]));
    }
    print(storelist.length);
    return storelist;
  }
}

// return the path
Future<String> initDeleteDb() async {
  var dbName = "DatabaseLorealISPSup1";
  var databasePath = await getDatabasesPath();
  // print(databasePath);
  String path = join(databasePath, dbName);

  // make sure the folder exists
  if (await new Directory(dirname(path)).exists()) {
    await deleteDatabase(path);
  } else {
    try {
      await new Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}

