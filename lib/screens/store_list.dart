import 'package:flutter/material.dart';
import 'package:loreal_isp_supervisor_flutter/gettersetter/all_gettersetter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loreal_isp_supervisor_flutter/database/dbhelper.dart';
import 'store_img.dart';

class StoreList extends StatefulWidget {

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Store List"),
      ),
      body: Container(
          color: new Color(0xffEEEEEE),
          child: FutureBuilder<List<JCPGetterSetter>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              //_loadCounter();
              return snapshot.hasData
                  ? StatusList(status: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          )
      ),
    );
  }

  String visit_date;

  Future<List<JCPGetterSetter>> fetchData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    visit_date = prefs.getString('CURRENTDATE');

    //var t1 = await _openDb();
    var dbHelper = DBHelper();
    List<JCPGetterSetter> store_list = await dbHelper.getJCPList(visit_date);
    return store_list;
  }

  /*DatabaseISP database;
  //Loading counter value on start
  _openDb() async {
    String path = await initDeleteDb();
    database = new DatabaseISP();
    await database.open(path);

    //await database.close();
  }*/
}

class StatusList extends StatelessWidget {
  final List<JCPGetterSetter> status;

  StatusList({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: status.length,
      itemBuilder: (context, index) {
        return new Container(
          child: new Card(
            color:  status[index].UPLOAD_STATUS == "I"? Colors.green:Colors.white,
              child: new GestureDetector(
                onTap:  () {
                  print("attendance");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreImage(store_data: status[index]),
                    ),
                  );
                },
                child: new Container(
                  margin: EdgeInsets.all(10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Text(
                        status[index].STORENAME,
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      new Text(
                        status[index].CITY,
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal),
                      ),
                      new Text(
                        status[index].STORETYPE,
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }
}