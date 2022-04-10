import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class SignupRecruiterful extends StatefulWidget {

  @override
  _SignupRecruiter createState() => new _SignupRecruiter();
}

class  _SignupRecruiter extends State<SignupRecruiterful >{
  bool loading=false;
  TextEditingController name =TextEditingController();
  String get uname => name.text;

  TextEditingController email =TextEditingController();
  String get uemail => email.text;

  TextEditingController password =TextEditingController();
  String get upassword => password.text;

  TextEditingController cono =TextEditingController();
  String get ucono => cono.text;

  TextEditingController repassword =TextEditingController();
  String get urepassword => repassword.text;

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

  TextEditingController contain =TextEditingController();
  String get contain2 => contain.text;

  TextEditingController other =TextEditingController();
  String get other2 => other.text;

  TextEditingController regi =TextEditingController();
  String get regi2 => regi.text;

  Future<File> file;
  String base64Image;
  File tmpFile;

  void InsertRecruiterData()async{
    final response = await http.post("http://resumeranker.hopto.org/insert_signup_recruiter.php",
        body: {
          "A": uname,
          "B":uemail,
          "C": upassword,
          "D": ucono,
          "E": ladd2,
          "F": city2,
          "G": dis2,
          "H": ta2,
          "I": pin2,
          "J": contain2,
          "K": other2,
          "L": base64Image,
          "M": regi2,
        }
    );
    var respbody = json.decode(response.body);
    print(respbody);
    if(respbody == 1)
    {
      setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Loginpage();
      }));
    }
    else if(respbody==3)
    {
      setState(() {
        loading = false;
      });
      Show_Aleart(context, "Register Number Not Valid...");
    }
    else
    {
      setState(() {
        loading = false;
      });
      Show_Aleart(context, "Please Enter Correct Details...");
    }
  }

  chooseImage() {
    setState(() {file = ImagePicker.pickImage(source: ImageSource.gallery);});
  }



  void networkcheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      Show_Aleart(context,"You Are Not Connected To Internet...");
    }
    else {
      setState(() {
        loading=true;
      });
      InsertRecruiterData();
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double hight = MediaQuery. of(context). size. height;
    double ratio=hight/width;
    return  WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return  Loginpage();
        }));
        return false;
      },
      child:MaterialApp(
        debugShowCheckedModeBanner:false,
        home:Scaffold(
          body:Center(
            child:Container(
                constraints: BoxConstraints.expand(),
                height: hight,
                //width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: new AssetImage('assets/resume01.jpeg'),
                        fit: BoxFit.cover)
                ),
                padding: EdgeInsets.only(top: ratio*35, left: ratio , right: ratio),
                child:SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.fromLTRB(5,5,5,0),
                    child:Card(
                      margin: EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child:Container(
                        padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                        child:Column(
                          children: <Widget>[
                            Text("SignUp",style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontFamily: 'design.graffiti.comicsansms'),),

                            TextField(
                              controller:name,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Company Name:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  // hintText: 'EMAIL',
                                  // hintStyle: ,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller:regi,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Company Registration Number:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller : email,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Company Email:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller : password,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Password: ',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                              obscureText: true,
                            ),
                            TextField(
                              controller: repassword,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Re-password:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                              obscureText: true,
                            ),
                            TextField(
                              controller : cono,
                              enabled: loading==true?false:true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Company Contact Number:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller:contain,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Compny Contain:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller:ladd,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Local Address:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller:city,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'City:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),

                            ),
                            TextField(
                              controller:dis,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'District:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),

                            ),
                            TextField(
                              controller:ta,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Sub District:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                            ),
                            TextField(
                              controller:pin,
                              enabled: loading==true?false:true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Pin Code:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),

                            ),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              controller: other,
                              enabled: loading==true?false:true,
                              decoration: InputDecoration(
                                  labelText: 'Enter your details:',
                                  labelStyle: TextStyle(
                                      fontFamily: 'design.graffiti.comicsansms',
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue))),
                              maxLines: null,
                            ),
                            OutlineButton(
                              onPressed: chooseImage,
                              child: Text('Chooss Icon'),
                            ),

                            loading==true?Container(
                              padding: new EdgeInsets.fromLTRB(5,5,5,5),
                              child: Column(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Text(""),
                                  Text("Please Wait.."),
                                ],
                              ),
                            ):Container(),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)
                              ),
                              onPressed:(){
                                if(upassword==urepassword) {
                                  if (uname == "" ||regi2==""|| uemail == "" || upassword == "" || urepassword == "" || ucono == "" || ladd2 == "" || city2 == "" || dis2 == "" || ta2 == "" || pin2 == "" || contain2 == "" || other2 == "" || base64Image==null) {
                                    Show_Aleart(context, "All Data Are Required...");
                                  }
                                  else{
                                    networkcheck();
                                  }
                                }
                                else{
                                  Show_Aleart(context, "Please Enter Confirmed Password...");
                                }
                              },
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child:Center(
                                child: Text("Signup",style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'design.graffiti.comicsansms'),),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }
}

