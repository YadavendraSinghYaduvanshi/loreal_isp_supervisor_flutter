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

  List<String> items = ["Table_Structure", "Journey_Plan"];

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _fetchData(var index) {

    print("Attempting to fetch... " + items[index]);

    final url =
        "http://gskgtm.parinaam.in/Webservice/Gskwebservice.svc/DownloadAll";

    Map lMap = {
      "Downloadtype": items[index],
      "Username": user_id,
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

      if(index==0){
        var data = test1['Table_Structure'][16];
        var query = data['SqlText'];

        _insert(query);

        _fetchData(++index);

      }
      else{

      }

    });
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    visit_date = prefs.getString('Currentdate');
    user_id = prefs.getString('Userid');

    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Downloading"),
          ],
        ),
      ),
    );

    _fetchData(0);
  }

  //Loading counter value on start
  _insert(var query) async {
    String path = await initDeleteDb();
    DatabaseISP database = new DatabaseISP();
    await database.open(path);

    await database.create(query);

    await database.close();
  }
}
