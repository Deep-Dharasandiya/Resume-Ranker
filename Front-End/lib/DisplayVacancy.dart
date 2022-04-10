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
import 'TechnicalSkills.dart';
import 'VacancyDetails.dart';

class DisplayVacancy extends StatefulWidget {
  DisplayVacancy(this.email);
  String email;


  @override
  _DisplayVacancy createState() => new _DisplayVacancy(email);
}

class _DisplayVacancy extends State<DisplayVacancy> {
  _DisplayVacancy(email);
  bool Mainloader=true;
  List vacancy;
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
  void fetchvacancy()async{
    final response = await http.get(
        'http://resumeranker.hopto.org/get_vacancy.php');
    if (response.statusCode == 200) {
      vacancy = json.decode(response.body);
      setState(() {
        Mainloader=false;
      });
    }
  }
  void changescreen(String email,String coemail,String name,String post,String no,String minsalary,String maxsalary,String uplodeddate,String lastdate,String city,String aboutvacancy,String icon){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return VacancyDetails(email,coemail,name,post,no,minsalary,maxsalary,uplodeddate,lastdate,city,aboutvacancy,icon);
    }));
  }
  int t=0;
  @override
  Widget build(BuildContext context) {
    if (t == 0) {
      fetchvacancy();
      t = t + 1;
    }
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
     child:MaterialApp(
       debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Expanded(
                child:Text("Jobs",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
              ),
              Icon(Icons.search, color: Colors.blue,),
              Text(' '),
              Icon(Icons.filter, color: Colors.blue,),
            ],
          ),
          actions: <Widget>[
          ],
        ),
        body: Mainloader==false?Container(
          height: hight,
          child:vacancy.length!=0?ListView.builder(
              shrinkWrap: true,
              itemCount:vacancy.length,
              itemBuilder: (BuildContext context,int index){
                return Container(
                  child:Container(
                    child:GestureDetector(
                      onTap: () {
                        changescreen(widget.email,vacancy[index]['email'],vacancy[index]['name'],vacancy[index]['post'],vacancy[index]['no'].toString(),vacancy[index]['minsalary'].toString(),vacancy[index]['maxsalary'].toString(),vacancy[index]['uploded_date'],vacancy[index]['lastdate'],vacancy[index]['city'],vacancy[index]['other'],vacancy[index]['icon']);
                      },
                      child: Card(
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
                                      Text(vacancy[index]['post'],style: TextStyle(color: Colors.black,fontSize: 17,fontWeight:FontWeight.w600, fontFamily: 'design.graffiti.comicsansms'),),
                                      Text(vacancy[index]['name'],style: TextStyle(color: Colors.black, fontSize: 17,fontWeight:FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),
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
                                          image: new Image.memory(base64Decode(vacancy[index]["icon"])).image,
                                        )
                                    ),
                                  ),

                                ],
                              ), Row(
                                children: <Widget>[
                                  new Icon(Icons.confirmation_number, size: 17,color: Colors.blue),
                                  Text(" "),
                                  Text(vacancy[index]['no'],style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

                                ],
                              ),


                              Row(
                                children: <Widget>[
                                  new Icon(Icons.payment, size: 17,color: Colors.blue),
                                  Text(" "),
                                  Text(vacancy[index]['minsalary'].toString(),style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                                  Text(" - "),
                                  Text(vacancy[index]['maxsalary'].toString()+" ₹",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400, fontFamily: 'design.graffiti.comicsansms'),),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Icon(Icons.date_range, size: 17,color: Colors.blue),
                                  Text(" "),
                                  Text(vacancy[index]['uploded_date'].toString(),style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Icon(Icons.location_on, size: 17,color: Colors.blue),
                                  Text(" "),
                                  Text(vacancy[index]['city'],style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),

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
                                  Text(' Apply By '+vacancy[index]['lastdate'].toString(),style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w400,fontFamily: 'design.graffiti.comicsansms'),),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                  ),
                );
              }
          ):Container(
            child:Center(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("No Jobs"),
                ],
              ),
            ),
          ),
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
     ),
    );
  }
}