import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loreal_isp_supervisor_flutter/database/database.dart';

class DownloadData extends StatefulWidget {
  @override
  _DownloadDataState createState() => _DownloadDataState();
}

class _DownloadDataState extends State<DownloadData> {
  var visit_date, user_id;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();

    super.initState();
  }

  List<String> items = ["Table_Structure", "CITY_MASTER", "Non_Working_Reason"];

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _fetchData(var index) {

    _openDb();

    print("Attempting to fetch... " + items[index]);

    final url =
        "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": items[index],
      "Username": user_id,
      "per1": "0",
      "per2": "0",
      "per3": "0",
      "per4": "0",
      "per5": "0",

    };

    String lData = json.encode(lMap);
    Map<String, String> lHeaders = {};
    lHeaders = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    http.post(url, body: lData, headers: lHeaders).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      var test = JSON.decode(response.body);

      var test1 = json.decode(test);

      switch(items[index]){

        case "Table_Structure":

          var data = test1['Table_Structure'];
          for(int i=0; i<data.size; i++){
            _create_table(data[i]['SqlText']);
          }

          break;

        case "CITY_MASTER":

          break;

        case "Non_Working_Reason":

          break;
      }

      if(index+1 < items.length){
        _fetchData(++index);
      }
      else{
        Navigator.pop(context, DialogDemoAction.cancel);
        Navigator.of(context).pop();
      }

    });
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    visit_date = prefs.getString('Currentdate');
    user_id = prefs.getString('Userid');

    showDialog<DialogDemoAction>(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
          child: new Padding(padding: EdgeInsets.all(25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new SizedBox(width: 20.0),
                new Text("Downloading", style: new TextStyle(fontSize: 18.0),),
              ],
            ),
          )
      ),
    );

    _fetchData(0);
  }

  DatabaseISP database;
  //Loading counter value on start
  _openDb() async {
    String path = await initDeleteDb();
    database = new DatabaseISP();
    await database.open(path);
    //await database.close();
  }

  _create_table(var query) async{
    await database.create(query);
  }
}

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}