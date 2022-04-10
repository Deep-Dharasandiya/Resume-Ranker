import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Recruiter/Showinterviewhistory.dart';
import 'package:flutter_app2/ShowResume.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApplyedApplicant extends StatefulWidget {
  @override
  _ApplyedApplicant createState() => new _ApplyedApplicant();
}
class  _ApplyedApplicant extends State<ApplyedApplicant > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  bool screenflag2 = false;
  bool flag3=false;
  String Email='';
  List vacancy=[];
  List applicantdata=[];
  int ind;
  List chartdetails=[];
  List interview=[];
  bool ismatching=false;
  List backup=[];

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_vacancy.php", {"A":Email});
    setState(() {
      vacancy=res;
      loading=false;
    });
  }
  void fetchapplicantdata(var post)async{
    setState(() {
      loading=true;
    });
    var res = await api(context, "get_applyed_applicant.php", {"A":Email,"B":post});
     print(res);
    setState(() {
      applicantdata=res;
      screenflag2=false;
      loading=false;
      screenflag=true;

    });
  }
  void fetchinterview()async{
    setState(() {
      loading=true;
    });
    var res = await api(context, "get_interviewlist_for_recruiter_applied_skill.php", {"A":applicantdata[ind]['email'],"B":Email,"C":applicantdata[ind]['post']});
    print("zddtfghgjuhjhkhjjk");
   print(res);
    setState(() {
      interview=res;
      loading= false;
    });
  }
  void showresume(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ShowResume(jsonDecode(applicantdata[ind]['personalinfo']),jsonDecode(applicantdata[ind]['eduacationinfo']),jsonDecode(applicantdata[ind]['experienceinfo']),
      jsonDecode(applicantdata[ind]['skillinfo']),jsonDecode(applicantdata[ind]['projectinfo']),jsonDecode(applicantdata[ind]['certificateinfo']));
    }));
  }
  void updatestatus(var msg)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email ,
      "B":applicantdata[ind]['email'],
      "C":applicantdata[ind]['post'],
      "D": msg,
    };
    var res = await api(context, "update_applyingjob_status.php", body);
    if(res==1){
      fetchapplicantdata(applicantdata[ind]['post']);
    }
  }
  void rejected(){
    updatestatus('Rejected');
  }
  void accepted(){
    updatestatus('Interview Onprogress');
  }
  void fetchchartdetailes()async{
    setState(() {
      loading=true;
    });
    var res = await api(context, "get_chart_details.php", {"A":Email,"B":applicantdata[ind]['post']});
    setState(() {
      chartdetails=res;
      screenflag2=true;
    });
    fetchinterview();
  }
  Chartdata1() {
    List educationdetailes=jsonDecode(applicantdata[ind]['eduacationinfo']);
    var data = [
      new ResumeDetails(educationdetailes[0]['program'], (double.parse(educationdetailes[0]['percentage'])/double.parse(educationdetailes[0]['mode']))*100, Colors.blue),
    ];
    for(int i=1;i<educationdetailes.length;i++){
      if(i%2==0){
        data.add(new ResumeDetails(educationdetailes[i]['program'], (double.parse(educationdetailes[i]['percentage'])/double.parse(educationdetailes[i]['mode']))*100, Colors.blue));
      }else{
        data.add(new ResumeDetails(educationdetailes[i]['program'], (double.parse(educationdetailes[i]['percentage'])/double.parse(educationdetailes[i]['mode']))*100, Colors.lightBlueAccent));
      }
    }
    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ResumeDetails ResumeData, _) => ResumeData.section,
        measureFn: (ResumeDetails ResumeData, _) => ResumeData.percentage,
        colorFn: (ResumeDetails ResumeData, _) => ResumeData.color,
        data: data,
      ),
    ];
    return series;
  }
  Chartdata2() {
    var data = [
      new ResumeDetails("Max", double.parse(chartdetails[0]['MAX(eduacationscore)']), Colors.blue),
      new ResumeDetails("Min", double.parse(chartdetails[0]['MIN(eduacationscore)']), Colors.lightBlueAccent),
      new ResumeDetails("Avg", double.parse(chartdetails[0]['AVG(eduacationscore)']), Colors.blue[700]),
      new ResumeDetails("self", double.parse(applicantdata[ind]['eduacationscore']), Colors.deepPurple),

    ];
    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ResumeDetails ResumeData, _) => ResumeData.section,
        measureFn: (ResumeDetails ResumeData, _) => ResumeData.percentage,
        colorFn: (ResumeDetails ResumeData, _) => ResumeData.color,
        data: data,
      ),
    ];
    return series;
  }
  Chartdata3() {
    var data = [
      new ResumeDetails("Max", double.parse(chartdetails[0]['MAX(skillscore)']), Colors.blue),
      new ResumeDetails("Min", double.parse(chartdetails[0]['MIN(skillscore)']), Colors.lightBlueAccent),
      new ResumeDetails("Avg", double.parse(chartdetails[0]['AVG(skillscore)']), Colors.blue[700]),
      new ResumeDetails("self", double.parse(applicantdata[ind]['skillscore']), Colors.deepPurple),

    ];
    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ResumeDetails ResumeData, _) => ResumeData.section,
        measureFn: (ResumeDetails ResumeData, _) => ResumeData.percentage,
        colorFn: (ResumeDetails ResumeData, _) => ResumeData.color,
        data: data,
      ),
    ];
    return series;
  }
  Chartdata4() {
    var data = [
      new ResumeDetails("Max", double.parse(chartdetails[0]['MAX(experiencescore)']), Colors.blue),
      new ResumeDetails("Min", double.parse(chartdetails[0]['MIN(experiencescore)']), Colors.lightBlueAccent),
      new ResumeDetails("Avg", double.parse(chartdetails[0]['AVG(experiencescore)']), Colors.blue[700]),
      new ResumeDetails("self", double.parse(applicantdata[ind]['experiencescore']), Colors.deepPurple),

    ];
    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ResumeDetails ResumeData, _) => ResumeData.section,
        measureFn: (ResumeDetails ResumeData, _) => ResumeData.percentage,
        colorFn: (ResumeDetails ResumeData, _) => ResumeData.color,
        data: data,
      ),
    ];
    return series;
  }
  Chartdata5() {
    var data = [
      new ResumeDetails("Max", double.parse(chartdetails[0]['MAX(testscore)']), Colors.blue),
      new ResumeDetails("Min", double.parse(chartdetails[0]['MIN(testscore)']), Colors.lightBlueAccent),
      new ResumeDetails("Avg", double.parse(chartdetails[0]['AVG(testscore)']), Colors.blue[700]),
      new ResumeDetails("self", double.parse(applicantdata[ind]['testscore']), Colors.deepPurple),

    ];
    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ResumeDetails ResumeData, _) => ResumeData.section,
        measureFn: (ResumeDetails ResumeData, _) => ResumeData.percentage,
        colorFn: (ResumeDetails ResumeData, _) => ResumeData.color,
        data: data,
      ),
    ];
    return series;
  }
  void showinterviewhistory(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Showinterviewhistory(interview);
    }));
  }

  @override
  Widget build(BuildContext context) {
    print(ismatching);
    return WillPopScope(

      onWillPop: () async {
        if(screenflag==false){
          return true;
        }else if(screenflag==true && screenflag2==false){
          setState(() {
            screenflag=false;
          });
        }else{
          setState(() {
            screenflag2=false;
          });
        }

      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Applyed Applicant'),
          ),
          body:loading==false?Container(
            child:screenflag==false?Container(
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height*0.05),
                      text(context, "Choose The Job Title", Colors.black, width * 0.06, FontWeight.w500),
                      ListView.builder(
                          padding: EdgeInsets.all(width * 0.05),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: vacancy.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                setState(() {
                                  fetchapplicantdata(vacancy[index]['post']);
                                });
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
                                      text(context, vacancy[index]['post'], Colors.white, width * 0.05, FontWeight.w500),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                )
            ):Container(
                child:SingleChildScrollView(
                  child: screenflag2==false?Column(
                    children: [
                      SizedBox(height: height*0.05),
                      Row(
                        children: [
                          Checkbox(
                            value: ismatching,
                            onChanged: (bool value) {
                              List temp = applicantdata.where((i) {
                                if(i['matching']=='true'){
                                  return true;
                                }else{
                                  return false;
                                }
                              }).toList();
                              setState(() {
                                backup=temp;
                                flag3=value;
                                ismatching = value;
                              });
                            },
                          ),
                          Expanded(child: text(context,"Matching Skill",Colors.black,width*0.05,FontWeight.normal)),
                        ],
                      ),
                      text(context, "Applyed Applicant", Colors.black, width * 0.06, FontWeight.w500),
                      flag3==false?ListView.builder(
                          padding: EdgeInsets.all(width * 0.05),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: applicantdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                setState(() {
                                    ind=index;
                                });
                                fetchchartdetailes();

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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: text(context,(jsonDecode(applicantdata[index]['personalinfo']))[0]['fname']+" "+
                                                  (jsonDecode(applicantdata[index]['personalinfo']))[0]['lname'], Colors.white, width * 0.05, FontWeight.w500),
                                            ),
                                            Align(
                                                alignment:Alignment.topLeft,
                                                child: text(context,(jsonDecode(applicantdata[index]['personalinfo']))[0]['resume_email'], Colors.white,
                                                    width * 0.05, FontWeight.w500)
                                            ),
                                            Align(
                                                alignment:Alignment.topLeft,
                                                child: text(context,"Status: "+applicantdata[index]['status'], Colors.white,
                                                    width * 0.05, FontWeight.normal)
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height*0.10,
                                        width:height*0.10,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:MemoryImage(base64.decode((jsonDecode(applicantdata[index]['personalinfo']))[0]['profile_picture'])),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(height*0.10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ):
                      ListView.builder(
                          padding: EdgeInsets.all(width * 0.05),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: backup.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                setState(() {
                                  ind=index;
                                });
                                fetchchartdetailes();

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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: text(context,(jsonDecode(backup[index]['personalinfo']))[0]['fname']+" "+
                                                  (jsonDecode(backup[index]['personalinfo']))[0]['lname'], Colors.white, width * 0.05, FontWeight.w500),
                                            ),
                                            Align(
                                                alignment:Alignment.topLeft,
                                                child: text(context,(jsonDecode(backup[index]['personalinfo']))[0]['resume_email'], Colors.white,
                                                    width * 0.05, FontWeight.w500)
                                            ),
                                            Align(
                                                alignment:Alignment.topLeft,
                                                child: text(context,"Status: "+backup[index]['status'], Colors.white,
                                                    width * 0.05, FontWeight.normal)
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height*0.10,
                                        width:height*0.10,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:MemoryImage(base64.decode((jsonDecode(backup[index]['personalinfo']))[0]['profile_picture'])),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(height*0.10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ):Padding(
                    padding: EdgeInsets.all(width*0.05),
                    child: Column(
                      children: [
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context,"Eduacation(per/field):", Colors.black, width * 0.05, FontWeight.w500),
                        ),
                        Container(
                          child:new Padding(
                            padding: new EdgeInsets.all(32.0),
                            child: new SizedBox(
                              height: 200.0,
                              child: new charts.BarChart(Chartdata1(), animate: true,),
                            ),
                          ),
                        ),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context,"Total Eduacation:", Colors.black, width * 0.05, FontWeight.w500),
                        ),
                        Container(
                          child:new Padding(
                            padding: new EdgeInsets.all(32.0),
                            child: new SizedBox(
                              height: 200.0,
                              child: new charts.BarChart(Chartdata2(), animate: true,),
                            ),
                          ),
                        ),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context,"Total Skill:", Colors.black, width * 0.05, FontWeight.w500),
                        ),
                        Container(
                          child:new Padding(
                            padding: new EdgeInsets.all(32.0),
                            child: new SizedBox(
                              height: 200.0,
                              child: new charts.BarChart(Chartdata3(), animate: true,),
                            ),
                          ),
                        ),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context,"Total Experience:", Colors.black, width * 0.05, FontWeight.w500),
                        ),
                        Container(
                          child:new Padding(
                            padding: new EdgeInsets.all(32.0),
                            child: new SizedBox(
                              height: 200.0,
                              child: new charts.BarChart(Chartdata4(), animate: true,),
                            ),
                          ),
                        ),
                        Align(
                          alignment:Alignment.topLeft,
                          child: text2(context,"Test Score:", Colors.black, width * 0.05, FontWeight.w500),
                        ),
                        Container(
                          child:new Padding(
                            padding: new EdgeInsets.all(32.0),
                            child: new SizedBox(
                              height: 200.0,
                              child: new charts.BarChart(Chartdata5(), animate: true,),
                            ),
                          ),
                        ),
                        interview.length!=0?Align(
                          alignment:Alignment.topLeft,
                          child: Column(
                            children: [
                              text2(context,(interview.length).toString()+" Attempt for this post ", Colors.black, width * 0.05, FontWeight.w500),
                              simplebtn(context,"Show interview History",width*0.06,height*0.07,width,showinterviewhistory),
                            ],
                          ),
                        ):Align(
                          alignment:Alignment.topLeft,
                          child: text2(context,"No Attempt for this post:", Colors.black, width * 0.05, FontWeight.w500),
                        ),
                        simplebtn(context,"Show Resume",width*0.06,height*0.07,width,showresume),
                        SizedBox(height: height*0.10),
                        Row(
                          children: [
                            Expanded(child: simplebtn(context,"Accepted",width*0.06,height*0.07,width,accepted)),
                            SizedBox(width: width*0.05),
                            Expanded(child: simplebtn(context,"Rejected",width*0.06,height*0.07,width,rejected)),
                          ],
                        ),
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
class ResumeDetails {
  final String section;
  final double percentage;
  final charts.Color color;

  ResumeDetails(this.section, this.percentage, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}