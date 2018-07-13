import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  static final TextEditingController _uid = new TextEditingController();
  static final TextEditingController _psw = new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  static BuildContext context_global;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    context_global = context;

    return new Scaffold(
        backgroundColor: new Color(0xffEEEEEE),
        appBar: new AppBar(
          title: new Text("Login"),
          backgroundColor: Colors.blue,
        ),
        body: new Center(
            child: new ListView(shrinkWrap: true, children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 20.0),
            child: new Center(
              child: new Image(
                image: new AssetImage('assets/loreal1.png'),
                height: 150.0,
                width: 150.0,
              ),
            ),
          ),
          new SizedBox(height: 24.0),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 10.0),
            child: new Center(
              child: new Form(
                  key: formKey,
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(15.0),
                      child: new Column(
                        children: <Widget>[
                          new TextFormField(
                            controller: _uid,
                            decoration:
                                new InputDecoration(hintText: "Enter User Id"),
                            validator: (val) =>
                                val.length < 1 ? 'Please enter User Id.' : null,
                            onSaved: (val) => _email = val,
                          ),
                          new TextFormField(
                            controller: _psw,
                            decoration:
                                new InputDecoration(hintText: "Enter Password"),
                            obscureText: true,
                            validator: (val) => val.length < 1
                                ? 'Please enter password.'
                                : null,
                            onSaved: (val) => _password = val,
                          ),
                          new Container(
                            margin: new EdgeInsets.symmetric(vertical: 10.0),
                            child: new RaisedButton(
                                child: new Text("Submit"),
                                onPressed: () {
                                  //Navigator.of(context).pushNamed('/Second');
                                  _onLoading(context);
                                }),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
          new SizedBox(height: 24.0),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 10.0),
            child: new Center(
              child: new Text("(c) All rights reserved 2018"),
            ),
          ),
        ])));
  }

  void onSubmit() {
    print("Login with: " + _uid.text + " " + _psw.text);
  }

  void _onLoading(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        ),
      );
      new Future.delayed(new Duration(seconds: 3), () {
        /*Navigator.pop(context); //pop dialog
        Navigator.of(context).pushNamed('/MainPage');*/
        //getData();
        _fetchData();
      });
    }
  }

/*  Future<String> getData() async {
   */ /* var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json"
        }
    );
    data = JSON.decode(response.body);
    print(data[1]["title"]);

    return "Success!";*/ /*

    NetworkUtil _netUtil = new NetworkUtil();
    final BASE_URL = "http://YOUR_BACKEND_IP/login_app_backend";
    final LOGIN_URL = "http://gskgtm.parinaam.in/Webservice/Gskwebservice.svc/LoginDetaillatest";
    final _API_KEY = "somerandomkey";

    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": _uid.text,
      "password": _psw.text
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["error_msg"]);
      //return new User.map(res["user"]);
      return res["user"];
    });

  }*/

  List data;

  _fetchData() {
    print("Attempting to fetch...");

    final url =
        "http://gskgtm.parinaam.in/Webservice/Gskwebservice.svc/LoginDetaillatest";
    Map lMap =
    {
      "Userid": _uid.text,
      "Password": _psw.text,
      "Intime": "13:42:01",
      "Latitude": "0.0",
      "Longitude": "0.0",
      "Appversion": "1.9",
      "Attmode": "0",
      "Networkstatus": "0",
      "Manufacturer": "Xiaomi",
      "ModelNumber": "Redmi Note 5",
      "OSVersion": "7.1.2",
      "IMEINumber1": "868943039755568",
      "IMEINumber2": "868943039755576"
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
      if(test.toString()=="Faliure"){

      }
      else if(test.toString()=="Changed"){

      }
      else{
        var test1 = json.decode(test);
        var data = test1['Result'][0];
        print(test1['Result'][0]['App_Path']);
        var app_version = data['App_Version'];
        var app_path = data['App_Path'];
        var current_date = data['Currentdate'];
        var notice_board = data['Notice'];

        _incrementCounter(data);

        Navigator.of(context_global).pushNamed('/MainPage');
      }

      if(test.toString()!="Faliure"){

      }
      /* print(test1[0]['SAMPLE_NAME']);
      print(test1[1]['SAMPLE_NAME']);*/
    });
  }

  //Incrementing counter after click
  _incrementCounter(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('Userid', _uid.text);
    prefs.setString('Password', _psw.text);
    prefs.setString('Currentdate', data['Currentdate']);
    prefs.setString('Notice', data['Notice']);

    //_loadCounter();
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var current_date = prefs.getString('Currentdate');
  }
}
