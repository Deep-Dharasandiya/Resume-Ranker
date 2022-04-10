import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app2/HomePageRecruiter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app2/LoderUploadVacancyToUploadVacancySkills.dart';

import 'VacancyRequiredSkills.dart';

class UploadVacncy extends StatefulWidget {

  UploadVacncy(this.email);
  String email;
  @override
  _UploadVacncy createState() => new _UploadVacncy(email);
}

class _UploadVacncy extends State<UploadVacncy> {
  _UploadVacncy(email);

  String post_name;
  var Question='A';
  String Ans,ique="xdcasfvfdvfgf",iopa=" s sfg sg sfs g",iopb="fs s gsg ",iopc="dsvfdsvfsf  sfv",iopd="dfds f gfg  s s",ians="A";
  int containerno=1;
  bool date=false;
  String queid='0';
  String date2;
  List AnsChoice = [{"ID":'A'}, {"ID":'B'},{"ID":'C'},{"ID":'D'}];
  List vacancy=[],Qque=[],postnamedata=[],skillnamedata=[];
  bool columnorstack=false,addvacancy=true,addque=false,aboutvacancy=false,aboutque=false,loadingaboutvacancy=false,loadingvacancylist=true,loadingaboutque=false,loadingquelist=false;

  TextEditingController no_vacancy =TextEditingController();
  String get no_vacancy2 => no_vacancy.text;

  TextEditingController que =TextEditingController();
  String get Que =>que.text;

  TextEditingController opa =TextEditingController();
  String get opA =>opa.text;

  TextEditingController opb =TextEditingController();
  String get opB => opb.text;

  TextEditingController opc =TextEditingController();
  String get opC => opc.text;

  TextEditingController opd =TextEditingController();
  String get opD => opd.text;

  TextEditingController salary1 =TextEditingController();
  String get Salary1 => salary1.text;

  TextEditingController salary2 =TextEditingController();
  String get Salary2 => salary2.text;

  TextEditingController other =TextEditingController();
  String get Other => other.text;

  void DefaultValueAboutVacancy(String post,String no,String minsalary,String maxsalary,String other2,String lastdate){
    post_name=post;
    no_vacancy =TextEditingController(text:no);
    salary1 =TextEditingController(text:minsalary);
    salary2 =TextEditingController(text:maxsalary);
    other =TextEditingController(text:other2);
    date=true;
    date2=lastdate;
    setState(() {
      columnorstack=true;
      addvacancy=false;
      aboutvacancy=true;
    });

  }

  void DefaultValueAboutque(String qque,String aa,String bb,String cc,String dd,String aans,String id){
    que =TextEditingController(text:qque);
    opa =TextEditingController(text:aa);
    opb =TextEditingController(text:bb);
    opc =TextEditingController(text:cc);
    opd =TextEditingController(text:dd);
    Ans=aans;
    queid=id;
    setState(() {
      addque=false;
      columnorstack=true;
      aboutque=true;
    });
  }

  void defaultvaluevacancy(){
    String temp;
    post_name=temp;
    no_vacancy =TextEditingController(text:"");
    salary1 =TextEditingController(text:"");
    salary2 =TextEditingController(text:"");
    other =TextEditingController(text:"");
    date=false;

  }

