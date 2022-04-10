import 'dart:convert';
import 'dart:ui';
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
import 'main.dart';

class Experiences extends StatefulWidget {
  Experiences(this.email);
  String email;
  @override
  _Experiences createState() => _Experiences(email);
}

class _Experiences extends State<Experiences> {
  _Experiences(email);
  bool home=true,Mainloader=true,completed,intern,update;
  String post_name,organization,ID;
  List postname=[],companyname=[],experiences=[];

  TextEditingController desc =TextEditingController();
  String get desc2 => desc.text;


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

  void fetchpostname() async {
      final response = await http.get('http://resumeranker.hopto.org/vacancy_post.php');
      if (response.statusCode == 200) {
        setState(() {
          postname = json.decode(response.body);
        });
          final response3 = await http.get(
              'http://resumeranker.hopto.org/getcompnyname.php');
          if (response3.statusCode == 200) {
            setState(() {
              companyname = json.decode(response3.body);
            });
          }
          else{
            error();
          }
      }
      else{
        error();
      }
  }
  String startdate=" ";
  String enddate=' ';
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
  void fetchexperiences() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_experiences.php",
        body: {
          "A":widget.email,
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        experiences = json.decode(response.body);
        Mainloader=false;
        home=true;
      });
    }
    else{
      Mainloader=false;
      error();
    }
  }
  void insert_experiences() async {
    setState(() {
      Mainloader=true;
    });
    if(completed==false){
      enddate='0000-00-00';
    }
    final response = await http.post(
        "http://resumeranker.hopto.org/insert_resume_experiences.php",
        body: {
          "A": widget.email,
          "B":completed.toString(),
          "C":intern.toString(),
          "D":post_name,
          "E":organization,
          "F":startdate,
          "G":enddate,
          "H":desc2,
          "I":ID,
        }
    );
    if (response.statusCode == 200) {
      if(json.decode(response.body)==1){
        fetchexperiences();
      }
    }
    else{
      setState(() {
      Mainloader=false;
      });
      error();
    }
  }
  void deleteexperience(String d)async{
    setState(() {
      Mainloader=true;
    });
    final response = await http.post(
        "http://resumeranker.hopto.org/delete_resume_experiences.php",
        body: {
          "A": d,
        }
    );
    if (response.statusCode == 200) {
      if(json.decode(response.body)==1){
        fetchexperiences();
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
      fetchpostname();
      fetchexperiences();
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
     child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child:Text("Experiences",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
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
        child: home==false?SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
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
                                new DropdownButton(
                                  isExpanded: true,
                                  hint:Text("Designation:",style: new TextStyle(color: Colors.black54),),
                                  items: postname.map((item){
                                    return new DropdownMenuItem(
                                      child:new Text(item['post']),
                                      value: item['post'].toString(),
                                    );

                                  }).toList(),
                                  onChanged: (newVal){
                                    setState(() {
                                      post_name=newVal;
                                    });
                                  },
                                  value: post_name,
                                ),
                                new DropdownButton(
                                  isExpanded: true,
                                  hint: new Text('Organization:'),
                                  items:companyname.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['compnyname']),
                                      value: item['compnyname'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      organization = newVal;
                                    });
                                  },
                                  value: organization,
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
                                TextField(
                                  controller:desc,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      labelText: 'Description:',
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
                                      child:RadioListTile(
                                        groupValue: intern,
                                        title: Text('Intern'),
                                        value: true,
                                        onChanged: (val2) {
                                          setState(() {
                                            intern = val2;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child:RadioListTile(
                                        groupValue: intern,
                                        title: Text('Or Not'),
                                        value:false,
                                        onChanged: (val3) {
                                          setState(() {
                                            intern = val3;
                                          });
                                        },
                                      ),
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
                          if(startdate==' ' || (enddate==' ' && completed == true ) || completed=='' || desc2=='' ||intern=='' || post_name=='' || organization==''){
                            Show_Aleart(context, "Enter All The Details");
                          }
                          else{
                            insert_experiences();
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
                     ]
                  ),
                ),
            ]
          ),
        ):Stack(
          children: <Widget>[
            Container(
              child:Stack(
                children: <Widget>[
                  experiences.length!=0?ListView.builder(
                    itemCount: experiences.length,
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
                                children: <Widget>[
                                   Row(
                                      children: <Widget>[
                                        new Icon(Icons.grade , size: 20,color: Colors.blue,),
                                        Expanded(
                                          child: Text(" "+experiences[index]['post'],style: new TextStyle(fontSize:18,color: Colors.black),),
                                        ),
                                      ],
                                    ),

                                   Row(
                                      children: <Widget>[
                                        new Icon(Icons.account_balance , size: 20,color: Colors.blue,),
                                        Expanded(
                                          child: Text(" "+experiences[index]['company'],style: new TextStyle(fontSize:18,color: Colors.black),),
                                        ),

                                      ],
                                    ),
                                  experiences[index]['completed']=='true'? Row(
                                      children: <Widget>[
                                        new Icon(Icons.date_range , size: 20,color: Colors.blue,),
                                        Expanded(
                                          child:Text(" "+experiences[index]['startdate']+"  To  "+experiences[index]['enddate'],style: new TextStyle(fontSize:18,color: Colors.black),),
                                        ),
                                      ],
                                    ): Row(
                                      children: <Widget>[
                                        new Icon(Icons.date_range , size: 20,color: Colors.blue,),
                                        Expanded(
                                          child:Text(" "+experiences[index]['startdate']+"  To  Running..",style: new TextStyle(fontSize:18,color: Colors.black),),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: <Widget>[
                                        new Icon(Icons.description , size: 20,color: Colors.blue,),
                                        Expanded(
                                          child:Text(" "+experiences[index]['description'] ,style: new TextStyle(fontSize:18,color: Colors.black),),
                                        ),
                                      ],
                                    ),
                                  experiences[index]['intern']=='true'?  Text('As A Intern',style: new TextStyle(fontSize:18,color: Colors.blue),):Text(" "),

                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child:  FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              update=true;
                                              ID=experiences[index]['id'].toString();
                                              if(experiences[index]['completed']=='true'){
                                                completed=true;
                                              }
                                              else{
                                                completed=false;
                                              }
                                              if(experiences[index]['intern']=='true'){
                                               intern=true;
                                              }
                                              else{
                                                intern=false;
                                              }
                                              post_name=experiences[index]['post'];
                                              organization=experiences[index]['company'];
                                              desc =TextEditingController(text:experiences[index]['description']);
                                              startdate=experiences[index]['startdate'];
                                              enddate=experiences[index]['enddate'];
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
                                                          deleteexperience(experiences[index]['id'].toString());
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
                      child:Text("Plese Add Skills.."),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: FloatingActionButton(
                        onPressed:(){
                          bool a;
                          setState(() {
                            update=false;
                            ID='0';
                            completed=a;
                            intern=a;
                            post_name=null;
                            organization=null;
                            startdate=' ';
                            enddate=' ';
                            home=false;
                            desc=TextEditingController(text: null);
                          });

                        },
                        tooltip: 'Add Vacancy',
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