import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApplyForJob.dart';
class Exam extends StatefulWidget {
  Exam(this.data,this.type);
  List data=[];
  String type='';
  @override
  _Exam createState() => new _Exam(data,type);
}
class  _Exam extends State<Exam > {
  _Exam(data,type);
  void initState(){
    super. initState();
    fetchdata();
  }
  String Email;
  bool loading = false;
  List vacancydata=[];
  List quedata=[];
  int ind;
  int srno=0;
  var ans;
  int score=0;
  bool opa=false,opb=false,opc=false,opd=false;
  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
      vacancydata=widget.data;
      if(widget.type=='skill test'){
        quedata=vacancydata;
      }else{
        quedata=jsonDecode(vacancydata[0]['que']);
      }

    });
    startTimer();
  }
  Timer _timer;
  int time = 10;
  void startTimer() {
    time = 10;
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) => setState(
            () {
          if (time < 1) {
            _timer.cancel();
            anscheker();
          } else {
            time=time - 1;
          }
        },
      ),
    );
  }
  void insertskillscore(int score)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B": vacancydata[0]['name'],
      "C": vacancydata[0]['lavel'],
      "D": ((score/vacancydata.length)*100).toString(),
    };
    var res = await api(context, "insert_skilltest_score.php", body);
    if(res==1){
      if (srno >= quedata.length - 1) {
        setState(() {
          loading=false;
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }else {
        setState(() {
          srno=srno+1;
          loading = false;
        });
        startTimer();
      }
    }else{
      aleart(context,'Server Did Not Rsponce Try again Later');
      setState(() {
        loading=false;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

  }
  void anscheker() async {
    _timer.cancel();
    setState(() {
      if (ans == quedata[srno]['ans']) {
        score = score + 1;
      }
      opa = false;
      opb = false;
      opc = false;
      opd = false;
      ans = null;
    });
    if (widget.type == "skill test") {
      insertskillscore(score);
    }else{
      if (srno < quedata.length - 1) {
        setState(() {
          srno = srno + 1;
        });
        startTimer();
      } else {
        setState(() {
          loading =true;
        });
          bool res = await applyforjob(
              context, Email, vacancydata[0]['email'], vacancydata[0]['post'],
              ((score / quedata.length) * 100).toString());
          if (res == true) {
            setState(() {
              loading=false;
            });
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }else{
            setState(() {
              loading=false;
            });
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      _timer.cancel();
        return true;
      },
   child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:loading==false?Center(
          child:Container(
            child:SingleChildScrollView(
              child:Padding(
                padding: EdgeInsets.all(width*0.05),
                child: Column(
                  children: [
                    text(context,"Left : "+time.toString()+" second",time>5?Colors.green:Colors.red,width*0.07,FontWeight.w900),
                    SizedBox(height: height*0.05),
                    text(context,"(Que:"+(srno+1).toString()+") : "+quedata[srno]['que'],Colors.black,width*0.05,FontWeight.w700),
                    SizedBox(height: height*0.03),
                    InkWell(
                      onTap:(){
                        setState(() {
                          ans='A';
                          opa=true;
                          opb=false;
                          opc=false;
                          opd=false;
                        });
                      },
                      child:Container(
                        color: opa==false?Colors.lightBlueAccent:Colors.blue,
                          width: width,
                          padding: EdgeInsets.all(width*0.03),
                          margin: EdgeInsets.all(width*0.03),
                          child:text(context,"A) "+quedata[srno]['a'],Colors.black,width*0.05,FontWeight.normal),
                      ),
                    ),
                    InkWell(
                      onTap:(){
                        setState(() {
                          ans='B';
                          opa=false;
                          opb=true;
                          opc=false;
                          opd=false;
                        });
                      },
                      child:Container(
                        color: opb==false?Colors.lightBlueAccent:Colors.blue,
                        width: width,
                        padding: EdgeInsets.all(width*0.03),
                        margin: EdgeInsets.all(width*0.03),
                        child:text(context,"B) "+quedata[srno]['b'],Colors.black,width*0.05,FontWeight.normal),
                      ),
                    ),
                    InkWell(
                      onTap:(){
                        setState(() {
                          ans='C';
                          opa=false;
                          opb=false;
                          opc=true;
                          opd=false;
                        });
                      },
                      child:Container(
                        color: opc==false?Colors.lightBlueAccent:Colors.blue,
                        width: width,
                        padding: EdgeInsets.all(width*0.03),
                        margin: EdgeInsets.all(width*0.03),
                        child:text(context,"C) "+quedata[srno]['c'],Colors.black,width*0.05,FontWeight.normal),
                      ),
                    ),
                    InkWell(
                      onTap:(){
                        setState(() {
                          ans='D';
                          opa=false;
                          opb=false;
                          opc=false;
                          opd=true;
                        });
                      },
                      child:Container(
                        color: opd==false?Colors.lightBlueAccent:Colors.blue,
                        width: width,
                        padding: EdgeInsets.all(width*0.03),
                        margin: EdgeInsets.all(width*0.03),
                        child:text(context,"D) "+quedata[srno]['d'],Colors.black,width*0.05,FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: height*0.03),
                    btn(context,"Next Question",width*0.06,height*0.07,width*0.50,anscheker),
                    SizedBox(height: height*0.03),
                  ],
                ),
              ),
            ),
          ),
        ):progressindicator(context),
      ),
   ),
    );
  }
}