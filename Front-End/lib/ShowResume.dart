
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Applicant/ApplicantHome.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'Applicant/ResumeBuilder.dart';

class ShowResume extends StatefulWidget {
  ShowResume(this.data1,this.data2,this.data3,this.data4,this.data5,this.data6);
List data1=[],data2=[],data3=[],data4=[],data5=[],data6=[];
  @override
  _ShowResume createState() => new _ShowResume(data1,data2,data3,data4,data5,data6);
}

class  _ShowResume extends State<ShowResume > {
  _ShowResume(data1,data2,data3,data4,data5,data6);
  bool loading = true;
  bool screenflag = false;
  String Email='';

  List eduacationdata=[],personinfo=[],experiencedata=[],projectdata=[],certificatedata=[],skilldata=[];
  void initState() {
    super. initState();
    fetchdata();
  }
  void fetchdata()async {
    if((widget.data1).length==0){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      setState(() {
        Email = email;
      });
      var res1 = await api(context, "get_resume_person_info.php", {'A':Email});
      var res2 = await api(context, "get_resume_eduacation_info.php", {'A':Email});
      var res3 = await api(context, "get_resume_experiences_info.php", {'A':Email});
      var res4 = await api(context, "get_resume_technicalskills.php", {'A':Email});
      var res5 = await api(context, "get_resume_project_info.php", {'A':Email});
      var res6 = await api(context, "get_resume_certificate_info.php", {'A':Email});
      setState(() {
        personinfo=res1;
        eduacationdata=res2;
        experiencedata=res3;
        skilldata=res4;
        projectdata=res5;
        certificatedata=res6;
        loading=false;
      });
    }else{
      setState(() {
        personinfo=widget.data1;
        eduacationdata=widget.data2;
        experiencedata=widget.data3;
        skilldata=widget.data4;
        projectdata=widget.data5;
        certificatedata=widget.data6;
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

     return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Resume'),
            actions: [
              (widget.data1).length==0?InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ResumeBuilder("show resume");
                  }));
                },
                child: Icon(Icons.edit, color: Colors.white),
              ):Container(),
              SizedBox(width: width*0.05),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.done, color: Colors.white),
              ),
              SizedBox(width: width*0.05),
            ],
          ),
          body:loading==false?Container(
            margin: EdgeInsets.all(width*0.05),
            child:SingleChildScrollView(
              child:(personinfo.length!=0 &&  eduacationdata.length!=0 && experiencedata.length!=0 && projectdata.length!=0 &&
                  skilldata.length!=0 && certificatedata.length!=0)?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  personinfo.length!=0?Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: width*0.30,
                              width:width*0.30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:MemoryImage(base64.decode(personinfo[0]['profile_picture'])),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(width*0.15),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  
                                  text2(context, personinfo[0]['fname']+" "+personinfo[0]['lname'],Colors.black, width * 0.06, FontWeight.w600),
                                  /* Align(
                              alignment: Alignment.topRight,
                                child: text2(context, personinfo[0]['fname'],Colors.black, width * 0.05, FontWeight.normal)
                          ),*/
                                  text2(context, personinfo[0]['resume_email'],Colors.black, width * 0.05, FontWeight.normal),
                                  text2(context, personinfo[0]['cono'],Colors.black, width * 0.05, FontWeight.normal),
                                  text2(context, personinfo[0]['city']+","+personinfo[0]['dis'],Colors.black, width * 0.05, FontWeight.normal),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                        SizedBox(height: height*0.03),
                        text2(context, "Summary",Colors.black, width * 0.05, FontWeight.w600),
                        text2(context, personinfo[0]['aboutself'],Colors.black, width * 0.05, FontWeight.normal),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                      ],
                    ),
                  ):Container(),

                  SizedBox(height: height*0.03),
                  eduacationdata.length!=0?Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text2(context, "Eduacation",Colors.black, width * 0.05, FontWeight.w600),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: eduacationdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Container(
                                margin: EdgeInsets.only(top:width*0.02),
                                child:Align(
                                  alignment:Alignment.topLeft,
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      text2(context, eduacationdata[index]['course'],Colors.black, width * 0.05, FontWeight.w500),
                                      text2(context, eduacationdata[index]['program']+" , "+eduacationdata[0]['startyear']+" to "+eduacationdata[0]['endyear'],Colors.black, width * 0.05, FontWeight.normal),
                                      text2(context, eduacationdata[index]['collage'],Colors.black, width * 0.05, FontWeight.normal),
                                      text2(context, eduacationdata[index]['percentage']+"/"+eduacationdata[index]['mode'],Colors.black, width * 0.05, FontWeight.normal),
                                      //SizedBox(height: height*0.03),
                                    ],
                                  ),

                                ),
                              );
                            }
                        ),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                      ],
                    ),
                  ):Container(),
                  experiencedata.length!=0?Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height*0.03),
                        text2(context, "Experience",Colors.black, width * 0.05, FontWeight.w600),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: experiencedata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Container(
                                margin: EdgeInsets.only(top:width*0.02),
                                child:Align(
                                  alignment:Alignment.topLeft,
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      experiencedata[index]['intern']=='false'?text2(context, experiencedata[index]['post'],Colors.black, width * 0.05, FontWeight.w500):
                                      text2(context, experiencedata[index]['post']+"  As a Intern",Colors.black, width * 0.05, FontWeight.w500),
                                      text2(context, experiencedata[index]['company']+" ("+experiencedata[index]['startmonth']+" to "+experiencedata[index]['endmonth']+")",Colors.black, width * 0.05, FontWeight.normal),
                                      text2(context, experiencedata[index]['description'],Colors.black, width * 0.05, FontWeight.normal),
                                      //SizedBox(height: height*0.03),
                                    ],
                                  ),

                                ),
                              );
                            }
                        ),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                      ],
                    ),
                  ):Container(),
                  projectdata.length!=0?Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height*0.03),
                        text2(context, "Project",Colors.black, width * 0.05, FontWeight.w600),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: projectdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Container(
                                margin: EdgeInsets.only(top:width*0.02),
                                child:Align(
                                  alignment:Alignment.topLeft,
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      text2(context, projectdata[index]['title']+" ("+projectdata[index]['startdate']+" to "+projectdata[index]['enddate']+")",Colors.black, width * 0.05, FontWeight.normal),
                                      text2(context, " • "+projectdata[index]['aboutproject'],Colors.black, width * 0.05, FontWeight.normal),

                                      //SizedBox(height: height*0.03),
                                    ],
                                  ),

                                ),
                              );
                            }
                        ),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                      ],
                    ),
                  ):Container(),
                  skilldata.length!=0?Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height*0.03),
                        text2(context, "Technical Skills",Colors.black, width * 0.05, FontWeight.w600),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: skilldata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Container(
                                margin: EdgeInsets.only(top:width*0.02),
                                child:Align(
                                  alignment:Alignment.topLeft,
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      text2(context, "• "+skilldata[index]['name']+" : "+ skilldata[index]['lavel']+" Level",Colors.black, width * 0.05,
                                          FontWeight.normal),

                                      //SizedBox(height: height*0.03),
                                    ],
                                  ),

                                ),
                              );
                            }
                        ),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                      ],
                    ),
                  ):Container(),
                  certificatedata.length!=0?Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height*0.03),
                        text2(context, "Certificates",Colors.black, width * 0.05, FontWeight.w600),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: certificatedata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Container(
                                margin: EdgeInsets.only(top:width*0.02),
                                child:Align(
                                  alignment:Alignment.topLeft,
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      text2(context, certificatedata[index]['name']+" ("+certificatedata[index]['startdate']+" to "+certificatedata[index]['enddate']+")",Colors.black, width * 0.05, FontWeight.normal),
                                      text2(context, " • "+certificatedata[index]['aboutcourse'],Colors.black, width * 0.05, FontWeight.normal),
                                      //SizedBox(height: height*0.03),
                                    ],
                                  ),

                                ),
                              );
                            }
                        ),
                        SizedBox(height: height*0.03),
                        horizontalline(context,width,Colors.grey),
                      ],
                    ),
                  ):Container(),
                ],
              ):Align(
                alignment: Alignment.center,
                child:text2(context, "Edit Your Resume",Colors.black, width * 0.05, FontWeight.w500),
              ),
            ),

          ):progressindicator(context),

        ),
    );
  }
}