
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder/CertificateInfo.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder/EduacationInfo.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder/ExperienceInfo.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder/PersonInfo.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder/ProjectInfo.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder/TechnicalSkillInfo.dart';
import 'package:flutter_app2/Applicant/ShowVacancy.dart';
import 'package:flutter_app2/ShowResume.dart';
import '../Component/utils.dart';
import '../Component/SizeRatio.dart';
import '../Component/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ApplicantHome.dart';
class ResumeBuilder extends StatefulWidget {
  ResumeBuilder(flag);
  String flag;
  @override
  _ResumeBuilder createState() => new _ResumeBuilder(flag);
}

class  _ResumeBuilder extends State<ResumeBuilder > {
  _ResumeBuilder(flag);
  void personinfo(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return PersonInfo();
    }));
  }
  void eduacation(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return EduacationInfo();
    }));
  }
  void experience(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ExperienceInfo();
    }));
  }
  void technicalskills(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return TechnicalSkillInfo();
    }));
  }
  void projects(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ProjectInfo();
    }));
  }
  void certificate(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return CertificateInfo();
    }));
  }
  void myresume(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ShowResume([],[],[],[],[],[]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(widget.flag=="show resume"){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ApplicantHome();
            }));
          }else{
            Navigator.of(context).pop();
          }
          return false;
        },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
        title: Text('Resume'),
        ),
        body:Container(
          child:Padding(
            padding: EdgeInsets.all(width*0.05),
            child: Column(
              children: [
                SizedBox(height: height*0.05),
                simplebtn(context,"Person Info",width*0.05,height*0.07,width,personinfo),
                SizedBox(height: height*0.01),
                simplebtn(context,"Eduacation",width*0.05,height*0.07,width,eduacation),
                SizedBox(height: height*0.01),
                simplebtn(context,"Experience",width*0.05,height*0.07,width,experience),
                SizedBox(height: height*0.01),
                simplebtn(context,"Technical Skill",width*0.05,height*0.07,width,technicalskills),
                SizedBox(height: height*0.01),
                simplebtn(context,"Projects",width*0.05,height*0.07,width,projects),
                SizedBox(height: height*0.01),
                simplebtn(context,"Certificates",width*0.05,height*0.07,width,certificate),
                SizedBox(height: height*0.05),
                simplebtn(context,"My Resume",width*0.05,height*0.07,width,myresume),
                SizedBox(height: height*0.05),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
