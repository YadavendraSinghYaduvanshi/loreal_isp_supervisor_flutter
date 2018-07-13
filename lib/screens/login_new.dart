import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'package:device_info/device_info.dart';


class LoginNew extends StatefulWidget {
  @override
  _LoginNewState createState() => _LoginNewState();
}

class _LoginNewState extends State<LoginNew> {
  static final TextEditingController _uid = new TextEditingController();
  static final TextEditingController _psw = new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  static BuildContext context_global;

  @override
  void initState() {
    super.initState();
    fetchDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    context_global = context;

    String _password;

    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Login"),
            backgroundColor: Colors.blue,
          ),
          body: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: new IntrinsicHeight(
                  child: new Column(
                    children: <Widget>[
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
                                        decoration: new InputDecoration(
                                          labelText: 'User Id',),
                                        validator: (val) =>
                                        val.length < 1
                                            ? 'Please enter User Id.'
                                            : null,
                                        onSaved: (val) => _email = val,

                                      ),
                                      new Row(
                                        children: <Widget>[
                                          /* new TextFormField(
                                        controller: _psw,
                                        decoration:
                                        new InputDecoration(hintText: "Enter Password"),
                                        obscureText: true,
                                        validator: (val) => val.length < 1
                                            ? 'Please enter password.'
                                            : null,
                                        onSaved: (val) => _password = val,
                                      ),*/
                                          new Expanded(
                                            child: new TextFormField(
                                              controller: _psw,
                                              decoration: new InputDecoration(
                                                suffixIcon: new Padding(
                                                  padding: new EdgeInsetsDirectional
                                                      .only(start: 16.0),
                                                  child: new IconButton(
                                                      icon: new Icon(
                                                          _obscureText ? Icons
                                                              .visibility : Icons
                                                              .visibility_off),
                                                      onPressed: _toggle),
                                                ),
                                                labelText: 'Password',
                                                /*icon: const Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    child: const Icon(
                                                        Icons.lock))*/),
                                              validator: (val) =>
                                              val.length < 1
                                                  ? 'Please enter password.'
                                                  : null,
                                              onSaved: (val) => _password = val,
                                              obscureText: _obscureText,
                                            ),
                                          ),
                                          /*new FlatButton(
                                            onPressed: _toggle,
                                            child: */ /*new Text(
                                                _obscureText ? "Show" : "Hide")*/ /*
                                            new Icon(_obscureText ? Icons.visibility : Icons.visibility_off))*/
                                        ],
                                      ),
                                      new Container(
                                        margin: new EdgeInsets.symmetric(
                                            vertical: 10.0),
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
                    ],
                  ),
                ),
              ),
            ),
          )
        );
      },
    );
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
                new Text("Loading...", style: new TextStyle(fontSize: 18.0),),
              ],
            ),
          )
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

  fetchDeviceData() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

  }

  _fetchData() {
    print("Attempting to fetch...");

    final url =
        "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/LoginDetaillatest";
    Map lMap = {
      "USER_ID": _uid.text,
      "PASSWORD": _psw.text,
      "IN_TIME": "13:42:01",
      "LATITUDE": "0.0",
      "LONGITUDE": "0.0",
      "APP_VERSION": "1.9",
      "ATT_MODE": "0",
      "Networkstatus": "0",
      "Manufacturer": "Xiaomi",
      "Model": "Redmi Note 5",
      "Andoid_Version": "7.1.2",
      "IMEI1": "868943039755568",
      "IMEI2": "868943039755576"

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

      //var res = test1[0]['Result'];
      var res = test1.toString();

      //if (res == "Faliure") {} else if (res == "Changed") {
      if (res.contains("Faliure")) {} else if (res.contains("Changed")) {
        Navigator.pop(context, DialogDemoAction.cancel);
       _neverSatisfied();
      } else {
        var data = test1['Result'][0];

        print(test1['Result'][0]['App_Path']);
        var app_version = data['App_Version'];
        var app_path = data['App_Path'];
        var current_date = data['Currentdate'];
        var notice_board = data['Notice'];

        _incrementCounter(data);
      /*  Navigator.of(context_global).pop();
        Navigator.of(context_global).pushNamed('/MainPage');
*/
        //Route route = MaterialPageRoute(builder: (context_global) => Main_Activity());
        Navigator.of(context_global).pop();
        Navigator.pushReplacementNamed(context_global, '/MainPage');
      }

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

  Future<Null> _neverSatisfied() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Alert'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Invalid User Id or Password'),
                //new Text('or Password'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              color: new Color(0xffEEEEEE),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}