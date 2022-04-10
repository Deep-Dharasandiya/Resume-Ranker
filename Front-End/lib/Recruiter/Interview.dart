import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Interview extends StatefulWidget {
  @override
  _Interview createState() => new _Interview();
}
class  _Interview extends State<Interview > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false,screenflag2=false;
  String Email='';
  int ind;
  String selecteddate="yyyy-mm-dd";
  List interview=[];
  List interviewdetails=[];


  TextEditingController add =TextEditingController();
  String get add2 => add.text;

  TextEditingController redoc =TextEditingController();
  String get redoc2 => redoc.text;

  TextEditingController title =TextEditingController();
  String get title2 => title.text;

  TextEditingController time =TextEditingController();
  String get time2 => time.text;

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_interviewlist_recruiter.php", {"A":Email});
    print(res);
    setState(() {
      interview=res;
      screenflag=false;
      loading=false;
    });
  }
  void fetchinterview()async{
    var res = await api(context, "get_interview_detailes_reqruiter.php", {"A":Email,"B":interview[ind]['email']});

    setState(() {
      if(res.length!=0){
        interviewdetails=res;
        screenflag2=true;
        screenflag=true;
        loading=false;
      }else{
        screenflag=true;
        loading=false;
      }

    });
  }
  void insertinterview()async{
   if(add2 == null || redoc2 == null || time2==null || selecteddate=="yyyy-mm-dd"|| title2==null || redoc2==null){
     aleartdetailsrequired(context);
   }else{
     setState(() {
       loading=true;
     });
     print(redoc2);
     var body={
       "A":Email,
       "B":interview[ind]['email'],
       "C":add2,
       "D":time2,
       "E":selecteddate,
       "F":interview[ind]['post'],
       "G":title2,
       "H":redoc2,
     };
     var res = await api(context, "insert_interview_details.php", body);
     if(res==1){
       fetchinterview();
     }else{
       aleart(context,'Server Did not Responce Try again later');
     }
   }
  }

  void additem(){
    setState(() {

      screenflag=true;
    });
  }
  void date()async{
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDatePickerMode: DatePickerMode.day,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    setState(() {
      selecteddate=DateFormat('yyyy-MM-dd').format(newDateTime);
    });

  }
  void onaccepted() async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B":interview[ind]['email'],
      "C":interview[ind]['post'],
      "D":"Accepted",
    };
    var res = await api(context, "update_applyingjob_status_in_interview.php", body);
    if(res==1) {
      setState(() {
        screenflag=false;
      });
      fetchdata();}
  }
  void onrejected()async{
    setState(() {
      loading=true;
    });
    print(redoc2);
    var body={
      "A":Email,
      "B":interview[ind]['email'],
      "C":interview[ind]['post'],
      "D":"Rejected",
    };
    var res = await api(context, "update_applyingjob_status_in_interview.php", body);
    if(res==1) {
      setState(() {
        screenflag=false;
      });
      fetchdata();
    }
  }
  void onedit(){
    setState(() {
      add =TextEditingController(text:interviewdetails[0]['address'] );
      time =TextEditingController(text:interviewdetails[0]['time'] );
      selecteddate =interviewdetails[0]['address'];
      redoc =TextEditingController(text:interviewdetails[0]['requireddocument'] );
      title =TextEditingController(text:interviewdetails[0]['title'] );
      screenflag2=false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(screenflag==false || screenflag==true ){
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
            title: Text('Schedual Interview'),
          ),
          body:loading==false?Center(
            child:screenflag==false?Container(
                child:interview.length!=0?ListView.builder(
                    padding: EdgeInsets.all(width * 0.05),
                    itemCount: interview.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap:(){
                          setState(() {
                            ind=index;
                          });
                          fetchinterview();

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
                                     // ondelete(skilldata[index]['name'],skilldata[index]['lavel'],skilldata[index]['eligible']);
                                    },
                                    child: Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: [
                                    text(context, jsonDecode(interview[index]['personalinfo'])[0]['fname']+" "+jsonDecode(interview[index]['personalinfo'])[0]['lname'], Colors.white, width * 0.05, FontWeight.w500),
                                  ],
                                ),
                                Row(
                                  children: [
                                    text(context, jsonDecode(interview[index]['personalinfo'])[0]['email'], Colors.white, width * 0.05, FontWeight.w500),
                                  ],
                                ),
                                Row(
                                  children: [
                                    text(context, interview[index]['post'], Colors.white, width * 0.05, FontWeight.w500),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ):text2(context, "No Interview Available", Colors.black, width * 0.05, FontWeight.w500),
            ):Container(
              child:Padding(
                padding:  EdgeInsets.all(width*0.05),
                child: SingleChildScrollView(
                  child: screenflag2==false?Column(
                    children: [
                      textField(context,'Interview Title',TextInputType.emailAddress,false,title),
                      textField(context,'Interview Location',TextInputType.emailAddress,false,add),
                      textField(context,'Required Document',TextInputType.emailAddress,false,redoc),
                      textField(context,'Interview Time',TextInputType.emailAddress,false,time),
                      InkWell(
                        onTap: (){date();},
                        child:Column(
                          children: [
                            Align(alignment:Alignment.topLeft,child: text(context,"Interview Date:",Colors.black,width*0.05,FontWeight.normal)),
                            Container(
                              height: height*0.05,
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(width*0.01),
                                border:Border.all(color: Colors.black),
                              ),

                              margin:EdgeInsets.only(top:width*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  text(context,selecteddate,Colors.black,width*0.05,FontWeight.normal),
                                  new Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.03),
                      Row(
                        children: [
                          Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.60,insertinterview)),
                        ],
                      ),
                      SizedBox(height: height*0.03),
                    ],
                  ):Column(
                    children: [
                          Row(
                            children: [
                              Expanded(child: text2(context, interviewdetails[0]['title'] ,Colors.black, width * 0.05, FontWeight.normal)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: text2(context,  interviewdetails[0]['address'],Colors.black, width * 0.05, FontWeight.normal)),
                            ],
                          ),
                         Row(
                           children: [
                             Expanded(child: text2(context, interviewdetails[0]['date'] ,Colors.black, width * 0.05, FontWeight.normal)),
                           ],
                         ),
                          Row(
                            children: [
                              Expanded(child: text2(context, interviewdetails[0]['time'] ,Colors.black, width * 0.05, FontWeight.normal)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: text2(context, interviewdetails[0]['post'] ,Colors.black, width * 0.05, FontWeight.normal)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: text2(context, interviewdetails[0]['requireddocument'] ,Colors.black, width * 0.05, FontWeight.normal)),
                            ],
                          ),
                      SizedBox(height: height*0.03),
                      simplebtn(context,"Edit",width*0.06,height*0.07,width,onedit),
                      SizedBox(height: height*0.03),
                       Row(
                        children: [
                          Expanded(child: simplebtn(context,"Accepted",width*0.06,height*0.07,width,onaccepted),),
                          SizedBox(width: width*0.03),
                          Expanded(child: simplebtn(context,"Rejected",width*0.06,height*0.07,width,onrejected),),
                        ],
                      ),

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