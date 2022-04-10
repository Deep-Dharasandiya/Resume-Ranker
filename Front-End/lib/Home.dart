import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'DisplayVacancy.dart';
import 'LoaderHomePageApplicantToShowVacancy.dart';
import 'LoaderHomePageToResumeBuilder.dart';

import 'ResumeHome.dart';
import 'ShowResume.dart';
import 'main.dart';

class Home extends StatefulWidget {
  Home(this.email);
  String email;

  @override
  _Home createState() => new _Home(email);
}

class _Home extends State<Home> {
  _Home(email);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name=' ';
  void getname()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString('Name');
    });
  }

  Future<void> cencal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('intvalue');
    prefs.remove('Email');
  }
  Show_Aleart(BuildContext context,String message) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text(message),
            actions: <Widget>[

              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void networkcheck(int r) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      Show_Aleart(context, "This Device Not Connected To Internet...");
    }
    else {
      if(r==1)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return DisplayVacancy(widget.email);
        }));
      }
      else if(r==2)
      {


      }
      else if(r==3)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context){
        return  ResumeHome(widget.email);
        }));
      }
      else if(r==4)
      {
       /* Navigator.push(context, MaterialPageRoute(builder: (context){
          return AppTest();
        }));*/
      }
      else{

      }
    }
  }

  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0){
      getname();
      t=t+1;
    }
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    double space;
    double space_up;
    space = width / hight;
    space_up = space;
    if (hight < width) {
      space_up = space / 6;
    }
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Aleart'),
                content: Text('Do you want to Exit'),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Yes'),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });

        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          drawer:new Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:40),
                  child:SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("   "),
                            Icon(Icons.person,size:25,color: Colors.black,),
                            Expanded(
                              child:Text(" "+name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25, fontFamily: 'design.graffiti.comicsansms'),),
                            ),
                          ],
                        ),
                        Text("   "+widget.email,style: TextStyle(color: Colors.black,fontSize: 15, fontFamily: 'design.graffiti.comicsansms'),),
                        Divider(
                          color: Colors.black,
                        ),
                        ListTile(leading: Icon(Icons.book),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('Show Resume',style: TextStyle(fontSize: 18),),
                          ),
                          onTap: (){
                            networkcheck(2);
                          },
                        ),
                        ListTile(leading: Icon(Icons.shopping_cart),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('Edit Resume',style: TextStyle(fontSize: 18),
                          ),
                          ),
                          onTap: (){
                            networkcheck(3);
                          },
                        ),
                        ListTile(leading: Icon(Icons.card_giftcard),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('AppTest',style: TextStyle(fontSize: 18),
                          ),

                          ),
                          onTap: (){

                          },
                        ),
                        ListTile(leading: Icon(Icons.notifications_active),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('My notifications',style: TextStyle(fontSize: 18),
                          ),
                          ),
                          onTap: (){

                          },
                        ),
                        ListTile(leading: Icon(Icons.shopping_basket),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('offer Zone',style: TextStyle(fontSize: 18),
                          ),

                          ),
                          onTap: (){

                          },
                        ),
                        ListTile(leading: Icon(Icons.supervised_user_circle),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('About us',style: TextStyle(fontSize: 18),
                          ),

                          ),
                          onTap: (){

                          },
                        ),
                        ListTile(leading: Icon(Icons.record_voice_over),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('Contact us',style: TextStyle(fontSize: 18),
                          ),

                          ),
                          onTap: (){

                          },
                        ),
                        ListTile(leading: Icon(Icons.exit_to_app),
                          title: Transform(
                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                            child: Text('sign out',style: TextStyle(fontSize: 18),
                          ),

                          ),
                          onTap: (){
                            cencal();
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return Loginpage();
                            }));
                          },
                        ),
                        SizedBox.fromSize(
                          size: Size.fromHeight(25),
                        ),

                        Container(
                          child:Center(
                            child:Container(

                              // margin: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                              height: 100,
                              width: 100,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                  image: new AssetImage("assets/appicon.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            leading:IconButton(icon: Icon(Icons.menu,color: Colors.black),
              tooltip: "Drawer",
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ) ,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            title:Transform(
              transform: Matrix4.translationValues(-20, 0.0, 0.0),
              child: Text("Home",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
            ),
            actions: <Widget>[
            ],
          ),

          body: SingleChildScrollView(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //constraints: BoxConstraints.expand(),
                        height: hight/2.3,
                        width:width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: new AssetImage('assets/mountain.jpg'),
                                fit: BoxFit.cover)
                        ),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:Container(
                                height: hight/16,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  border: new Border.all(
                                    color: Colors.black,
                                    width: .2,
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(20, hight/4, 0, 20),
                                padding: EdgeInsets.fromLTRB(14*space,10*space, 14*space,space),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child:  new TextField(
                                        textAlign: TextAlign.start,
                                        //textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: hight/40,
                                            //height: hight/50,
                                            color: Colors.black
                                        ),
                                        decoration: new InputDecoration(
                                          hintText: 'City',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,hight/4, 20, 20),
                              height: hight/16,
                              width: hight/16,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                                color: Colors.lightBlue,
                                border: new Border.all(
                                  color: Colors.black,
                                  width: .2,
                                ),
                              ),
                              child:IconButton(icon: Icon(Icons.search,color: Colors.white),
                                tooltip: "Search",
                                onPressed: () {
                                },
                              ) ,
                            ),
                          ],
                        ),
                      ),
                      Text(" "),
                      Text("  Job in best City",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        height: 100.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(" "),
                      Text("  Job in best City",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        height: 100.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: new AssetImage('assets/resume01.jpeg'),
                                        fit: BoxFit.cover)
                                ),
                                child: Center(
                                  child: Text("Ahmedabad",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                      fontFamily: 'design.graffiti.comicsansms'),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(" "),
                      Container(
                        child: Center(
                          child:Text("Or",style: TextStyle( fontSize: 20, fontFamily: 'design.graffiti.comicsansms'),),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child:RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              side: BorderSide(color: Colors.lightBlue)
                          ),
                          onPressed:(){
                            networkcheck(1);
                          },
                          color: Colors.lightBlue,
                          padding: EdgeInsets.all(15),
                          child:Center(
                            child: Text("View all Jobs",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'design.graffiti.comicsansms'),),
                          ),
                        ),
                      ),



                    ],
                  )
          ),
        ),
      ),
    );
  }
}
