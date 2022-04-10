import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/ShowResume.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class JobStatus extends StatefulWidget {
  @override
  _JobStatus createState() => new _JobStatus();
}
class  _JobStatus extends State<JobStatus > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  String Email='';
  List applicantdata=[];
  List vacancydata=[];
  int ind;

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_applyed_job_status.php", {"A":Email});
    setState(() {
      applicantdata=res;
      loading=false;
    });
  }
  void fetchvacancy(var email,var post)async{
    setState(() {
      loading=true;
    });
    var res = await api(context, "get_vacancy_for_job_status.php", {"A":email,"B":post});
    setState(() {
      vacancydata=res;
      screenflag=true;
      loading=false;
    });
  }

  void showresume(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ShowResume(jsonDecode(applicantdata[0]['personalinfo']),jsonDecode(applicantdata[0]['eduacationinfo']),jsonDecode(applicantdata[0]['experienceinfo']),
          jsonDecode(applicantdata[0]['skillinfo']),jsonDecode(applicantdata[0]['projectinfo']),jsonDecode(applicantdata[0]['certificateinfo']));
    }));
  }
  void ondelete(var coemail,var post,var status) async{
    setState(() {
      loading=true;
    });
    var res = await api(context, "delete_applying_job.php", {"A":coemail,"B":Email,"C":post,"D":status});
    fetchdata();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(screenflag==false ){
          return true;
        }else{
          setState(() {
            screenflag=false;
          });
          return false;
        }

      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Job Status'),
          ),
          body:loading==false?Container(
            child:screenflag==false?Container(
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height*0.05),
                      //text(context, "Choose The Job Title", Colors.black, width * 0.06, FontWeight.w500),
                      applicantdata.length!=0?  ListView.builder(
                          padding: EdgeInsets.all(width * 0.05),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: applicantdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                if(applicantdata[index]['status']!='Job is Cencled'){
                                  setState(() {
                                    fetchvacancy(applicantdata[index]['coemail'],applicantdata[index]['post']);
                                  });
                                }else{
                                  aleart(context, "Job is Closed");
                                }

                              },
                              child: Card(
                                color:Colors.blue,
                                margin: EdgeInsets.only(top:width*0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 0,
                                child:Padding(
                                  padding: EdgeInsets.all(width*0.05),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            ondelete(applicantdata[index]['coemail'],applicantdata[index]['post'],applicantdata[index]['status']);
                                          },
                                          child: Icon(Icons.close, color: Colors.white),
                                        ),
                                      ),
                                      text(context, applicantdata[index]['post'], Colors.white, width * 0.06, FontWeight.w600),
                                      text(context, applicantdata[index]['name'], Colors.white, width * 0.05, FontWeight.w500),
                                      text(context, "Status: "+applicantdata[index]['status'], Colors.white, width * 0.05, FontWeight.w500),
                                      applicantdata[index]['status']=='Accepted'?text(context, "Next Information Provided by Email", Colors.white, width * 0.05, FontWeight.w500):Container(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ): text2(context, "Not Applied Any Job ", Colors.black, width * 0.05, FontWeight.w500),
                    ],
                  ),
                )
            ):Container(
                child:SingleChildScrollView(
                  child:Padding(
                    padding: EdgeInsets.all(width*0.05),
                    child: Column(
                      children: [

                        Container(
                          child:Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment:Alignment.topLeft,
                                      child: text2(context, applicantdata[0]['post'],Colors.black, width * 0.05, FontWeight.bold),
                                    ),
                                    SizedBox(height: height*0.005),
                                    Align(
                                      alignment:Alignment.topLeft,
                                      child: text2(context, applicantdata[0]['name'],Colors.black, width * 0.05, FontWeight.normal),
                                    ),


                                  ],
                                ),
                              ),
                              Container(
                                height: height*0.10,
                                width:height*0.10,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:MemoryImage(base64.decode(applicantdata[0]['icon'])),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(height*0.10),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Icon(Icons.person,color: Colors.black,size: width*0.05,),
                            text(context, " "+vacancydata[0]['no'],Colors.black, width * 0.05, FontWeight.normal),
                          ],
                        ),
                        SizedBox(height: height*0.005),
                        Row(
                          children: [
                            Icon(Icons.payments,color: Colors.black,size: width*0.05,),
                            text(context, " "+vacancydata[0]['minsalary']+" - "+vacancydata[0]['maxsalary'],Colors.black, width * 0.05, FontWeight.normal),
                          ],
                        ),
                        SizedBox(height: height*0.005),
                        Row(
                          children: [
                            Icon(Icons.home,color: Colors.black,size: width*0.05,),
                            text(context, " "+vacancydata[0]['location'],Colors.black, width * 0.05, FontWeight.normal),
                          ],
                        ),
                        SizedBox(height: height*0.01),
                        Align(
                          alignment:Alignment.bottomRight,
                          child: text2(context, "Apply By "+vacancydata[0]['lastdate'],Colors.black, width * 0.04, FontWeight.normal),
                        ),
                        SizedBox(height: height*0.02),
                        horizontalline(context,width,Colors.blue),
                        SizedBox(height: height*0.02),
                        Align(
                            alignment:Alignment.topLeft,
                            child: text2(context, "About "+applicantdata[0]['name'],Colors.black, width * 0.05, FontWeight.w600)
                        ),
                        SizedBox(height: height*0.01),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context, applicantdata[0]['contain'],Colors.black, width * 0.05, FontWeight.normal),
                        ),
                        SizedBox(height: height*0.01),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context, applicantdata[0]['other'],Colors.black, width * 0.05, FontWeight.normal),
                        ),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context, "Address: "+applicantdata[0]['ladd']+" , "+applicantdata[0]['city']+" , "+applicantdata[0]['ta']+" , "+applicantdata[0]['dis']+" , "+applicantdata[0]['pin']+".",Colors.black, width * 0.05, FontWeight.normal),
                        ),
                        SizedBox(height: height*0.02),
                        Align(
                            alignment:Alignment.topLeft,
                            child: text2(context, "Requirements",Colors.black, width * 0.05, FontWeight.w600)
                        ),
                        SizedBox(height: height*0.01),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context, vacancydata[0]['vacancydata'],Colors.black, width * 0.05, FontWeight.normal),
                        ),
                        SizedBox(height: height*0.02),
                        (jsonDecode(vacancydata[0]['requiredskill'])).length!=0?Container(
                          child:Column(
                            children: [
                              Align(
                                  alignment:Alignment.topLeft,
                                  child: text2(context, "Required Skills",Colors.black, width * 0.05, FontWeight.w600)
                              ),
                              ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(width * 0.05),
                                  itemCount: (jsonDecode(vacancydata[0]['requiredskill'])).length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return  Container(
                                      child:Align(
                                        alignment:Alignment.topLeft,
                                        child: text2(context, "• "+jsonDecode(vacancydata[0]['requiredskill'])[index]['name']+" : "+
                                            jsonDecode(vacancydata[0]['requiredskill'])[index]['lavel']+" Level",Colors.black, width * 0.05,
                                            FontWeight.normal),
                                      ),
                                    );
                                  }
                              )

                            ],
                          ),
                        ):Container(),
                        SizedBox(height: height*0.03),
                        Row(
                          children: [
                            Expanded(child: btn(context,"Uploaded My Resume",width*0.06,height*0.07,width*0.60,showresume)),
                          ],
                        ),
                        SizedBox(height: height*0.03),

                      ],
                    ),
                  ),
                )
            ),

          ):progressindicator(context),
        ),
      ),
    );
  }
}