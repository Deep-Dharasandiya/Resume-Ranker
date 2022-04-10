import 'dart:convert';
import 'dart:ui';
import 'package:flutter_app2/Home.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class PersonInfo extends StatefulWidget {
  PersonInfo(this.email);
  String email;
  @override
  _PersonInfo createState() => _PersonInfo(email);
}

class _PersonInfo extends State<PersonInfo> {
  _PersonInfo(email);
  bool mainloader=true;
  List person=[];
  TextEditingController fname =TextEditingController();
  String get fname2 => fname.text;

  TextEditingController mname =TextEditingController();
  String get mname2 => mname.text;

  TextEditingController lname =TextEditingController();
  String get lname2=> lname.text;

  TextEditingController email =TextEditingController();
  String get email2 => email.text;

  TextEditingController cono =TextEditingController();
  String get cono2=> cono.text;

  TextEditingController ladd =TextEditingController();
  String get ladd2 => ladd.text;

  TextEditingController city =TextEditingController();
  String get city2 => city.text;

  TextEditingController dis =TextEditingController();
  String get dis2=> dis.text;

  TextEditingController ta =TextEditingController();
  String get ta2 => ta.text;

  TextEditingController pin =TextEditingController();
  String get pin2=> pin.text;

  TextEditingController aboutself =TextEditingController();
  String get aboutself2=> aboutself.text;

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

