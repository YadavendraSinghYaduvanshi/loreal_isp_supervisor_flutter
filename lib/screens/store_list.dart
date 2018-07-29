import 'package:flutter/material.dart';
import 'package:loreal_isp_supervisor_flutter/gettersetter/all_gettersetter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loreal_isp_supervisor_flutter/database/dbhelper.dart';
import 'store_img.dart';

_StoreListState _myStoeListState = new _StoreListState();

class StoreList extends StatefulWidget {

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
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              //_loadCounter();
              return snapshot.hasData
                  ? storeListList(
                storeList: snapshot.data,scaffoldKey: _scaffoldKey,)
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

class storeListList extends StatelessWidget {
  final List<JCPGetterSetter> storeList;
  final GlobalKey<ScaffoldState> scaffoldKey;

  storeListList({Key key, this.storeList, this.scaffoldKey}) : super(key: key);

  void showInSnackBar(String message) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  Widget build(BuildContext context) {
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
                      openStoreImage(context, storeList[index]);
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
              width: 56.4,): new Icon(Icons.account_balance, color: Colors.white,),

                  ],
                )
              )),
        );
      },
    );
  }

  Future openStoreImage(BuildContext context, JCPGetterSetter jcp) async{
    var isfilled = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreImage(store_data: jcp),
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