
import 'package:flutter/material.dart';

/*
class _FormFieldSampleState extends State<FormFieldSample> {

  // Initially password is obscure
  bool _obscureText = true;

  String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Password',
                  icon: const Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: const Icon(Icons.lock))),
              validator: (val) => val.length < 6 ? 'Password too short.' : null,
              onSaved: (val) => _password = val,
              obscureText: _obscureText,
            ),
            new FlatButton(
                onPressed: _toggle,
                child: new Text(_obscureText ? "Show" : "Hide"))
          ],
        ),
      ),
    );
  }
}*/