  String dob=" ";
  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != DateTime.now())
      setState(() {
        DateTime selectedDate = picked;
        dob=selectedDate.toString().split(" ")[0];
      });
  }

  String base64Imagebio;
  Future<File> filebio;
  File tmpFilebio;
  String fileNamebio=" ";
  chooseImagebio() {
    setState(() {filebio = ImagePicker.pickImage(source: ImageSource.gallery);});
  }

  Widget showImagebio() {
    return FutureBuilder<File>(
      future: filebio,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFilebio = snapshot.data;
          base64Imagebio = base64Encode(snapshot.data.readAsBytesSync());
          String filenamebio = tmpFilebio.path.split('/').last;
          var file = File(tmpFilebio.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            fileNamebio=filenamebio;
            return Text(fileNamebio, textAlign: TextAlign.center,);}
          else{
            base64Imagebio=null;
            file=null;
            tmpFilebio=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return  Text(fileNamebio, textAlign: TextAlign.center,);
        }},);
  }

  void insert_person_info() async {
      final response = await http.post(
          "http://resumeranker.hopto.org/insert_resume_person_info.php",
          body: {
            "A": widget.email,
            "B":fname2,
            "C":mname2,
            "D":lname2,
            "E":email2,
            "F":cono2,
            "G":base64Imagebio,
            "H":dob,
            "I":aboutself2,
            "J":ladd2,
            "K":city2,
            "L":dis2,
            "M":ta2,
            "N":pin2,
            "O":fileNamebio,
          }
      );
      if (response.statusCode == 200) {
        setState(() {
          mainloader=false;
        });
        if(json.decode(response.body)==1){
          Navigator.of(context).pop();
        }
      }
      else{
        setState(() {
          mainloader=false;
        });
       error();
      }
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

  void fetchpersoninfo() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_person_info.php",
        body: {
          "A": widget.email,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        person = json.decode(response.body);
      });
      setvalue();
    }
    else{
      error();
    }
  }

  void setvalue(){
    if(person.length!=0){
      fname =TextEditingController(text: person[0]['fname']);
      mname =TextEditingController(text: person[0]['mname']);
      lname =TextEditingController(text: person[0]['lname']);
      email =TextEditingController(text: person[0]['resume_email']);
      cono =TextEditingController(text: person[0]['cono']);
      ladd =TextEditingController(text: person[0]['ladd']);
      city =TextEditingController(text: person[0]['city']);
      dis =TextEditingController(text: person[0]['dis']);
      ta =TextEditingController(text: person[0]['ta']);
      pin =TextEditingController(text: person[0]['pin']);
      aboutself =TextEditingController(text: person[0]['aboutself']);
      base64Imagebio=person[0]['profile_picture'];
      fileNamebio=person[0]['profile_picture_name'];
      dob=person[0]['dob'];
    }
    setState(() {
      mainloader=false;
    });

  }

  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0)
      {
        fetchpersoninfo();
        t=t+1;
      }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Text("Person Info",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
      ),
      body:Center(
        child:SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Container(
                //padding: new EdgeInsets.fromLTRB(5,60,5,5),
               /* child:Card(
                  margin: EdgeInsets.all(5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,*/
                  child:mainloader==false?Container(
                    //padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                    child:  Column(
                      children: <Widget>[
                        //new
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                            child: Column(

                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Full Name:",style: new TextStyle(fontSize: 20.0,color: Colors.blue),),
                                  ],
                                ),
                                TextField(
                                  controller:fname,
                                  decoration: InputDecoration(
                                      labelText: 'First Name:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                         // fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),
                                TextField(
                                  controller:mname,
                                  decoration: InputDecoration(
                                      labelText: 'Middle Name:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),

                                ),
                                TextField(
                                  controller:lname,
                                  decoration: InputDecoration(
                                      labelText: 'Last name:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),

                                ),
                              ],
                            ),
                          ),
                        ),
                       Text(""),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Contact Info:",style: new TextStyle(fontSize: 20.0,color: Colors.blue),),
                                  ],
                                ),
                                TextField(
                                  controller:email,
                                  decoration: InputDecoration(
                                      labelText: 'Enter Your Email:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),
                                TextField(
                                  controller:cono,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'EnterYour Contact No:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),

                                ),
                              ]
                            ),
                          ),
                        ),
                        Text(""),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("About Your Self:",style: new TextStyle(fontSize: 20.0,color: Colors.blue),),
                                  ],
                                ),
                                RaisedButton(
                                  onPressed:(){
                                    chooseImagebio();
                                  },
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                  child:Center(
                                    child: Container(
                                      //padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.picture_in_picture,
                                            color: Colors.blue,
                                            size: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(" Profile Picture:",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                showImagebio(),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed:(){
                                    _selectDate(context);
                                  },
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                  child:Center(
                                    child: Container(
                                      //padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.blue,
                                            size: 15,
                                          ),
                                          Expanded(
                                            child: Stack(
                                              children: <Widget>[
                                                Text(" Birth Date :",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                Text("                      "+dob,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                TextField(
                                  controller:aboutself,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      labelText: 'Self Evaluation:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                         // fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),

                              ]
                            ),
                          ),
                        ),
                        Text(""),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Address:",style: new TextStyle(fontSize: 20.0,color: Colors.blue),),
                                  ],
                                ),
                                TextField(
                                  controller:ladd,
                                  decoration: InputDecoration(
                                      labelText: 'Local Address:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),

                                ),
                                TextField(
                                  controller:city,
                                  decoration: InputDecoration(
                                      labelText: 'City:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),

                                ),
                                TextField(
                                  controller:dis,
                                  decoration: InputDecoration(
                                      labelText: 'District:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),

                                ),
                                TextField(
                                  controller:ta,
                                  decoration: InputDecoration(
                                      labelText: 'Sub District:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                         // fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),
                                TextField(
                                  controller:pin,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Pin Code:',
                                      labelStyle: TextStyle(
                                          fontFamily: 'design.graffiti.comicsansms',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue))),
                                ),
                               ]
                            ),
                          ),
                        ),
                        Text(" "),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.deepPurpleAccent)
                          ),
                          onPressed:(){
                            print(cono2.length);
                            if(fname2=='' || mname2=='' || lname2=='' || email2=='' || cono2=='' ||fileNamebio==' ' || dob==" " || aboutself2=='' || ladd2=='' || city2=='' ||dis2=='' || ta2=='' || pin2=='' || cono2.length!=10 || pin2.length!=6){
                              Show_Aleart(context, "Please Enter All The Correct Data...");
                            }
                            else{
                              setState(() {
                                mainloader=true;
                              });
                              insert_person_info();
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
                        Text(" "),
                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}