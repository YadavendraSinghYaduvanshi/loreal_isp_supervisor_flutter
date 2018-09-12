import 'dart:async';
import 'dart:io' as io;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loreal_isp_supervisor_flutter/gettersetter/all_gettersetter.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test1.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
   await db.execute(
        "CREATE TABLE COVERAGE_DATA(id INTEGER PRIMARY KEY, STORE_CD int, VISIT_DATE TEXT, STORE_IMG_IN TEXT, STORE_IMG_OUT TEXT, FROM_DEVIATION int)");
    print("Created tables");
  }

  void create_table(String query) async{

    var dbClient = await db;

    await dbClient.execute(query);
  }

  Future insertData(String responseBody, String table_name) async {
    var dbClient = await db;
    await dbClient.delete(table_name);

    var test = json.decode(responseBody);

    var test_map = json.decode(test);
    var list = test_map[table_name] as List;

    var primary_key;
    for(int i=0;i<list.length;i++){
      primary_key = await dbClient.insert(table_name, list[i]);
    }
    return primary_key;
  }

  Future insertCoverageIn(JCPGetterSetter store_data, String img_path, int deviation_flag) async{
    var dbClient = await db;
    CoverageGettersetter coverage = new CoverageGettersetter(store_data.STORE_CD,
        img_path, "",store_data.VISIT_DATE, deviation_flag);

    var primary_key = await dbClient.insert("COVERAGE_DATA", coverage.toMap());

    String table_name;

    if(deviation_flag==0){
      table_name = "JOURNEY_PLAN_SUP";
    }
    else{
      table_name = "DEVIATION_STORE_SUP";
    }

    // Update store record
    int count = await dbClient.rawUpdate(
        'UPDATE ' + table_name + ' SET UPLOAD_STATUS = ? WHERE STORE_CD = ?',
        ["I", store_data.STORE_CD]);
    return primary_key;
  }


  Future deleteCoverageSpecific(int store_cd, int deviation_flag) async{
    var dbClient = await db;
    var count = await dbClient
        .rawDelete("DELETE FROM COVERAGE_DATA WHERE STORE_CD = '"+ store_cd.toString() +"'");

    String table_name;

    if(deviation_flag==0){
      table_name = "JOURNEY_PLAN_SUP";
    }
    else{
      table_name = "DEVIATION_STORE_SUP";
    }

    int count1 = await dbClient.rawUpdate(
        'UPDATE ' + table_name + ' SET UPLOAD_STATUS = ? WHERE STORE_CD = ?',
        ["U", store_cd]);
  }



/*  void saveEmployee(JCPGetterSetter employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee(firstname, lastname, mobileno, emailid ) VALUES(' +
              '\'' +
              employee.firstName +
              '\'' +
              ',' +
              '\'' +
              employee.lastName +
              '\'' +
              ',' +
              '\'' +
              employee.mobileNo +
              '\'' +
              ',' +
              '\'' +
              employee.emailId +
              '\'' +
              ')');
    });
  }*/

  Future<List<JCPGetterSetter>> getJCPList(String visit_date, int deviation_flag) async {
    List<JCPGetterSetter> storelist = new List();
    try{
      String table_name;

      if(deviation_flag==0){
        table_name = "JOURNEY_PLAN_SUP";
      }
      else{
        table_name = "DEVIATION_STORE_SUP";
      }

      var dbClient = await db;
      List<Map> list = await dbClient.rawQuery("SELECT * FROM "+ table_name +" where VISIT_DATE= '" + visit_date +"'");

      for (int i = 0; i < list.length; i++) {
        storelist.add(new JCPGetterSetter(list[i]["STORE_CD"], list[i]["EMP_CD"], list[i]["VISIT_DATE"], list[i]["KEYACCOUNT"], list[i]["STORENAME"], list[i]["CITY"], list[i]["STORETYPE"],
            list[i]["UPLOAD_STATUS"],list[i]["CHECKOUT_STATUS"],list[i]["LATTITUDE"],list[i]["LONGITUDE"],list[i]["GEO_TAG"],list[i]["CHANNEL_CD"],list[i]["CHANNEL"]));
      }
      print(storelist.length);
      return storelist;
    }
    on Exception{
      return storelist;
    }

  }

  Future<List<NonWorkingReasonGetterSetter>> getNonWorkingReasonList(bool upload_flag) async {
    List<NonWorkingReasonGetterSetter> reasonlist = new List();
    try{
      var dbClient = await db;
      String query;
      if(upload_flag){
        query = "SELECT * FROM NON_WORKING_REASON WHERE ENTRY_ALLOW ='1'";
      }
      else{
        query = "SELECT * FROM NON_WORKING_REASON ";
      }
      List<Map> list = await dbClient.rawQuery("SELECT * FROM NON_WORKING_REASON ");

      for (int i = 0; i < list.length; i++) {
        reasonlist.add(new NonWorkingReasonGetterSetter(list[i]["REASON_CD"], list[i]["REASON"], list[i]["ENTRY_ALLOW"], list[i]["IMAGE_ALLOW"],));
      }
      print(reasonlist.length);
      return reasonlist;
    }
    on Exception{
      return reasonlist;
    }

  }

  Future<CoverageGettersetter> getCoverage(String visit_date, int store_cd) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM COVERAGE_DATA where VISIT_DATE= '" + visit_date
        +"' AND STORE_CD ='" + store_cd.toString() +"'");
    CoverageGettersetter coverage;

    if(list.length>0){
      coverage = new CoverageGettersetter(
        list[0]["STORE_CD"], list[0]["STORE_IMG_IN"], list[0]["STORE_IMG_OUT"], list[0]["VISIT_DATE"], list[0]['FROM_DEVIATION']);
    }

    return coverage;
  }
}

