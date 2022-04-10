import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Applicant/ApplyForJob.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ShowVacancy extends StatefulWidget {
  @override
  _ShowVacancy createState() => new _ShowVacancy();
}
class  _ShowVacancy extends State<ShowVacancy > {
  void initState(){
    super. initState();
    fetchdata();
  }

  bool loading = true,screenflag=false;
  List vacancydata=[];
  List appliedjob=[];
  int ind;
  String examstatus;
  String Email;
  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_vacancy_for_applicant.php", {});
    var res1 = await api(context, "get_find_applied_job_for_applicant.php", {"A":Email});
    setState(() {
      vacancydata=res;
      appliedjob=res1;
      loading=false;
    });
  }
  void applyforjob(){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ApplyForJob([vacancydata[ind]],examstatus);
      }));

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(screenflag==true){
            setState(() {
              screenflag=false;
              ind=null;
            });
            return false;
          }else{
            return true;
          }
        },
     child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vacancy'),
        ),
        body:loading==false?Container(
          color: Colors.white,
          child:screenflag==false?Container(
              child:SingleChildScrollView(
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: vacancydata.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap:(){
                          if(appliedjob.length==0){
                            setState(() {
                              examstatus="true";
                              ind=index;
                              screenflag=true;
                            });
                          }else{
                            List applied = appliedjob.where((i) {
                              if(i['coemail']==vacancydata[index]['email'] && i['post']==vacancydata[index]['post']){
                                return true;
                              }else{
                                return false;
                              }
                            }).toList();
                            if(applied.length==0){
                              setState(() {
                                examstatus="true";
                                ind=index;
                                screenflag=true;
                              });
                            }else{
                              if(applied[0]['live']=='true'){
                                aleart(context, "You already Applied");
                              }else{
                                setState(() {
                                  examstatus=applied[0]['eligible'];
                                  ind=index;
                                  screenflag=true;
                                });
                              }
                            }

                          }

                        },
                        child: Card(
                          color: Colors.blue,
                          margin: EdgeInsets.only(top:width*0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 0,
                          child:Padding(
                            padding:EdgeInsets.all(width*0.05),
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
                                              child: text2(context, vacancydata[index]['post'],Colors.white, width * 0.05, FontWeight.bold),
                                            ),
                                            SizedBox(height: height*0.005),
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: text2(context, vacancydata[index]['name'],Colors.white, width * 0.05, FontWeight.normal),
                                            ),


                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height*0.10,
                                        width:height*0.10,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:MemoryImage(base64.decode(vacancydata[index]['icon'])),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(height*0.10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height*0.005),
                                Row(
                                  children: [
                                    Icon(Icons.person,color: Colors.white,size: width*0.05,),
                                    text(context, " "+vacancydata[index]['no'],Colors.white, width * 0.05, FontWeight.normal),
                                  ],
                                ),
                                SizedBox(height: height*0.005),
                                Row(
                                  children: [
                                    Icon(Icons.payments,color: Colors.white,size: width*0.05,),
                                    text(context, " "+vacancydata[index]['minsalary']+" - "+vacancydata[index]['maxsalary'],Colors.white, width * 0.05, FontWeight.normal),
                                  ],
                                ),
                                SizedBox(height: height*0.005),
                                Row(
                                  children: [
                                    Icon(Icons.home,color: Colors.white,size: width*0.05,),
                                    text(context, " "+vacancydata[index]['location'],Colors.white, width * 0.05, FontWeight.normal),
                                  ],
                                ),
                                SizedBox(height: height*0.01),
                                Align(
                                  alignment:Alignment.bottomRight,
                                  child: text2(context, "Apply By "+vacancydata[index]['lastdate'],Colors.white, width * 0.04, FontWeight.normal),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
          ):Container(
            child:SingleChildScrollView(
              child:Padding(
                padding:EdgeInsets.all(width*0.05),
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
                                  child: text2(context, vacancydata[ind]['post'],Colors.black, width * 0.05, FontWeight.bold),
                                ),
                                SizedBox(height: height*0.005),
                                Align(
                                  alignment:Alignment.topLeft,
                                  child: text2(context, vacancydata[ind]['name'],Colors.black, width * 0.05, FontWeight.normal),
                                ),


                              ],
                            ),
                          ),
                          Container(
                            height: height*0.10,
                            width:height*0.10,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:MemoryImage(base64.decode(vacancydata[ind]['icon'])),
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
                        text(context, " "+vacancydata[ind]['no'],Colors.black, width * 0.05, FontWeight.normal),
                      ],
                    ),
                    SizedBox(height: height*0.005),
                    Row(
                      children: [
                        Icon(Icons.payments,color: Colors.black,size: width*0.05,),
                        text(context, " "+vacancydata[ind]['minsalary']+" - "+vacancydata[ind]['maxsalary'],Colors.black, width * 0.05, FontWeight.normal),
                      ],
                    ),
                    SizedBox(height: height*0.005),
                    Row(
                      children: [
                        Icon(Icons.home,color: Colors.black,size: width*0.05,),
                        text(context, " "+vacancydata[ind]['location'],Colors.black, width * 0.05, FontWeight.normal),
                      ],
                    ),
                    SizedBox(height: height*0.01),
                    Align(
                      alignment:Alignment.bottomRight,
                      child: text2(context, "Apply By "+vacancydata[ind]['lastdate'],Colors.black, width * 0.04, FontWeight.normal),
                    ),
                    SizedBox(height: height*0.02),
                    horizontalline(context,width,Colors.blue),
                    SizedBox(height: height*0.02),
                    Align(
                        alignment:Alignment.topLeft,
                        child: text2(context, "About "+vacancydata[ind]['name'],Colors.black, width * 0.05, FontWeight.w600)
                    ),
                    SizedBox(height: height*0.01),
                    Align(
                      alignment:Alignment.topLeft,
                      child: text2(context, vacancydata[ind]['contain'],Colors.black, width * 0.05, FontWeight.normal),
                    ),
                    SizedBox(height: height*0.01),
                    Align(
                      alignment:Alignment.topLeft,
                      child: text2(context, vacancydata[ind]['other'],Colors.black, width * 0.05, FontWeight.normal),
                    ),
                    Align(
                      alignment:Alignment.topLeft,
                      child: text2(context, "Address: "+vacancydata[ind]['ladd']+" , "+vacancydata[ind]['city']+" , "+vacancydata[ind]['ta']+" , "+vacancydata[ind]['dis']+" , "+vacancydata[ind]['pin']+".",Colors.black, width * 0.05, FontWeight.normal),
                    ),
                    SizedBox(height: height*0.02),
                    Align(
                        alignment:Alignment.topLeft,
                        child: text2(context, "Requirements",Colors.black, width * 0.05, FontWeight.w600)
                    ),
                    SizedBox(height: height*0.01),
                    Align(
                      alignment:Alignment.topLeft,
                      child: text2(context, vacancydata[ind]['vacancydata'],Colors.black, width * 0.05, FontWeight.normal),
                    ),
                    SizedBox(height: height*0.02),
                    (jsonDecode(vacancydata[ind]['requiredskill'])).length!=0?Container(
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
                              itemCount: (jsonDecode(vacancydata[ind]['requiredskill'])).length,
                              itemBuilder: (BuildContext context, int index) {
                                return  Container(
                                  child:Align(
                                    alignment:Alignment.topLeft,
                                    child: text2(context, "• "+jsonDecode(vacancydata[ind]['requiredskill'])[index]['name']+" : "+
                                        jsonDecode(vacancydata[ind]['requiredskill'])[index]['lavel']+" Level",Colors.black, width * 0.05,
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
                        Expanded(child: btn(context,"Apply For Job",width*0.06,height*0.07,width*0.60,applyforjob)),
                      ],
                    ),
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