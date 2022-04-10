import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'Home.dart';
import 'LoaderHomePageApplicantToShowVacancy.dart';
import 'LoaderHomePageToResumeBuilder.dart';
import 'TechnicalSkills.dart';

class Quize extends StatefulWidget {
  Quize(this.email,this.skill,this.level,this.id);
  String email,skill,level,id;

  @override
  _Quize createState() => new _Quize(email,skill,level,id);
}

class _Quize extends State<Quize> {
  _Quize(email,skill,level,id);
 bool Mainloader=true,aa=false,bb=false,cc=false,dd=false;
 int srno=0;
 List Que=[];
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
  void insert_person_info() async {
    setState(() {
      Mainloader=true;
    });
    final response = await http.post(
        "http://resumeranker.hopto.org/insert_resume_technicalskills.php",
        body: {
          "A": widget.email,
          "B":widget.skill,
          "C":widget.level,
          "D":widget.id,
        }
    );
    if (response.statusCode == 200) {
      if(json.decode(response.body)==1){

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
    else{
      setState(() {
        Mainloader=false;
      });
      error();
    }
  }
 void srnocheck() async {
   final response = await http.post("http://resumeranker.hopto.org/get_srnoofapptestque.php",
       body: {
         "A": widget.email,
         "B": widget.skill,
         "C": widget.level,
       }
   );
   setState(() {
     srno =  int.parse(json.decode(response.body));
   });
   print(json.decode(response.body));
  if(srno<5){
    fetchQue();
  }
  else{
    insert_person_info();
  }


 }
  void fetchQue() async {
    final response = await http.post("http://resumeranker.hopto.org/get_que_ofapptest.php",
        body: {
          "A": widget.email,
          "B": widget.skill,
          "C": widget.level,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        Que = json.decode(response.body);
        Mainloader=false;
      });
      startTimer();
    }


  }
 void optionselector(int i){
   if(i==1){
     setState(() {
       aa=true;
       bb=cc=dd=false;
     });
   }
   else if(i==2){
     setState(() {
       bb=true;
       aa=cc=dd=false;
     });
   }
   else if(i==3){
     setState(() {
       cc=true;
       aa=bb=dd=false;
     });
   }
   else{
     setState(() {
       dd=true;
       aa=bb=cc=false;
     });
   }
 }
 void anscheker()async{
   setState(() {
     Mainloader=true;
   });
   String Answer;
   if(aa==true){
     Answer='A';
   }
   else if(bb==true){
     Answer='B';
   }
   else if(cc==true){
     Answer='C';
   }
   else if(dd==true){
     Answer='D';
   }
   else{
     Answer='Skip';
   }
   final response = await http.post("http://resumeranker.hopto.org/insert_apptestresult.php",
       body: {
         "A": widget.email,
         "B": widget.skill,
         "C": widget.level,
         "D": (srno+1).toString(),
         "E": Answer,
       }
   );
   var respbody = json.decode(response.body);
   if(respbody == 1)
   {
     if(srno<4){

       setState(() {
         aa=bb=cc=dd=false;
         _start=10;
         srno=srno+1;
         Mainloader=false;
       });
       startTimer();
     }
     else{
       insert_person_info();

     }
   }
   else{
     error();
   }


 }

 Timer _timer;
 int _start = 10;

 void startTimer() {
   _start = 10;
 /*  if (_timer != null) {
     _timer.cancel();
     _timer = null;
   } else */
     _timer = new Timer.periodic(
       const Duration(seconds: 1),
           (Timer timer) => setState(
             () {
           if (_start < 1) {
             _timer.cancel();
             anscheker();
           } else {
             _start = _start - 1;
           }
         },
       ),
     );
 }
 int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0){
      srnocheck();
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
              title: Text('If You Want Cencel This Skill '),
              content: Text('Quize Not Completed...'),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Yes'),
                  onPressed: () {
                    _timer.cancel();
                    Navigator.of(context).pop();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: Text("Quize",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),

          actions: <Widget>[
          ],
        ),
        body:Container(
            constraints: BoxConstraints.expand(),
            height: hight,
            //width: width,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: new AssetImage('assets/resume01.jpeg'),
            fit: BoxFit.cover)
            ),
          child:Center(
            child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Mainloader==false? Container(
                   child:Card(
                     margin: EdgeInsets.all(5),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     child: Container(
                       padding: EdgeInsets.all(8),
                       child: Column(
                         children: <Widget>[
                           Text(_start.toString(),style: new TextStyle(fontSize: 30.0,color: _start>5?Colors.blue:Colors.red,fontFamily: 'design.graffiti.comicsansms'),),
                           SizedBox(height: 3.0),
                           Text("Quetion: "+(srno+1).toString(),style: new TextStyle(fontSize: 20,color: Colors.black,fontFamily: 'design.graffiti.comicsansms'),),
                           SizedBox(height: 3.0),
                           Text("   "+Que[srno]['que'].toString(),style: new TextStyle(fontSize: 15,color: Colors.black,fontFamily: 'design.graffiti.comicsansms'),),
                           SizedBox(height: 10.0),
                           RaisedButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(18.0),
                                 side: BorderSide(color: Colors.black)
                             ),
                             onPressed:(){
                               optionselector(1);
                             },
                             color: Colors.white,
                             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                             child:Center(
                               child: Row(
                                 children: <Widget>[
                                   Icon(
                                     aa==false?Icons.radio_button_unchecked:Icons.radio_button_checked,
                                     color: Colors.black,
                                   ),
                                   Expanded(
                                     child:Text(' '+Que[srno]['A'],style: TextStyle(
                                         color: Colors.black,
                                         //fontWeight: FontWeight.bold,
                                         fontSize: 15,
                                         fontFamily: 'design.graffiti.comicsansms'),),
                                   ),

                                 ],
                               ),
                             ),
                           ),
                           SizedBox(height: 5.0),
                           RaisedButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(18.0),
                                 side: BorderSide(color: Colors.black)
                             ),
                             onPressed:(){
                               optionselector(2);
                             },
                             color: Colors.white,
                             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                             child:Center(
                               child: Row(
                                 children: <Widget>[
                                   Icon(
                                     bb==false?Icons.radio_button_unchecked:Icons.radio_button_checked,
                                     color: Colors.black,
                                   ),
                                   Expanded(
                                       child: Text(' '+Que[srno]['B'],style: TextStyle(
                                           color: Colors.black,
                                           //fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                           fontFamily: 'design.graffiti.comicsansms'),),
                                   ),

                                 ],
                               ),
                             ),
                           ),
                           SizedBox(height: 5.0),
                           RaisedButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(18.0),
                                 side: BorderSide(color: Colors.black)
                             ),
                             onPressed:(){
                               optionselector(3);
                             },
                             color: Colors.white,
                             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                             child:Center(
                               child: Row(
                                 children: <Widget>[
                                   Icon(
                                     cc==false?Icons.radio_button_unchecked:Icons.radio_button_checked,
                                     color: Colors.black,
                                   ),
                                   Expanded(
                                       child:Text(' '+Que[srno]['C'],style: TextStyle(
                                           color: Colors.black,
                                           //fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                           fontFamily: 'design.graffiti.comicsansms'),),
                                   ),

                                 ],
                               ),
                             ),
                           ),
                           SizedBox(height: 5.0),
                           RaisedButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(18.0),
                                 side: BorderSide(color: Colors.black)
                             ),
                             onPressed:(){
                               optionselector(4);
                             },
                             color: Colors.white,
                             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                             child:Center(
                               child: Row(
                                 children: <Widget>[
                                   Icon(
                                     dd==false?Icons.radio_button_unchecked:Icons.radio_button_checked,
                                     color: Colors.black,
                                   ),
                                   Expanded(
                                       child:Text(' '+Que[srno]['D'],style: TextStyle(
                                           color: Colors.black,
                                           //fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                           fontFamily: 'design.graffiti.comicsansms'),),
                                   ),

                                 ],
                               ),
                             ),
                           ),
                           SizedBox(height: 10.0),
                           RaisedButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(18.0),
                                 side: BorderSide(color: Colors.deepPurpleAccent)
                             ),
                             onPressed:(){
                               _timer.cancel();
                               anscheker();
                             },
                             color: Colors.blue,
                             padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                             child: Text("Next",style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                                 fontFamily: 'design.graffiti.comicsansms'),),
                           ),

                         ],
                       ),
                     ),
                     elevation: 5,
                   ),
                  ):Container(
                    child:Center(
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
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}