import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';
import 'dart:async';
import 'package:loreal_isp_supervisor_flutter/database/dbhelper.dart';
import 'package:loreal_isp_supervisor_flutter/gettersetter/all_gettersetter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String result_path;

class StoreImage extends StatefulWidget {
  JCPGetterSetter store_data;

  // In the constructor, require a Todo
  StoreImage({Key key, @required this.store_data}) : super(key: key);

  @override
  _StoreImageState createState() => _StoreImageState();
}

class _StoreImageState extends State<StoreImage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String visit_date, user_id;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Store Image"),
        ),
        body: new Container(
            color: new Color(0xffEEEEEE),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Expanded(
                    child: new GestureDetector(
                        child: new Card(
                          child: new Container(
                            child: Center(
                              child: new Image(
                                image: new AssetImage('assets/camera_icon.png'),
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          opencamera(widget.store_data.STORE_CD);
                        })),
                new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  child: new RaisedButton(
                      color: Colors.blue,
                      child: new Text(
                        "Save",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onPressed: () {

                        if(result_path!=null){
                          insertStoreData(widget.store_data, result_path);
                          _checkinData(widget.store_data, result_path);
                          //Navigator.of(context).pop();
                        }
                        else{
                          showInSnackBar('Please click image');
                        }

                        //Navigator.of(context).pushNamed('/Second');
                        // _onLoading(context);
                      }),
                )
              ],
            )));
  }

  //Loading counter value on start
  Future<String> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
      visit_date = prefs.getString('CURRENTDATE');
      user_id = prefs.getString('Userid');
      // will be null if never previously saved
    });
    visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
  }


  _checkinData(JCPGetterSetter jcp, String path) async {

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

    print("Attempting to fetch... ");

    final url =
        "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/UploadStoreCoverageSup";

    Map lMap = {
      "STORE_CD": jcp.STORE_CD,
      "USER_ID": user_id,
      "VISIT_DATE": visit_date,
      "IN_TIME": "00:00:00",
      "OUT_TIME": "00:00:00",
      "LATITUDE": "0.0",
      "LONGITUDE": "0.0",
      "APP_VERSION": "1",
      "REASON_ID": "0",
      "REASON_REMARK": "Redmi Note 5",
      "IMAGE_URL": path,
      "UPLOAD_STATUS": "I",
      "OUT_TIME_IMAGE": ""

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
      if(test.toString().contains("Success")){
        Navigator.pop(context, DialogDemoAction.cancel);
        Navigator.of(context).pop();
      }
      else{

      }
      //var test1 = json.decode(test);


    });
  }

  insertStoreData(JCPGetterSetter store_data, String img_in) async{
    var dbHelper = DBHelper();
    int primary_key = await dbHelper.insertCoverageIn(store_data, img_in);

    if(primary_key>0)
    showInSnackBar('Data saved successfully');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  List<CameraDescription> cameras;

  Future<Null> opencamera(int store_cd) async {
    // Fetch the available cameras before initializing the app.
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    //name of image clicked
    result_path = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraExampleHome(
              cameras: cameras,
              store_cd: store_cd,
            ),
      ),
    );
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');
}

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}