  void defaultvalueque(){
    String temp;
    que =TextEditingController(text:"");
    opa =TextEditingController(text:"");
    opb =TextEditingController(text:"");
    opc =TextEditingController(text:"");
    opd =TextEditingController(text:"");
    queid='0';
    Ans=temp;
  }

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void networkcheck(int r) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      Show_Aleart(context,"You Are Not Connected To Internet...");
    }
    else {
      if(r==1){
        setState(() {
          loadingaboutvacancy=true;
          InsetDataAboutVacancy();
        });
      }
      else if(r==2){
        setState(() {
          loadingaboutque=true;
        });
        InsetDataAboutQue();
      }

    }
  }

  void InsetDataAboutVacancy()async {
    final response = await http.post(
        "http://resumeranker.hopto.org/vacancy_upload2.php",
        body: {
          "A": post_name,
          "B": no_vacancy2,
          "C": widget.email,
          "G":Salary1,
          "H":Salary2,
          "I":Other,
          "J":selectedDate.toString(),
        }
    );
    var respbody = json.decode(response.body);
    if(respbody==1)
    {
      setState(() {
        date=false;
        loadingaboutvacancy=false;
        loadingvacancylist=true;
        aboutvacancy=false;
        columnorstack=false;

      });
      FetchVacancy();
    }
    else
    {
      Show_Aleart(context, "Server Not Responding");
    }
  }

  void InsetDataAboutQue()async {
    print(queid);

    final response = await http.post(
        "http://resumeranker.hopto.org/upload_que.php",
        body: {
          "A":queid,
          "B": post_name,
          "C": Que,
          "D":opA,
          "E":opB,
          "F":opC,
          "G":opD,
          "H":Ans,
          "I":widget.email,
        }
    );
    var respbody = json.decode(response.body);
    if(respbody==1)
    {
      setState(() {
        addvacancy=false;
        loadingaboutque=false;
        aboutque=false;
        columnorstack=false;
        loadingquelist=true;
        addque=false;

      });
      FetchQue();
    }
    else
    {
      Show_Aleart(context, "Server Not Responding");
    }
  }

  void FetchVacancy()async {
    final response = await http.post(
        "http://resumeranker.hopto.org/getvacancypostnodate.php",
        body: {
          "A": widget.email,
        }
    );
    if(response.statusCode==200){
      setState(() {
        vacancy=json.decode(response.body);
        loadingvacancylist=false;
        addvacancy=true;
        addque=false;
      });
    }
    else{
      Show_Aleart(context, "Server Not Responding");
    }
  }

  void FetchQue()async {
    final response = await http.post(
        "http://resumeranker.hopto.org/que_paper.php",
        body: {
          "A": widget.email,
          "B": post_name,
        }
    );
    if(response.statusCode==200){
      Qque=json.decode(response.body);
      setState(() {
        addvacancy=false;
        loadingquelist=false;
        addque=true;
      });
    }
    else{
      Show_Aleart(context, "Server Not Responding");
    }
  }

  void DeleteVacancy(String post)async {
    final response = await http.post(
        "http://resumeranker.hopto.org/deletevacancy.php",
        body: {
          "A": widget.email,
          "B": post,
        }
    );
    if(response.statusCode==200){
      var deleteornot=json.decode(response.body);
      if(deleteornot==1){
        FetchVacancy();
      }
    }
    else{
      Show_Aleart(context, "Server Not Responding");
    }
  }

  void DeleteQue(String id)async {
    setState(() {
      addque=false;
      loadingquelist=true;
    });
    final response = await http.post(
        "http://resumeranker.hopto.org/deleteque.php",
        body: {
          "A": widget.email,
          "B": id,
        }
    );
    if(response.statusCode==200){
      var deleteornot=json.decode(response.body);
      if(deleteornot==1){
        FetchQue();
      }
    }
    else{
      Show_Aleart(context, "Server Not Responding");
    }
  }

  void FetchDataPostandSkills() async {
      final response = await http.get('http://resumeranker.hopto.org/vacancy_post.php');
      if (response.statusCode == 200) {
        final responseskill = await http.get('http://resumeranker.hopto.org/vacancy_skills.php');
        if (responseskill.statusCode == 200) {
            postnamedata = json.decode(response.body);
            skillnamedata = json.decode(responseskill.body);
        }
        else{
          Show_Aleart(context, "Server Not Responding...");
        }
      }
      else{
        Show_Aleart(context, "Server Not Responding...");
      }
  }

  Show_Aleart(BuildContext context,String message) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text(message),
            actions: <Widget>[

              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

int t=0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double hight = MediaQuery. of(context). size. height;
    double ratio=hight/width;
    if(t==0) {
      FetchVacancy();
      FetchDataPostandSkills();
      t=t+1;
    }
    return  WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Conformation'),
                  content: Text(
                      'Are You Sure, You Want To Go Home... '),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Yes'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return  Homepage1(widget.email);
                        }));
                        /*Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);*/
                      },
                    ),
                    new FlatButton(
                      child: new Text('NO'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });

          return false;
        },
      child: Scaffold(
          appBar: new AppBar(
            leading: IconButton(icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
             onPressed: () {
               aboutvacancy==true? setState(() {
                 aboutvacancy=false;
                 columnorstack=false;
                 addvacancy=true;

               }):
               addque==true?setState(() {
                 addque=false;
                 columnorstack=true;
                 aboutvacancy=true;

               }):
               aboutque==true?setState(() {
                 aboutque=false;
                 columnorstack=false;
                 addque=true;

               }):setState(() {
                 aboutvacancy=false;
                 columnorstack=false;
                 addvacancy=true;
                 loadingquelist=false;
                 loadingvacancylist=false;
               });
             }
            ),
            title: Text('Vacancy',style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),

            backgroundColor: Colors.white,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () {
                  // do something
                },
              ),
            ],
          ),
          body: new Center(
             child:  Container(
                  constraints: BoxConstraints.expand(),
                  height: hight,
                  width: width,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         image: new AssetImage('assets/back15.png'),
                         fit: BoxFit.cover)
                  ),
               child:columnorstack==true?SingleChildScrollView(
                   child: Column(
                     children: <Widget>[
                       aboutvacancy==true?Container (
                         child:SingleChildScrollView(
                           child:Container(
                             padding: EdgeInsets.all(5),
                                 child:  Column(
                                   children: <Widget>[
                                    Card(
                                    // margin: EdgeInsets.all(5.0),
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(15.0)
                                     ),
                                     elevation: 5,
                                      child:Container(
                                        margin: EdgeInsets.all(10),
                                        child:   Column(
                                            children: <Widget>[
                                              Text(" "),
                                              Text("-:About Vacancy:-",style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontFamily: 'design.graffiti.comicsansms'),),
                                              Text(" "),

                                              new DropdownButton(
                                                isExpanded: true,
                                                hint:Text("post:",style: new TextStyle(fontSize: 18.0,color: Colors.black),),
                                                items: postnamedata.map((item){
                                                  return new DropdownMenuItem(
                                                    child:new Text(item['post']),
                                                    value: item['post'].toString(),
                                                  );

                                                }).toList(),
                                                onChanged: (newVal){
                                                  setState(() {
                                                    post_name=newVal;
                                                  });
                                                },
                                                value: post_name,
                                              ),
                                              TextField(
                                                controller:no_vacancy,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: 'Number of Vacancy: ',
                                                    labelStyle: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: 'design.graffiti.comicsansms',
                                                        color: Colors.black),
                                                    focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.blue))),
                                              ),
                                              TextField(
                                                controller : salary1,
                                                //enabled: loading==true?false:true,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: 'Minimum Salary(In Rupees):',
                                                    labelStyle: TextStyle(
                                                        fontFamily: 'design.graffiti.comicsansms',
                                                        color: Colors.black),
                                                    focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.blue))),
                                              ),
                                              TextField(
                                                controller : salary2,
                                                //enabled: loading==true?false:true,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: 'Highest Salary(In Rupees):',
                                                    labelStyle: TextStyle(
                                                        fontFamily: 'design.graffiti.comicsansms',
                                                        color: Colors.black),
                                                    focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.blue))),
                                              ),
                                              TextField(
                                                controller:other,
                                                //enabled: loading==true?false:true,
                                                minLines: 1,
                                                //maxLines: null,
                                                decoration: InputDecoration(
                                                    labelText: 'Other Instruction & Details:',
                                                    labelStyle: TextStyle(fontFamily: 'design.graffiti.comicsansms', color: Colors.black),
                                                    focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.blue))),
                                              ),
                                             Text(" "),
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                    side: BorderSide(color: Colors.black)
                                                ),
                                                onPressed:(){
                                                  _selectDate(context);
                                                },
                                                color: Colors.white,
                                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                child:Center(
                                                  child: Row(
                                                children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.blue,
                                                ),
                                                Text("Last Date For Applying: ",style: TextStyle(
                                                    color: Colors.black,
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    fontFamily: 'design.graffiti.comicsansms'),),

                                                ((selectedDate.toString()).split(' ')[0]==(DateTime.now().toString()).split(' ')[0] && date==true)?Text(date2,style: TextStyle(color: Colors.blue)):Text("${selectedDate.toLocal()}".split(' ')[0],style: TextStyle(color: Colors.blue)),

                                                ],
                                              ),
                                                ),
                                              ),
                                              //date==false?Text("${selectedDate.toLocal()}".split(' ')[0]):Text(date2),
                                              Text(" "),
                                            ]
                                        ),
                                      ),
                                     ),
                                     Card(
                                       // margin: EdgeInsets.all(5.0),
                                       shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(15.0)
                                       ),
                                       elevation: 5,
                                       child:Container(
                                         margin: EdgeInsets.all(10),
                                         child:   Column(
                                           children: <Widget>[
                                             Text(" "),
                                             Text("-:Required Skills:-",style: TextStyle(
                                                 color: Colors.blue,
                                                 fontSize: 20,
                                                 fontFamily: 'design.graffiti.comicsansms'),),
                                             Text(" "),
                                             RaisedButton(
                                               shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(18.0),
                                                   side: BorderSide(color: Colors.black)
                                               ),
                                               onPressed:(){
                                                 Navigator.push(context, MaterialPageRoute(builder: (context){
                                                   // return Ranking_page();
                                                   return  VacancyRequiredSkills(widget.email,'Android Developer');
                                                 }));
                                                 },
                                               color: Colors.white,
                                               padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                               child:Center(
                                                   child:Row(
                                                     children: <Widget>[
                                                       Expanded(
                                                         child:Text("Required Skills: ",style: TextStyle(
                                                             color: Colors.black,
                                                             //fontWeight: FontWeight.bold,
                                                             fontSize: 13,
                                                             fontFamily: 'design.graffiti.comicsansms'),),
                                                       ),
                                                       Icon(
                                                         Icons.add_circle_outline,
                                                         color: Colors.blue,
                                                       ),

                                                     ],
                                                   )
                                               ),
                                             ),
                                            /* new DropdownButton(
                                               isExpanded: true,
                                               hint: Text("Skill-1:",style: new TextStyle(fontSize: 18.0,color: Colors.black),),
                                               items:skillnamedata.map((item){
                                                 return new DropdownMenuItem(
                                                   child:new Text(item['skills_name']),
                                                   value: item['skills_name'].toString(),
                                                 );

                                               }).toList(),
                                               onChanged: (newVal){
                                                 setState(() {
                                                   skill1=newVal;
                                                 });
                                               },
                                               value: skill1,

                                             ),
                                             new DropdownButton(
                                               isExpanded: true,
                                               hint: Text("Skill-2:",style: new TextStyle(fontSize: 18.0,color: Colors.black),),
                                               items: skillnamedata.map((item){
                                                 return new DropdownMenuItem(
                                                   child:new Text(item['skills_name']),
                                                   value: item['skills_name'].toString(),
                                                 );

                                               }).toList(),
                                               onChanged: (newVal){
                                                 setState(() {
                                                   skill2=newVal;
                                                 });
                                               },
                                               value: skill2,

                                             ),
                                             new DropdownButton(
                                               isExpanded: true,
                                               hint: Text("Skill-3    ",style: new TextStyle(fontSize: 18.0,color: Colors.black),),
                                               items: skillnamedata.map((item){
                                                 return new DropdownMenuItem(
                                                   child:new Text(item['skills_name']),
                                                   value: item['skills_name'].toString(),
                                                 );

                                               }).toList(),
                                               onChanged: (newVal){
                                                 setState(() {
                                                   skill3=newVal;
                                                 });
                                               },
                                               value: skill3,

                                             ),*/
                                             Text(" "),
                                             ]
                                         ),
                                       ),
                                     ),
                                     Card(
                                       // margin: EdgeInsets.all(5.0),
                                       shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(15.0)
                                       ),
                                       elevation: 5,
                                       child:Container(
                                         margin: EdgeInsets.all(10),
                                         child:   Column(
                                           children: <Widget>[
                                             Text(" "),
                                             Text("-:Apptitude Test Questions:-",style: TextStyle(
                                                 color: Colors.blue,
                                                 fontSize: 20,
                                                 fontFamily: 'design.graffiti.comicsansms'),),
                                             Text(" "),
                                             RaisedButton(
                                               shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(18.0),
                                                   side: BorderSide(color: Colors.black)
                                               ),
                                               onPressed:(){

                                                 setState(() {
                                                   aboutvacancy=false;
                                                   columnorstack=false;
                                                   loadingquelist=true;
                                                 });
                                                 FetchQue();

                                               },
                                               color: Colors.white,
                                               padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                               child:Center(
                                                 child:Row(
                                               children: <Widget>[
                                                 Expanded(
                                                   child:Text("Questions: ",style: TextStyle(
                                                       color: Colors.black,
                                                       //fontWeight: FontWeight.bold,
                                                       fontSize: 13,
                                                       fontFamily: 'design.graffiti.comicsansms'),),
                                                 ),
                                                 Icon(
                                                   Icons.add_circle_outline,
                                                   color: Colors.blue,
                                                 ),

                                               ],
                                             )
                                               ),
                                             ),
                                             Text(" "),

                                           ],
                                         ),
                                       ),
                                     ),
                                     Text(" "),
                                     loadingaboutvacancy==false?Container(
                                       padding: new EdgeInsets.fromLTRB(5,5,5,5),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.deepPurpleAccent)
                                        ),
                                        onPressed:(){
                                          if(post_name=="" || no_vacancy2=="" || Salary1=="" || Salary2=="" || selectedDate == DateTime.now() ) {
                                            Show_Aleart(context, "All Data Are Required...");
                                          }
                                          else{
                                              if(double.parse('$Salary1') >double.parse('$Salary2') ){
                                                Show_Aleart(context, "Enter Correct Salary...");
                                              }
                                              else {
                                                networkcheck(1);
                                              }

                                          }
                                        },
                                        color: Colors.blue,
                                        padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                                        child: Text("Save",style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'design.graffiti.comicsansms'),),
                                      ),
                                     ):Container(
                                       padding: new EdgeInsets.fromLTRB(5,5,5,5),
                                       child: Column(
                                         children: <Widget>[
                                           Text("Please Wait.."),
                                           Text(""),
                                           CircularProgressIndicator(),

                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                         ),
                       ):Container(),

                       aboutque==true? Container(
                         child:Column(
                           children: <Widget>[
                        // padding: new EdgeInsets.fromLTRB(0,0,0,0),
                         Card(
                           margin: EdgeInsets.all(5.0),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(15.0),
                           ),
                           elevation: 5,
                           child:Container(
                             padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                             child:Column(
                               children: <Widget>[
                                 Text("Question: 1",style: TextStyle(
                                     color: Colors.blue,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 30,
                                     fontFamily: 'design.graffiti.comicsansms'),),

                                 TextField(
                                   controller:que,
                                   //enabled: loading==true?false:true,
                                   maxLines: null,
                                   decoration: InputDecoration(
                                       labelText: 'Question:',
                                       labelStyle: TextStyle(fontFamily: 'design.graffiti.comicsansms', color: Colors.black),
                                       focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue))),
                                 ),
                                 TextField(
                                   controller : opa,
                                   //enabled: loading==true?false:true,
                                   maxLines: null,
                                   decoration: InputDecoration(
                                       labelText: 'Option-A:',
                                       labelStyle: TextStyle(
                                           fontFamily: 'design.graffiti.comicsansms',
                                           color: Colors.black),
                                       // hintText: 'EMAIL',
                                       // hintStyle: ,
                                       focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue))),
                                 ),
                                 TextField(
                                   controller : opb,
                                   //enabled: loading==true?false:true,
                                   maxLines: null,
                                   decoration: InputDecoration(
                                       labelText: 'Option-B: ',
                                       labelStyle: TextStyle(
                                           fontFamily: 'design.graffiti.comicsansms',
                                           color: Colors.black),
                                       focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue))),
                                 ),
                                 TextField(
                                   controller: opc,
                                   //enabled: loading==true?false:true,
                                   maxLines: null,
                                   decoration: InputDecoration(
                                       labelText: 'Option-C:',
                                       labelStyle: TextStyle(
                                           fontFamily: 'design.graffiti.comicsansms',
                                           color: Colors.black),
                                       focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue))),
                                 ),
                                 TextField(
                                   controller : opd,
                                   //enabled: loading==true?false:true,
                                   maxLines: null,
                                   decoration: InputDecoration(
                                       labelText: 'Option-D:',
                                       labelStyle: TextStyle(
                                           fontFamily: 'design.graffiti.comicsansms',
                                           color: Colors.black),
                                       focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide( color: Colors.blue))),

                                 ),
                                 Text(" "),
                                 DropdownButton(
                                   isExpanded: true,
                                   hint: Text( 'Select Ans: ',style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 15,
                                       fontFamily: 'design.graffiti.comicsansms'),),
                                   items: AnsChoice.map((item){
                                     return new DropdownMenuItem(
                                       child:new Text(item['ID']),
                                       value: item['ID'].toString(),
                                     );

                                   }).toList(),
                                   onChanged: (newVal){
                                     setState(() {
                                       Ans=newVal;
                                     });
                                   },
                                   value: Ans,

                                 ),
                                 //loading==true?
                                 /*loadingaboutque==true?Container(
                                   padding: new EdgeInsets.fromLTRB(5,5,5,5),
                                   child: Column(
                                     children: <Widget>[
                                       CircularProgressIndicator(),
                                       Text(""),
                                       Text("Please Wait.."),
                                     ],
                                   ),
                                 ):Container(),*/
                                 /*RaisedButton(
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(18.0),
                                       side: BorderSide(color: Colors.deepPurpleAccent)
                                   ),
                                   onPressed:(){
                                     setState(() {
                                       loadingaboutque=true;
                                     });
                                     InsetDataAboutQue();

                                   },
                                   color: Colors.blue,
                                   padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                                   child: Text("Save",style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'design.graffiti.comicsansms'),),
                                 ),
                                  */
                               ],
                             ),
                           ),
                         ),
                             loadingaboutque==false?Container(
                               padding: new EdgeInsets.fromLTRB(5,5,5,5),
                               child: RaisedButton(
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18.0),
                                     side: BorderSide(color: Colors.deepPurpleAccent)
                                 ),
                                 onPressed:(){
                                   setState(() {
                                     loadingaboutque=true;
                                   });
                                   InsetDataAboutQue();

                                 },
                                 color: Colors.blue,
                                 padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                                 child: Text("Save",style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 20,
                                     fontWeight: FontWeight.bold,
                                     fontFamily: 'design.graffiti.comicsansms'),),
                               ),
                             ):Container(
                               padding: new EdgeInsets.fromLTRB(5,5,5,5),
                               child: Column(
                                 children: <Widget>[
                                   Text("Please Wait.."),
                                   Text(""),
                                   CircularProgressIndicator(),

                                 ],
                               ),
                             ),
                        ],
                         ),
                       ):Container(),
                     ],
                   ),
                   ):Stack(
                     children: <Widget>[
                       loadingvacancylist==false?Container(
                       child:addvacancy==true?Container(
                         //padding: EdgeInsets.all(ratio*5),....
                         padding: EdgeInsets.all(0),
                         child:Stack(
                           children: <Widget>[
                              vacancy.length!=0 ? ListView.builder(
                           itemCount: vacancy.length,
                           itemBuilder: (BuildContext context, int index) {
                             return Card(

                               margin: EdgeInsets.all(5),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                               ),
                               //elevation: 3.0,

                               child: new Container(
                                 child:SingleChildScrollView(
                                   padding: EdgeInsets.all(5),
                                   child:Container(
                                     child:Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Row(
                                           children: <Widget>[
                                             Icon(
                                               Icons.person_outline,
                                               color: Colors.black,
                                               size: 20.0,
                                             ),
                                             Expanded(
                                               child:Column(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: <Widget>[
                                                   Text(vacancy[index]['post'],overflow: TextOverflow.clip,style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'design.graffiti.comicsansms'),),
                                                 ],
                                               ),
                                             ),


                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Icon(
                                               Icons.confirmation_number,
                                               color: Colors.black,
                                               size: 20.0,
                                             ),
                                             Text(vacancy[index]['no'],style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'design.graffiti.comicsansms'),),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Icon(
                                               Icons.date_range,
                                               color: Colors.black,
                                               size: 20.0,
                                             ),
                                             Text(vacancy[index]['lastdate'],style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'design.graffiti.comicsansms'),),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Expanded(
                                               child:  FlatButton(
                                                 onPressed: () {
                                                   DefaultValueAboutVacancy(vacancy[index]['post'],vacancy[index]['no'],vacancy[index]['minsalary'],vacancy[index]['maxsalary'],vacancy[index]['other'],vacancy[index]['lastdate']);
                                                 },
                                                 child:  new Icon(Icons.update , size: 25,color: Colors.blue,),
                                               ),
                                             ),

                                             Expanded(
                                               child:  FlatButton(
                                                 onPressed: () {
                                                   showDialog(
                                                       context: context,
                                                       builder: (context) {
                                                         return AlertDialog(
                                                           title: Text('Conformation'),
                                                           content: Text(
                                                               'Are You Sure, You Want To Delete This Vacancy... '),
                                                           actions: <Widget>[
                                                             new FlatButton(
                                                               child: new Text('Yes'),
                                                               onPressed: () {
                                                                 DeleteVacancy(vacancy[index]['post']);
                                                                 Navigator.pop(context);
                                                               },
                                                             ),
                                                             new FlatButton(
                                                               child: new Text('NO'),
                                                               onPressed: () {
                                                                 Navigator.pop(context);
                                                               },
                                                             )
                                                           ],
                                                         );
                                                       });
                                                 },
                                                 child:  new Icon(Icons.delete_outline , size: 25,color: Colors.blue,),
                                               ),
                                             ),
                                           ],
                                         ),

                                       ],
                                     ),

                                   ),
                                 ),
                               ),
                             );
                           },
                         ):Container(
                                child:Center(
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Empty Data..."),
                                    ],
                                  ),
                                ),
                             ),
                             Align(
                               alignment: FractionalOffset.bottomCenter,
                               child: Padding(
                                 padding: EdgeInsets.only(bottom: 10.0),
                                 child: FloatingActionButton(
                                   onPressed:(){
                                     defaultvaluevacancy();
                                     setState(() {
                                       columnorstack=true;
                                       addvacancy=false;
                                       aboutvacancy=true;
                                     });
                                   },
                                   tooltip: 'Add Vacancy',
                                   child: new Icon(Icons.add,size: 30),
                                 ),//Your widget here,
                               ),
                             ),


                           ],
                         ),
                       ):Container(),
                       ):Container(
                         child:Center(
                           child:Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             CircularProgressIndicator(),
                             Text("Please Wait"),
                           ],
                           ),
                         ),
                       ),
                       loadingquelist==false? Container(
                       child: addque==true?Container(
                         //padding: EdgeInsets.all(ratio*5),....
                         padding: EdgeInsets.all(0),
                         child:Stack(
                           children: <Widget>[

                             Qque.length!=0 ? ListView.builder(
                           itemCount: Qque.length,
                           itemBuilder: (BuildContext context, int index) {
                             return Card(

                               margin: EdgeInsets.all(5),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                               ),
                               elevation: 5.0,

                               child: new Container(
                                 child:SingleChildScrollView(
                                   padding: EdgeInsets.all(5),
                                   child:Container(
                                     child:Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         /*Text("1",style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                    Text(" "),*/

                                         Row(
                                           children: <Widget>[
                                             Icon(Icons.question_answer, color: Colors.black, size: 13.0),
                                             Text(" "),
                                             //Text("=>  ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                             Expanded(
                                               child: Card(
                                                 elevation: 2.0,
                                                 child:Container(
                                                   padding: EdgeInsets.all(5),
                                                   child:Column(
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(Qque[index]['que'],style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                                     ],
                                                   ),
                                                 ),

                                               ),
                                             ),

                                           ],
                                         ),
                                         Text(" "),

                                         Row(
                                           children: <Widget>[
                                             Qque[index]['ans']=='A'?Icon(Icons.check_circle, color: Colors.black, size: 15.0):
                                             Icon(Icons.check_circle_outline, color: Colors.black, size: 15.0),
                                             //Text("A>  ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                             Expanded(
                                               child: Card(
                                                 elevation: 1.0,
                                                 child:Container(
                                                   padding: EdgeInsets.all(5),
                                                   child:Column(
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(Qque[index]['a'],style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                                     ],
                                                   ),
                                                 ),

                                               ),
                                             ),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Qque[index]['ans']=='B'?Icon(Icons.check_circle, color: Colors.black, size: 15.0):
                                             Icon(Icons.check_circle_outline, color: Colors.black, size: 15.0),
                                             //Text("A>  ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                             Expanded(
                                               child: Card(
                                                 elevation: 1.0,
                                                 child:Container(
                                                   padding: EdgeInsets.all(5),
                                                   child:Column(
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(Qque[index]['b'],style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                                     ],
                                                   ),
                                                 ),

                                               ),
                                             ),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Qque[index]['ans']=='C'?Icon(Icons.check_circle, color: Colors.black, size: 15.0):
                                             Icon(Icons.check_circle_outline, color: Colors.black, size: 15.0),
                                             //Text("A>  ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                             Expanded(
                                               child: Card(
                                                 elevation: 1.0,
                                                 child:Container(
                                                   padding: EdgeInsets.all(5),
                                                   child:Column(
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(Qque[index]['c'],style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                                     ],
                                                   ),
                                                 ),

                                               ),
                                             ),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Qque[index]['ans']=='D'?Icon(Icons.check_circle, color: Colors.black, size: 15.0):
                                             Icon(Icons.check_circle_outline, color: Colors.black, size: 15.0),
                                             //Text("A>  ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                             Expanded(
                                               child: Card(
                                                 elevation: 1.0,
                                                 child:Container(
                                                   padding: EdgeInsets.all(5),
                                                   child:Column(
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(Qque[index]['d'],style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'design.graffiti.comicsansms'),),
                                                     ],
                                                   ),
                                                 ),

                                               ),
                                             ),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Expanded(
                                               child:  FlatButton(
                                                 onPressed: () {
                                                   DefaultValueAboutque(Qque[index]['que'],Qque[index]['a'],Qque[index]['b'],Qque[index]['c'],Qque[index]['d'],Qque[index]['ans'],Qque[index]['Id']);
                                                 },
                                                 child:  new Icon(Icons.update , size: 25,color: Colors.blue,),
                                               ),
                                             ),
                                             Text("1",style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 20,
                                                 fontFamily: 'design.graffiti.comicsansms'),),
                                             Expanded(
                                               child:  FlatButton(
                                                 onPressed: () {
                                                   showDialog(
                                                       context: context,
                                                       builder: (context) {
                                                         return AlertDialog(
                                                           title: Text('Conformation'),
                                                           content: Text(
                                                               'Are You Sure, You Want To Delete This Vacancy... '),
                                                           actions: <Widget>[
                                                             new FlatButton(
                                                               child: new Text('Yes'),
                                                               onPressed: () {
                                                                 DeleteQue(Qque[index]['Id']);
                                                                 Navigator.pop(context);
                                                               },
                                                             ),
                                                             new FlatButton(
                                                               child: new Text('NO'),
                                                               onPressed: () {
                                                                 Navigator.pop(context);
                                                               },
                                                             )
                                                           ],
                                                         );
                                                       });
                                                 },
                                                 child:  new Icon(Icons.delete_outline , size: 25,color: Colors.blue,),
                                               ),
                                             ),
                                           ],
                                         ),
                                         index==24?SizedBox(
                                           height: 30.0,
                                         ):SizedBox(
                                           height: 0.0,
                                         ),
                                       ],
                                     ),

                                   ),
                                 ),
                               ),
                             );
                           },
                         ):Container(
                               child:Center(
                                 child:Column(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: <Widget>[
                                     Text("Empty Data..."),
                                   ],
                                 ),
                               ),
                             ),
                             Align(
                               alignment: FractionalOffset.bottomRight,
                               child: Padding(
                                 padding: EdgeInsets.only(bottom: 30.0,right: 20.0),
                                 child: FloatingActionButton(
                                   onPressed:(){
                                     defaultvalueque();
                                     setState(() {
                                       columnorstack=true;
                                       addque=false;
                                       aboutque=true;
                                     });
                                   },
                                   tooltip: 'Add Vacancy',
                                   child: new Icon(Icons.add,size: 30,color:Colors.black),
                                 ),//Your widget here,
                               ),
                             ),

                           ],
                         ),
                       ):Container(),
                        ):Container(
                          child:Center(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Text("Please Wait"),
                              ],
                            ),
                          ),
                        ),
                     ],
                   ),
               ),
             )
      ),
    );
  }
}
