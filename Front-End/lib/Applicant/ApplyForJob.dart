import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Exam.dart';
class ApplyForJob extends StatefulWidget {
  ApplyForJob(this.data,this.examflag);
  List data=[];
  String examflag;
  @override
  _ApplyForJob createState() => new _ApplyForJob(data,examflag);
}
class  _ApplyForJob extends State<ApplyForJob > {
  _ApplyForJob(data,examflag);
  void initState(){
    super. initState();
    fetchdata();
  }
  String Email;
  bool loading = false;
  List vacancydata=[];
  List quedata=[];
  int ind;
  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
      vacancydata=widget.data;
      quedata=jsonDecode(vacancydata[0]['que']);
    });
  }
  void apply()async{
    setState(() {
      loading=true;
    });
    bool res=await applyforjob(context,Email,vacancydata[0]['email'],vacancydata[0]['post'],'NA');
    if(res==true){
      setState(() {
        loading=true;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }else{
      setState(() {
        loading=true;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
  void startexam(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Exam(vacancydata,'recruiter test');
    }));
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body:loading==false?Center(
            child:Container(
              child:SingleChildScrollView(
                child:Padding(
                  padding: EdgeInsets.all(width*0.05),
                  child: Column(
                    children: [
                      text(context,"Details and rules",Colors.black,width*0.05,FontWeight.normal),
                      Row(
                        children: [
                          quedata.length!=0 && widget.examflag=='true'?Expanded(child: btn(context,"Start Exam",width*0.06,height*0.07,width*0.60,startexam)):
                          Expanded(child: btn(context,"Confirm & Apply",width*0.06,height*0.07,width*0.60,apply)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ):progressindicator(context),
        ),
    );
  }
}