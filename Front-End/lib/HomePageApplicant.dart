import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'LoaderHomePageApplicantToShowVacancy.dart';
import 'LoaderHomePageToResumeBuilder.dart';
import 'main.dart';

class Homepage extends StatefulWidget {
  Homepage(this.email);
  final String email;

  @override
  _UploadVacncy createState() => new _UploadVacncy(email);
}

class _UploadVacncy extends State<Homepage> {
  _UploadVacncy(email);
  int t=0;
  List data3=[];

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
          return LoderHomePageApplicantToShowVacancy(widget.email);
        }));
      }
      else if(r==2)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          // return Ranking_page();
          return  LoderHomePageApplicantToResumeBuilder(widget.email);
        }));
      }
      else if(r==3)
      {
       /* Navigator.push(context, MaterialPageRoute(builder: (context){
          return Applyforjob(widget.email,data3);
        }));*/
      }
      else
      {
        /*Navigator.push(context, MaterialPageRoute(builder: (context){
          return Ranking_page();
        }));*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double hight = MediaQuery. of(context). size. height;
    double space;
    double space_up;
    space=width/hight;
    space_up=space;
    if(hight<width)
    {
      space_up=space/6;
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
         debugShowCheckedModeBanner:false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Home'),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.delete_forever),
                  tooltip: "Logout",
                  onPressed: () {
                    cencal();
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Loginpage();
                    }));
                  },
                ),
              ],
            ),


            body: Center(

                child: Container(
                    constraints: BoxConstraints.expand(),
                    height: hight,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: new AssetImage('assets/bach8.jpg'),
                            fit: BoxFit.cover)
                    ),
                    /*child: Center(child: Text('Set Full Screen Background Image in Flutter',
                      textAlign: TextAlign.center, style:

                     */
                    child: GridView.count(
                      primary: true,
                      padding:  EdgeInsets.fromLTRB(space*25, space_up*420, space*25, 0.0),

                      crossAxisSpacing: space*25,
                      mainAxisSpacing: space*25,
                      crossAxisCount: 2,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(

                              color: Colors.white,

                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0,15.0),
                                    blurRadius: 20.0),
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0,-5.0),
                                    blurRadius: 15.0),
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0),
                            child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(1.0,1.0,1.0,1.0),
                                  child: Image.asset("assets/vacancy.jfif"),),

                                InkWell(
                                  onTap: (){
                                    networkcheck(1);
                                  },

                                  child:Center(
                                    child: Text("Show Vancancy",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "design.graffiti.comicsansms",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        Container(
                          decoration: BoxDecoration(

                              color: Colors.white,

                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0,15.0),
                                    blurRadius: 20.0),
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0,-5.0),
                                    blurRadius: 15.0),
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0),
                            child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(1.0,1.0,1.0,1.0),
                                  child: Image.asset("assets/resume.jpg"),),

                                InkWell(
                                  onTap: (){
                                    networkcheck(2);
                                  },

                                  child:Center(
                                    child: Text("Resume Builde",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "design.graffiti.comicsansms",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        Container(
                          decoration: BoxDecoration(

                              color: Colors.white,

                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0,15.0),
                                    blurRadius: 20.0),
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0,-5.0),
                                    blurRadius: 15.0),
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0),
                            child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(1.0,1.0,1.0,1.0),
                                  child: Image.asset("assets/Result.jpg"),),

                                InkWell(
                                  onTap: (){
                                    networkcheck(3);
                                  },

                                  child:Center(
                                    child: Text("Apply for job",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "design.graffiti.comicsansms",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        Container(
                          decoration: BoxDecoration(

                              color: Colors.white,

                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0,15.0),
                                    blurRadius: 20.0),
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0,-5.0),
                                    blurRadius: 15.0),
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0),
                            child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(1.0,1.0,1.0,1.0),
                                  child: Image.asset("assets/Result.jpg"),),

                                InkWell(
                                  onTap: (){
                                    networkcheck(4);
                                  },

                                  child:Center(
                                    child: Text("Result",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "design.graffiti.comicsansms",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    )

                )
            ),
        )
    ),
    );

  }
}