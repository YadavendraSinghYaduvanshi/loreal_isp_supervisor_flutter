import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'dart:io';

import 'package:path/path.dart';


class DatabaseISP {
  Database db;

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
    await db.execute(query);
  }

  /*Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }*/

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