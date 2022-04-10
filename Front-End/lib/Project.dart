import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';


class Projects extends StatefulWidget {
  Projects(this.email);
  String email;
  @override
  _Projects createState() => _Projects(email);
}

class _Projects extends State<Projects> {
  _Projects(email);
  bool home=true,Mainloader=true,completed;
  String startdate=" ",ID;
  String enddate=' ';
  List projects=[];

  TextEditingController desc =TextEditingController();
  String get desc2 => desc.text;

  TextEditingController name =TextEditingController();
  String get name2 => name.text;

  void _selectDate(BuildContext context,int a) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != DateTime.now())
      setState(() {
        DateTime selectedDate = picked;
        if(a==0){
          startdate=selectedDate.toString().split(" ")[0];
        }else{
          enddate=selectedDate.toString().split(" ")[0];
        }

      });
  }
  void error() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sorry....'),
            content: Text('Server Problem ,Try Again Later'),
            actions: <Widget>[

              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Home(widget.email);
                  }));
                },
              )
            ],
          );
        });
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
  void insert_projects() async {
    setState(() {
      Mainloader=true;
    });
    if(completed==false){
      enddate='0000-00-00';
    }
    final response = await http.post(
        "http://resumeranker.hopto.org/insert_resume_projects.php",
        body: {
          "A": widget.email,
          "B":completed.toString(),
          "C":name2,
          "D":desc2,
          "E":startdate,
          "F":enddate,
          "G":ID,
        }
    );
    if (response.statusCode == 200) {
      if(json.decode(response.body)==1){
       fetchprojects();
      }
    }
    else{
      setState(() {
        Mainloader=false;
      });
      error();
    }
  }
  void fetchprojects() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_projects.php",
        body: {
          "A": widget.email,
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        projects = json.decode(response.body);
        print(projects);
        Mainloader=false;
        home=true;
      });
    }
    else{
      Mainloader=false;
      error();
    }
  }
  void deleteprojects(String d)async{
    setState(() {
      Mainloader=true;
    });
    final response = await http.post(
        "http://resumeranker.hopto.org/delete_resume_projects.php",
        body: {
          "A": d,
        }
    );
    if (response.statusCode == 200) {
      if(json.decode(response.body)==1){
       fetchprojects();
      }
    }
    else{
      setState(() {
        Mainloader=false;
      });
      error();
    }
  }
  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0){
      fetchprojects();
      t=t+1;
    }
    return WillPopScope(
        onWillPop: () async {
          if(home==false){
            setState(() {
              home=true;
            });
            return false;
          }
          else{
            return true;
          }
        },
     child:Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child:Text("Projects",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
            ),

            home==true? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child:Text("Done",style: TextStyle(color: Colors.blueGrey, fontFamily: 'design.graffiti.comicsansms'),),
            ):Container(),
          ],
        ),
      ),
      body: Mainloader==false?Center(
        child: home==false?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child:SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child:RadioListTile(
                                        groupValue: completed,
                                        title: Text('Completed'),
                                        value: true,
                                        onChanged: (val1) {
                                          setState(() {
                                            completed = val1;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child:RadioListTile(
                                        groupValue: completed,
                                        title: Text('Pursuing'),
                                        value:false,
                                        onChanged: (val) {
                                          setState(() {
                                            completed = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                TextField(
                                  controller:name,
                                  decoration: InputDecoration(
                                      labelText: 'Title:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),
                                TextField(
                                  controller:desc,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      labelText: 'About Project:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: RaisedButton(
                                        onPressed:(){
                                          _selectDate(context,0);
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.blue,
                                                  size: 15,
                                                ),
                                                Expanded(
                                                  child: Stack(
                                                    children: <Widget>[
                                                      startdate==" " ?Text(" Start Date :",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),):
                                                      Text(startdate,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text("   "),
                                    Expanded(
                                      child: completed!=false?RaisedButton(
                                        onPressed:(){
                                          _selectDate(context,1);
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.blue,
                                                  size: 15,
                                                ),
                                                Expanded(
                                                  child: Stack(
                                                    children: <Widget>[
                                                      enddate==' '? Text(" Ending Date :",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),):
                                                      Text(enddate,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ):Text(" "),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      Text(" "),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.deepPurpleAccent)
                        ),
                        onPressed:(){
                          if(name2=='' || desc2=='' || completed==null || startdate==' ' || (enddate==' ' && completed == true )){
                            Show_Aleart(context, "Enter All The Details");
                          }
                          else{
                            insert_projects();
                          }

                        },
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                        child: Text("Save",style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ):Stack(
          children: <Widget>[
            Container(
              child:Stack(
                children: <Widget>[
                  projects.length!=0?ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(

                        margin: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        //elevation: 3.0,

                        child: new Container(
                          child:SingleChildScrollView(
                            padding: EdgeInsets.all(5),
                            child:Container(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      new Icon(Icons.grade , size: 15,color: Colors.blue),
                                      Expanded(
                                        child: Text(" "+projects[index]['title'],style: new TextStyle(fontSize:15,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Icon(Icons.description , size: 15,color: Colors.blue,),
                                      Expanded(
                                        child:Text(" "+projects[index]['aboutproject'] ,style: new TextStyle(fontSize:15,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                  projects[index]['completed']=='true'? Row(
                                    children: <Widget>[
                                      new Icon(Icons.date_range , size: 15,color: Colors.blue,),
                                      Expanded(
                                        child:Text(" "+projects[index]['startdate']+"  To  "+projects[index]['enddate'],style: new TextStyle(fontSize:15,color: Colors.black),),
                                      ),
                                    ],
                                  ): Row(
                                    children: <Widget>[
                                      new Icon(Icons.date_range , size: 15,color: Colors.blue,),
                                      Expanded(
                                        child:Text(" "+projects[index]['startdate']+"  To  Running..",style: new TextStyle(fontSize:15,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child:  FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              ID=projects[index]['id'].toString();
                                              if(projects[index]['completed']=='true'){
                                                completed=true;
                                              }
                                              else{
                                                completed=false;
                                              }
                                              name=TextEditingController(text:projects[index]['title']);
                                              desc=TextEditingController(text:projects[index]['aboutproject']);
                                              startdate=projects[index]['startdate'];
                                              enddate=projects[index]['enddate'];
                                              home=false;
                                            });

                                          },
                                          child:  new Icon(Icons.update , size: 25,color: Colors.blue,),
                                        ),
                                      ),

                                      Expanded(
                                        child:  FlatButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text('Conformation'),
                                                    content: Text(
                                                        'Are You Sure, You Want To Delete This Vacancy... '),
                                                    actions: <Widget>[
                                                      new FlatButton(
                                                        child: new Text('Yes'),
                                                        onPressed: () {
                                                          deleteprojects(projects[index]['id']);
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      new FlatButton(
                                                        child: new Text('NO'),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          child:  new Icon(Icons.delete_outline , size: 25,color: Colors.blue,),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),

                            ),
                          ),
                        ),
                      );
                    },
                  ):Container(
                    child:Center(
                      child:Text("Add Projects"),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: FloatingActionButton(
                        onPressed:(){
                           setState(() {
                             ID='0';
                             name=TextEditingController(text:'');
                             desc=TextEditingController(text:'');
                             startdate=' ';
                             enddate=' ';
                             completed=null;
                             home=false;
                           });
                        },
                        tooltip: 'Add Project',
                        child: new Icon(Icons.add,size: 30),
                      ),//Your widget here,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ):Center(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(" "),
            CircularProgressIndicator(),
            Text(" "),
            Text("Please Wait"),
          ],
        ),
      ),
     ),
    );
  }
}