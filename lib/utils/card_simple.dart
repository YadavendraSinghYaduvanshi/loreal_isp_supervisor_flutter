import 'package:flutter/material.dart';

class MyCardSimple extends StatelessWidget {

  MyCardSimple({this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: new EdgeInsets.only(bottom: 2.0),
      child: new Card(
        child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new Row(
            children: <Widget>[
              new Expanded(child: this.title,)
            ],
          ),
        ),
      ),
    );
  }
}