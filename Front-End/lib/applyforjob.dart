import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/HomePageApplicant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
class applyforjob extends StatefulWidget {
  applyforjob (this.email,this.compnyname,this.compnyemail,this.post,this.test);
final String email,compnyname,compnyemail,post;
List test=[];
@override
_applyforjob  createState() => new _applyforjob (email,compnyname,compnyemail,post,test);
}

class _applyforjob  extends State<applyforjob > {
  _applyforjob (email,compnyname,compnyemail,post,test);
  bool con,Apptitudetest=false;
  bool server1Selected = false;
  bool server2Selected = false;
  bool server3Selected = false;
  bool server4Selected = false;
  int Apptestsrno=1;
  void assign(var s,int p)
  {
    ans[Apptestsrno]=s;
    setState(() {
      server1Selected = false;
      server2Selected = false;
      server3Selected = false;
      server4Selected = false;
    });
    if(p==1)
    {
      setState(() {
        server1Selected = true;
      });
    }
    else if(p==2)
    {
      setState(() {
        server2Selected = true;
      });
    }
    else if(p==3){
      setState(() {
        server3Selected = true;
      });
    }
    else if(p==4){
      setState(() {
        server4Selected = true;
      });
    }
  }
  int _start = 10;
  int time;
  int indicateskill=0;
bool push=true;
  void startTimer() {

    _start = 10;
    Timer _timer;

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
              () {
            time = _start;
            _start = _start - 1;
            if (_start < 1) {
              setState(() {
                server1Selected = false;
                server2Selected = false;
                server3Selected = false;
                server4Selected = false;
                if(Apptestsrno<=10){
                  if(Apptestsrno<10){
                    Apptestsrno=Apptestsrno+1;
                    startTimer();
                  }
                  if(Apptestsrno==10){

                    timer.cancel();
                    if(push==true) {
                      checkans();
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Homepage(widget.email);
                      }));
                    }
                  }
                }

              });
              if(Apptestsrno<10) {
                _start = 10;
              }
            }
          }
      ),
    );

  }
  var ans = new List(11);
  int score;
  void checkans(){
    int count=0;
    for(int i=1;i<=10;i++){
      if(ans[i]==widget.test[i-1]["ans"]){
        count=count+1;
      }
    }
    score=count;
    print(score);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child:Column(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.fromLTRB(5,5,5,5),
                    child:Container(
                    child:Apptitudetest==false?Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                        child:Card(
                        margin: EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child:  Column(
                        children: <Widget>[
                          Text("fsfvndsifdsfv dsvfnds iif j nifx f fxn g ixf ffiu f f nf g ss gsg  gnn n fg nsijbs bjbnsiuvresa"
                              "vvdsvfdvfbsdnvmkv fjdbsj sninsnbb bfjfndsf"
                              ""
                              "dmfdvdbngbbnbinbbibgbkf kfb knbnbkfmmbiznfvifvn"),
                          RadioListTile(
                            groupValue: con,
                            title: Text('Accept '),
                            value: true,
                            onChanged: (val1) {
                              setState(() {
                                con = val1;
                              });
                            },
                          ),
                          RadioListTile(
                            groupValue: con,
                            title: Text('Decline'),
                            value: false,
                            onChanged: (val1) {
                              setState(() {
                                con = val1;
                              });
                            },
                          ),
                          con==true?Container(
                            child: Column(
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)
                                  ),
                                  onPressed:(){
                                     setState(() {
                                       Apptitudetest=true;
                                       startTimer();
                                     });
                                  },
                                  color:  Colors.blue,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child:Center(
                                    child: Text("Start Apptitude test",style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                  ),
                                ),

                              ],
                            ),
                          ):Container(),

                        ],
                      ),
                        ),
                    ):
                    Container(
                      child:Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(0,50.0,0,0),
                            child:Card(
                              margin: EdgeInsets.all(7.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10.0,50.0,10.0,10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(_start.toString(),style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                    Text("Question: "+Apptestsrno.toString(),style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                    Text(" "),
                                    Text("=> "+widget.test[Apptestsrno-1]["que"],style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                    Text(" "),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(0,0.0,0,0),
                            child:Card(
                              margin: EdgeInsets.all(7.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10.0,17.0,10.0,10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(_start.toString(),style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                    Text("Select One Of This:",style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                    Text(" "),
                                    Container(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red)
                                        ),
                                        onPressed:(){
                                          assign("A",1);
                                        },
                                        color: server1Selected == true ? Colors.green : Colors.blue,
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child:Center(
                                          child: Text(widget.test[Apptestsrno-1]["a"],style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'design.graffiti.comicsansms'),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red)
                                        ),
                                        onPressed:(){
                                          assign("B",2);
                                        },
                                        color: server2Selected == true ? Colors.green : Colors.blue,
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child:Center(
                                          child: Text(widget.test[Apptestsrno-1]["b"],style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'design.graffiti.comicsansms'),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red)
                                        ),
                                        onPressed:(){
                                          assign("C",3);
                                        },
                                        color: server3Selected == true ? Colors.green : Colors.blue,
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child:Center(
                                          child: Text(widget.test[Apptestsrno-1]["c"],style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'design.graffiti.comicsansms'),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red)
                                        ),
                                        onPressed:(){
                                          assign("D",4);
                                        },
                                        color: server4Selected == true ? Colors.green : Colors.blue,
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child:Center(
                                          child: Text(widget.test[Apptestsrno-1]["d"],style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'design.graffiti.comicsansms'),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(0,10.0,0,0),
                            child:Card(
                              margin: EdgeInsets.all(7.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10.0,25.0,10.0,10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.blue)
                                      ),
                                      onPressed:(){
                                        setState(() {
                                          if(Apptestsrno<10){
                                            server1Selected = false;
                                            server2Selected = false;
                                            server3Selected = false;
                                            server4Selected = false;
                                            Apptestsrno=Apptestsrno+1;
                                           _start=10;
                                          }
                                          else{
                                            server1Selected = false;
                                            server2Selected = false;
                                            server3Selected = false;
                                            server4Selected = false;
                                            checkans();
                                            setState(() {
                                              push=false;
                                            });
                                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return Homepage(widget.email);
                                            }));
                                          }

                                        });
                                      },
                                      color: Colors.redAccent,
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child:Center(
                                        child: Apptestsrno==10?Text("Apply For Job",style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'design.graffiti.comicsansms'),):Text("Next Que",style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'design.graffiti.comicsansms'),),
                                      ),
                                    ),
                                    Text(" "),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
