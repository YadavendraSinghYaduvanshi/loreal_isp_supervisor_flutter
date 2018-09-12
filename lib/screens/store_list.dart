import 'package:flutter/material.dart';
import 'package:loreal_isp_supervisor_flutter/gettersetter/all_gettersetter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loreal_isp_supervisor_flutter/database/dbhelper.dart';
import 'store_img.dart';
import 'non_working.dart';

_StoreListState _myStoeListState = new _StoreListState();

class StoreList extends StatefulWidget {

  int deviation_flag;

  // In the constructor, require a Todo
  StoreList({Key key, @required this.deviation_flag,}) : super(key: key);

  @override
  _StoreListState createState() => new _StoreListState();
}

class _StoreListState extends State<StoreList> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Store List"),
      ),
      body: Container(
          color: new Color(0xffEEEEEE),
          child: FutureBuilder<List<JCPGetterSetter>>(
            future: fetchData(widget.deviation_flag),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              //_loadCounter();
              return snapshot.hasData
                  ? (snapshot.data.length>0?storeListList(
                deviation_flag: widget.deviation_flag,
                storeList: snapshot.data,scaffoldKey: _scaffoldKey,): new Center(child: new Card(child: new Text("No Data found - Please download data", style: TextStyle(fontSize: 16.0),),),))
                  : Center(child: CircularProgressIndicator());
            },
          )
      ),
    );
  }


  String visit_date;

  Future<List<JCPGetterSetter>> fetchData(int deviation_flag) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    visit_date = prefs.getString('CURRENTDATE');

    //var t1 = await _openDb();
    var dbHelper = DBHelper();
    List<JCPGetterSetter> store_list = await dbHelper.getJCPList(visit_date, deviation_flag);
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

class storeListList extends StatelessWidget {
  final List<JCPGetterSetter> storeList;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int deviation_flag;

  storeListList({Key key, this.deviation_flag ,this.storeList, this.scaffoldKey}) : super(key: key);

  void showInSnackBar(String message) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }


  BuildContext context_global;

  void onSubmit(String result, int index, int deviation_flag) {
    print(result);
    if(result == "entry"){
      showInSnackBar("PLease select an option");
    }else if(result == "Yes"){
      openStoreImage(context_global, storeList[index], deviation_flag);
    }else{
      Navigator.push(
        context_global,
        MaterialPageRoute(
          builder: (context) => NonWorking(store_data: storeList[index]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    context_global = context;

    return ListView.builder(
      itemCount: storeList.length,
      itemBuilder: (context, index) {
        return new Container(
          child: new Card(
            color:  storeList[index].UPLOAD_STATUS == "I"? Colors.green:Colors.white,
              child: new GestureDetector(
                onTap:  () {
                  print("attendance");
                  if(storeList[index].UPLOAD_STATUS=="U"){
                    showInSnackBar('Data already uploaded');
                  }
                  else{
                    if(isChecked_in(storeList, index)){
                      showInSnackBar('Please checkout from current store');
                    }
                    else{
                      if(deviation_flag==0){
                        showDialog(context: context, child: new MyForm(onSubmit: onSubmit,index: index, deviation_flag:deviation_flag));
                      }
                      else{
                        openStoreImage(context_global, storeList[index], deviation_flag);
                      }
                      //openStoreImage(context, storeList[index]);
                    }
                  }

                },
                child:new Row(
                  children: <Widget>[
                    new Expanded(child: new Container(
                      margin: EdgeInsets.all(10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Text(
                            storeList[index].STORENAME,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            storeList[index].CITY,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontStyle: FontStyle.normal),
                          ),
                          new Text(
                            storeList[index].STORETYPE,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    ),),
            storeList[index].UPLOAD_STATUS=="U"?Image(image: new AssetImage(
                'assets/tick_icon.png'),
              height: 73.0,
              width: 56.4,): new Icon(Icons.account_balance, color: storeList[index].UPLOAD_STATUS=="I"?Colors.green:Colors.white,),

                  ],
                )
              )),
        );
      },
    );
  }

  Future openStoreImage(BuildContext context, JCPGetterSetter jcp, int deviation_flag) async{
    var isfilled = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreImage(store_data: jcp, deviation_flag: deviation_flag,),
      ),
    );

    if(isfilled!=null){
      //_myStoeListState.setState(() {});
    }
  }

  bool isChecked_in(List<JCPGetterSetter> storeList, int currentIndex){
    bool flag = false;

    if(storeList[currentIndex].UPLOAD_STATUS!="I"){
      for(int i=0;i<storeList.length;i++){

        if(i==currentIndex){
          continue;
        }

        if(storeList[i].UPLOAD_STATUS=="I"){
          flag = true;
          break;
        }
      }
    }


    return flag;
  }

}

typedef void MyFormCallback(String result, int index, int deviation_flag);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;
  int index;
  int deviation_flag;

  MyForm({this.onSubmit, this.index, this.deviation_flag});

  @override
  _MyFormState createState() => new _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String value = "entry";

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Store Entry", style: TextStyle(fontSize: 22.0,color: Colors.blue),),
      children: <Widget>[
        new  Container(
            child:Column(
              children:<Widget>[
                new RadioListTile( value: "Yes",groupValue: value, onChanged: (value) => setState(() => this.value = value),
                  title: new Text("Yes",style: TextStyle(fontSize: 18.0),),
                ),
                new RadioListTile( value: "No",groupValue: value,onChanged: (value) => setState(() => this.value = value),
                  title: new Text("No",style: TextStyle(fontSize: 18.0),),
                ),
              ],
            )
        ),
        new Container(
          margin: EdgeInsets.all(10.0),
          child: new RaisedButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
              widget.onSubmit(value, widget.index, widget.deviation_flag);
            },
            child: new Text("Submit", style: TextStyle(fontSize: 20.0, color: Colors.white),),
          ),
        ),

      ],
    );
  }
}