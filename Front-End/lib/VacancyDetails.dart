import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'Home.dart';
import 'LoaderHomePageApplicantToShowVacancy.dart';
import 'LoaderHomePageToResumeBuilder.dart';
import 'ShowResume.dart';
import 'TechnicalSkills.dart';

class VacancyDetails extends StatefulWidget {
  VacancyDetails(this.email,this.coemail,this.name,this.post,this.no,this.minsalary,this.maxsalary,this.uplodeddate,this.lastdate,this.city,this.aboutvacancy,this.icon);
  String email,coemail,post,no,minsalary,maxsalary,uplodeddate,lastdate,city,icon,name,aboutvacancy;


  @override
  _VacancyDetails createState() => new _VacancyDetails(email,coemail,name,post,no,minsalary,maxsalary,uplodeddate,lastdate,city,aboutvacancy,icon);
}

class _VacancyDetails extends State<VacancyDetails> {
  _VacancyDetails(email,coemail,name,post,no,minsalary,maxsalary,uplodeddate,lastdate,city,aboutvacancy,icon);
  List Comdetails=[];
  bool Mainloader=true;
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
  void fetchvacancydetails() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_company_details.php",
        body: {
          "A": widget.coemail,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        Comdetails = json.decode(response.body);
        Mainloader=false;
      });
    }
    else{
      error();
    }
  }

  int t=0;
  @override
  Widget build(BuildContext context) {
    if (t == 0) {
      fetchvacancydetails();
      t = t + 1;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: Text("About Vacancy",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),

          actions: <Widget>[
          ],
        ),
        body:Mainloader==false?Column(
          children: <Widget>[
            Card(
              elevation: 5,
              child:Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.post,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight:FontWeight.w600, fontFamily: 'design.graffiti.comicsansms'),),
                            Text(widget.name,style: TextStyle(color: Colors.black, fontSize: 17,fontWeight:FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),
                          ],
                        ),
                        Expanded(
                          child: Text("  "),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                          height:60,
                          width: 60,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new Image.memory(base64Decode(widget.icon)).image,
                              )
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Icon(Icons.location_on, size: 17,color: Colors.blue),
                        Text(" "),
                        Text(widget.city,style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Icon(Icons.payment, size: 17,color: Colors.blue),
                        Text(" "),
                        Text(widget.minsalary,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                        Text(" - "),
                        Text(widget.maxsalary+" ₹",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Icon(Icons.date_range, size: 17,color: Colors.blue),
                        Text(" "),
                        Text(widget.uplodeddate,style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:Text(" "),
                        ),
                        new Icon(Icons.timer, size: 15,color: Colors.black54),
                        Text(' Apply By '+widget.lastdate,style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              child:Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('About '+widget.name+" :",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight:FontWeight.w500, fontFamily: 'design.graffiti.comicsansms'),),
                    Divider(
                      color: Colors.black,
                    ),
                    //Text('Company Contain:',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                    Text('    '+ Comdetails[0]['contain'],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w500, fontFamily: 'design.graffiti.comicsansms'),),
                    Text(" ",style: TextStyle(fontSize: 10),),
                    //Text('Company Description:',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                    Text('    '+ Comdetails[0]['other'],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w500, fontFamily: 'design.graffiti.comicsansms'),),
                    Text(" ",style: TextStyle(fontSize: 10),),
                   // Text('Company Contact:',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                    Row(
                      children: <Widget>[
                        new Icon(Icons.contacts, size: 16,color: Colors.blue),
                        Text(" "),
                        Text(Comdetails[0]['contect'],style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Icon(Icons.email, size: 16,color: Colors.blue),
                        Text(" "),
                        Text(widget.coemail,style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Icon(Icons.location_on, size: 16,color: Colors.blue),
                        Text(" "),
                        Text(Comdetails[0]['ladd']+","+widget.city+","+Comdetails[0]['ta']+","+Comdetails[0]['dis']+","+Comdetails[0]['pin'].toString(),style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              child:Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('About Vacancy:',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight:FontWeight.w500, fontFamily: 'design.graffiti.comicsansms'),),
                    Divider(
                      color: Colors.black,
                    ),
                    Text('    '+ widget.aboutvacancy,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w500, fontFamily: 'design.graffiti.comicsansms'),),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child:Center(
                child:RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.lightBlue)
                  ),
                  onPressed:(){

                  },
                  color: Colors.lightBlue,
                  padding: EdgeInsets.all(10),
                  child:Center(
                    child: Text("Apply For Jobs",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'design.graffiti.comicsansms'),),
                  ),
                ),
              ),
            ),
          ],
        ):Container(
          child:Center(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(" "),
                CircularProgressIndicator(),
                Text(" "),
                Text("Please Wait"),
              ],
            ),
          ),
        ),
      ),
    );
}
}