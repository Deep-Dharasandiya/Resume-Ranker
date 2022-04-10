import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Exam.dart';
class TechnicalSkillTest extends StatefulWidget {
  @override
  _TechnicalSkillTest createState() => new _TechnicalSkillTest();
}
class  _TechnicalSkillTest extends State<TechnicalSkillTest > {

  void initState(){
    super. initState();
    fetchdata();
  }
  String Email;
  bool loading = true;
  List quedata=[];
  List skills=[];
  String selectedskill,selectedlavel;

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    fetchapplicantskilldata();
  }
  void fetchapplicantskilldata()async{
    var res = await api(context, "get_resume_technicalskills.php", {"A":Email});
    setState(() {
      skills=res;
      loading=false;
    });
  }
  void fetchapptestquedata(var name,var lavel)async{
    List res=[];
    res = await api(context, "get_skilltest_que.php", {"A":name,"B":lavel});
    setState(() {
      loading=false;
    });

     Navigator.push(context, MaterialPageRoute(builder: (context){
      return Exam(res,'skill test');
    }));

  }
  void startexam(var name,var lavel){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Aleart'),
            content: Text('Do you want to start exam'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                 setState(() {
                   loading=true;
                 });
                 fetchapptestquedata(name,lavel);
                 Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Technical Skill Test'),
        ),
        body:loading==false?Container(
          child:Container(
            child:SingleChildScrollView(
              child:Padding(
                padding: EdgeInsets.only(top:width*0.05),
                child: Column(
                  children: [
                    text(context,"Details and rules",Colors.black,width*0.05,FontWeight.normal),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(8),
                        itemCount: skills.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap:(){
                              if(skills[index]['eligible']=='true'){
                                startexam(skills[index]['name'], skills[index]['lavel']);
                              }else{
                                aleart(context, "You have already give test so can not eligible.");
                              }

                            },
                            child: Card(
                              color: skills[index]['eligible']=='true'?Colors.lightBlueAccent:Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Column(
                                children: [
                                  text(context,skills[index]['name'],Colors.black,width*0.05,FontWeight.normal),
                                  text(context,skills[index]['lavel'],Colors.black,width*0.05,FontWeight.normal),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                    SizedBox(
                      height:height*0.05,
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