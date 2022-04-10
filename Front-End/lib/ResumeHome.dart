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

import 'Certificate.dart';
import 'Education.dart';
import 'Experience.dart';
import 'Home.dart';
import 'PersonInfo.dart';
import 'Project.dart';
import 'TechnicalSkills.dart';
import 'main.dart';

class ResumeHome extends StatefulWidget {
  ResumeHome(this.email);
  String email;
  @override
  _ResumeHome createState() => _ResumeHome(email);
}

class _ResumeHome extends State<ResumeHome> {
  _ResumeHome(email);
  bool expandbutton=false,type=false;
  int biounit;
  List person=[],eduacation=[],skill_selected=[],experiences=[],certificates=[],projects=[];
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
  /*void showImage(String a){
    showDialog(
        context: context,
        builder: (context) {
          return Zoom(
              width: 1000,
              height: 1000,
              child: Center(
                child: Container(
                  width: 1000,
                  height: 1000,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: Image.memory(base64Decode(a)).image)
                  ),
                ),
              )
          );
          /*Container(
            padding: EdgeInsets.all(50),
            child:Container(
              height:10,
              width: 10,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: Image.memory(base64Decode(a)).image)
              ),
            ),
          );*/
        });
  }*/
 /* void checker(){
    int count=0;
    for(int i=0;i<experiences.length;i++){
      if(experiences[i]['intern']=='false'){
        count=count+1;
      }
    }
    if(count !=0){
      setState(() {
        type=true;
      });
    }
  }
  void fetchpersoninfo() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_person_info.php",
        body: {
          "A": "bhavy@gmail.com",
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        person = json.decode(response.body);
      });
      fetcheduacation();

    }
    else{
      error();
    }
  }
  void fetcheduacation() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_eduacation.php",
        body: {
          "A": "bhavy@gmail.com",
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        eduacation = json.decode(response.body);
      });

      fetchtechnicalskill();

    }
    else{
      error();
    }
  }
  void fetchtechnicalskill() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_technicalskills.php",
        body: {
          "A": widget.email,
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        skill_selected = json.decode(response.body);
      });
      fetchexperiences();
    }
    else{
      error();
    }
  }
  void fetchexperiences() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_experiences.php",
        body: {
          "A": widget.email,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        experiences = json.decode(response.body);
      });
      checker();
      fetchprojects();
    }
    else{
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
      });
      fetchcertificates();
    }
    else{
      error();
    }
  }
  void fetchcertificates() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_certificates.php",
        body: {
          "A": widget.email,
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        certificates = json.decode(response.body);
        expandbutton=true;
      });
    }
    else{
      error();
    }
  }*/
  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0){
      /*fetchpersoninfo();
      fetcheduacation();
      fetchtechnicalskill();
      fetchexperiences();*/
      t=t+1;
    }

    double width = MediaQuery. of(context). size. width;
    double hight = MediaQuery. of(context). size. height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child:Text("Builder",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
            ),

            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child:Text("Done",style: TextStyle(color: Colors.blueGrey, fontFamily: 'design.graffiti.comicsansms'),),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*Card(
              child:Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(" Your Resume:",style: TextStyle(fontSize: 22, color: Colors.blue, fontFamily: 'design.graffiti.comicsansms'),),
                        ),
                        IconButton(
                          icon: expandbutton==false ? Icon(Icons.expand_more, color: Colors.blue, size: 25,):Icon(Icons.expand_less, color: Colors.blue, size: 25,),
                          onPressed: () {
                            fetchpersoninfo();

                            if(expandbutton==true){
                              setState(() {
                                expandbutton=false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    expandbutton==true?Container(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Container(
                            // margin: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,

                            ),
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            child:Row(
                              children: <Widget>[
                                Expanded(
                                  child:Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          person.length!=0? Text(person[0]['fname']+" "+person[0]['mname']+" "+person[0]['lname'],style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),):Text(" "),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          person.length!=0?Container(
                                            child:type==true?Container(
                                                child:Text("Fresher",style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),)
                                            ):Container(),
                                          ):Container(),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height:2.0,
                                            width:130.0,
                                            color:Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(3),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: person.length!=0?Text(person[0]['aboutself'],style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),):Text(" "),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          SizedBox.fromSize(
                            size: Size.fromHeight(10),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: width/3,
                                  decoration: BoxDecoration(

                                  ),
                                  // padding: EdgeInsets.fromLTRB(10,10,10,10),
                                  child: Column(
                                    children: <Widget>[
                                      person.length!=0?Container(
                                        child:GestureDetector(
                                          onTap: () {
                                            showImage(person[0]['profile_picture']);
                                          },
                                          child:Container(
                                            // margin: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                                            height:(width/3)-10,
                                            width: (width/3)-10,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: Image.memory(base64Decode(person[0]['profile_picture'])).image)
                                            ),
                                          ),
                                        ),

                                      ):Container(),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(10),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.mail,
                                            color: Colors.blueGrey,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:  person.length!=0?Text(person[0]['resume_email'],style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),):Text(" "),
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(10),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.contact_phone,
                                            color: Colors.blueGrey,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:  person.length!=0?Text(person[0]['cono'].toString(),style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),):Text(" "),
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(10),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.blueGrey,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:  person.length!=0?Text(person[0]['dob'].toString(),style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),):Text(" "),
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(10),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.blueGrey,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:  person.length!=0?Text(person[0]['ladd'] +","+person[0]['city']+","+person[0]['ta']+","+person[0]['dis']+","+person[0]['pin'].toString(),style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),):Text(" "),
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(10),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text("Technical Skills:",style: TextStyle(fontSize: 18, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                                          ),
                                        ],
                                      ),
                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height:2.0,
                                            width:(width/3)-10,
                                            color:Colors.blueGrey,
                                          ),
                                        ],
                                      ),

                                      SizedBox.fromSize(
                                        size: Size.fromHeight(5),
                                      ),
                                      skill_selected.length != 0 ?ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: skill_selected.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return Container(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                color: Colors.blueGrey,
                                                elevation: 5,
                                                child:Container(
                                                  padding: new EdgeInsets.fromLTRB(2,1,2,1),
                                                  child:Column(
                                                    children: <Widget>[
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Text(skill_selected[index]['name'],style: new TextStyle(fontSize: 13.0,color: Colors.white),),
                                                          ),
                                                          Column(
                                                            children: <Widget>[
                                                              Icon( (skill_selected[index]['lavel']=='Professional')?Icons.star:Icons.star_border ,size: 10,color: Colors.white,),
                                                              Icon( (skill_selected[index]['lavel'] =='Professional'|| skill_selected[index]['lavel'] =='Intermediate')?Icons.star:Icons.star_border ,size: 10,color: Colors.white,),
                                                              Icon( (skill_selected[index]['lavel'] =='Beginner'|| skill_selected[index]['lavel'] =='Intermediate'|| skill_selected[index]['lavel']=='Professional')?Icons.star:Icons.star_border ,size: 10,color: Colors.white,),
                                                            ],
                                                          ),
                                                        ],
                                                      ),



                                                    ],
                                                  ),
                                                ),
                                              ),

                                            );
                                          }
                                      ):Container(),
                                      certificates.length !=0? Container(
                                        child:Column(
                                          children: <Widget>[
                                            SizedBox.fromSize(
                                              size: Size.fromHeight(10),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text("Courses:",style: TextStyle(fontSize: 18, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                                                ),
                                              ],
                                            ),
                                            SizedBox.fromSize(
                                              size: Size.fromHeight(5),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  height:2.0,
                                                  width:(width/3)-10,
                                                  color:Colors.blueGrey,
                                                ),
                                              ],
                                            ),

                                            SizedBox.fromSize(
                                              size: Size.fromHeight(5),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: certificates.length,
                                                itemBuilder: (BuildContext context,int index){
                                                  return Container(
                                                    child:Container(
                                                      padding: new EdgeInsets.fromLTRB(2,1,2,1),
                                                      child:GestureDetector(
                                                        onTap: () {
                                                          showImage(certificates[index]['certificate']);
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <Widget>[
                                                                Icon(Icons.star , size: 12,color: Colors.blueGrey),
                                                                Text(" "+certificates[index]['name'],style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Icon(Icons.description , size: 12,color: Colors.blueGrey),
                                                                Text(certificates[index]['aboutcourse'],style: new TextStyle(fontSize: 12.0,color: Colors.black),),
                                                              ],
                                                            ),
                                                            certificates[index]['completed']=='true'? Row(
                                                              children: <Widget>[
                                                                new Icon(Icons.date_range , size: 12,color: Colors.blueGrey,),
                                                                Expanded(
                                                                  child:Text(" "+certificates[index]['startdate']+"  To  "+certificates[index]['enddate'],style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                ),
                                                              ],
                                                            ): Row(
                                                              children: <Widget>[
                                                                new Icon(Icons.date_range , size: 12,color: Colors.blueGrey,),
                                                                Expanded(
                                                                  child:Text(" "+certificates[index]['startdate']+"  To  Running..",style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  height:0.5,
                                                                  width:(width/3.2),
                                                                  color:Colors.blueGrey,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            )
                                          ],
                                        ),
                                      ):Container(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child:Container(

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          eduacation.length!=0?Container(
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text("Eduacation:",style: TextStyle(fontSize: 18, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  height:2.0,
                                                  width:width-((width/2)-10),
                                                  color:Colors.blueGrey,
                                                ),
                                                eduacation[0]['hse_unit']=='true'?Container(
                                                  child:GestureDetector(
                                                    onTap: () {
                                                      showImage(eduacation[0]['hse_result']);
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text('H.S.E',style: TextStyle(fontSize: 13, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Text(eduacation[0]['hse_board'] +" , "+eduacation[0]['hse_pr'].toString()+" % ",style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Text('Completed by '+eduacation[0]['hse_py'].toString(),style: TextStyle(fontSize: 10, color: Colors.blueGrey, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Container(
                                                          height:0.5,
                                                          width:width-((width/2)-10),
                                                          color:Colors.blueGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ):Container(),
                                                eduacation[0]['diploma_unit']=='true'?Container(
                                                  child:GestureDetector(
                                                    onTap: () {
                                                      showImage(eduacation[0]['diploma_result']);
                                                    },
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text('Diploma',style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Text(eduacation[0]['diploma_course'],style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons.location_on, color: Colors.blueGrey, size: 12,),
                                                            Expanded(
                                                              child:Text(eduacation[0]['diploma_collage'].toString(),style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                            ),

                                                          ],
                                                        ),
                                                        Text('Completed by '+eduacation[0]['diploma_py'].toString()+' With '+eduacation[0]['diploma_cpi'] .toString()+" cpi",style: TextStyle(fontSize: 10, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Container(
                                                          height:0.5,
                                                          width:width-((width/2)-10),
                                                          color:Colors.blueGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ):Container(),
                                                eduacation[0]['graduation_unit']=='true'?Container(
                                                  child:GestureDetector(
                                                    onTap: () {
                                                      showImage(eduacation[0]['graduation_result']);
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text(eduacation[0]['graduation_program'],style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Text(eduacation[0]['graduation_course'],style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons.location_on, color: Colors.blueGrey, size: 12),
                                                            Expanded(
                                                              child:Text(eduacation[0]['graduation_collage'].toString(),style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                            ),

                                                          ],
                                                        ),
                                                        Text('Completed by '+eduacation[0]['graduation_py'].toString()+' With '+eduacation[0]['graduation_cpi'] .toString()+" cpi",style: TextStyle(fontSize: 10, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Container(
                                                          height:0.5,
                                                          width:width-((width/2)-10),
                                                          color:Colors.blueGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ):Container(),
                                                eduacation[0]['postgraduation_unit']=='true'?Container(
                                                  child:GestureDetector(
                                                    onTap: () {
                                                      showImage(eduacation[0]['postgraduation_result']);
                                                    },
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text(eduacation[0]['postgraduation_program'],style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Text(eduacation[0]['postgraduation_course'],style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons.location_on, color: Colors.blueGrey, size: 12),
                                                            Expanded(
                                                              child:Text(eduacation[0]['postgraduation_collage'].toString(),style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                            ),

                                                          ],
                                                        ),
                                                        Text('Completed by '+eduacation[0]['postgraduation_py'].toString()+' With '+eduacation[0]['postgraduation_cpi'] .toString()+" cpi",style: TextStyle(fontSize: 10, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Container(
                                                          height:0.5,
                                                          width:width-((width/2)-10),
                                                          color:Colors.blueGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ):Container(),
                                                eduacation[0]['phd_unit']=='true'?Container(
                                                  child:GestureDetector(
                                                    onTap: () {
                                                      showImage(eduacation[0]['phd_degree']);
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text("P.H.D",style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Text(eduacation[0]['phd_sub'],style: TextStyle(fontSize: 12, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons.location_on, color: Colors.blueGrey, size: 12),
                                                            Expanded(
                                                              child:Text(eduacation[0]['phd_collage'].toString(),style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(eduacation[0]['phd_aboutsub'],style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                        Container(
                                                          height:0.5,
                                                          width:width-((width/2)-10),
                                                          color:Colors.blueGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ):Container(),
                                                experiences.length!=0?Container(
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text("Experiences:",style: TextStyle(fontSize: 18, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Container(
                                                        height:2.0,
                                                        width:width-((width/2)-10),
                                                        color:Colors.blueGrey,
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: experiences.length,
                                                          itemBuilder: (BuildContext context,int index){
                                                            return Container(
                                                              child:Container(
                                                                padding: new EdgeInsets.fromLTRB(2,1,2,1),
                                                                child:Column(
                                                                  children: <Widget>[
                                                                    Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.grade , size: 12,color: Colors.blueGrey),
                                                                        Expanded(
                                                                          child: Text(" "+experiences[index]['post'],style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.account_balance , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child: Text(" "+experiences[index]['company'],style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    experiences[index]['completed']=='true'? Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.date_range , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child:Text(" "+experiences[index]['startdate']+"  To  "+experiences[index]['enddate'],style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),
                                                                      ],
                                                                    ): Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.date_range , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child:Text(" "+experiences[index]['startdate']+"  To  Running..",style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.description , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child:Text(" "+experiences[index]['description'] ,style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    experiences[index]['intern']=='true'?  Text('As A Intern',style: TextStyle(fontSize: 12, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),):Text(" "),
                                                                    Container(
                                                                      height:0.5,
                                                                      width:width-((width/2)-10),
                                                                      color:Colors.blueGrey,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                      )
                                                    ],
                                                  ),
                                                ):Container(),
                                                projects.length!=0?Container(
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text("Project Details:",style: TextStyle(fontSize: 18, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Container(
                                                        height:2.0,
                                                        width:width-((width/2)-10),
                                                        color:Colors.blueGrey,
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: projects.length,
                                                          itemBuilder: (BuildContext context,int index){
                                                            return Container(
                                                              child:Container(
                                                                padding: new EdgeInsets.fromLTRB(2,1,2,1),
                                                                child:Column(
                                                                  children: <Widget>[
                                                                    Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.grade , size: 12,color: Colors.blueGrey),
                                                                        Expanded(
                                                                          child: Text(" "+projects[index]['title'],style: TextStyle(fontSize: 14, color: Colors.blueGrey,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsan]sms'),),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.description , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child: Text(" "+projects[index]['aboutproject'],style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    projects[index]['completed']=='true'? Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.date_range , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child:Text(" "+projects[index]['startdate']+"  To  "+projects[index]['enddate'],style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),
                                                                      ],
                                                                    ): Row(
                                                                      children: <Widget>[
                                                                        new Icon(Icons.date_range , size: 12,color: Colors.blueGrey,),
                                                                        Expanded(
                                                                          child:Text(" "+projects[index]['startdate']+"  To  Running..",style: new TextStyle(fontSize:12,color: Colors.black),),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      height:0.5,
                                                                      width:width-((width/2)-10),
                                                                      color:Colors.blueGrey,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                      )
                                                    ],
                                                  ),
                                                ):Container(),

                                              ],
                                            ),
                                          ):Container(),
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ),*/
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            RaisedButton(
              onPressed:(){

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  PersonInfo(widget.email);
                }));
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 5,5,5),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(" Person Info",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            RaisedButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  Education(widget.email);
                }));
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 5,5,5),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(" Education",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            RaisedButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  TechnicalSkills(widget.email);
                }));
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 5,5,5),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(" Technical Skills",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            RaisedButton(
              onPressed:(){
                setState(() {
                  expandbutton=false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  Experiences(widget.email);
                }));
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 5,5,5),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(" Experiences",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            RaisedButton(
              onPressed:(){
                setState(() {
                  expandbutton=false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  Projects(widget.email);
                }));
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(" Project Details",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            RaisedButton(
              onPressed:(){
                setState(() {
                  expandbutton=false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  Certificates(widget.email);
                }));
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 5,5,5),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(" Certification & Courses",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            /*RaisedButton(
              onPressed:(){
                setState(() {
                  expandbutton=false;
                });
              },
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              child:Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 30,
                      ),
                      Expanded(
                        child: Text(" Interests",style: TextStyle(fontSize: 22, color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
