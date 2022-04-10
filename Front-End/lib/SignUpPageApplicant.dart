import 'package:flutter/material.dart';
import 'main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class SignupApplicantful extends StatefulWidget {

  @override
  _SignupApplicant createState() => new _SignupApplicant();
}

class  _SignupApplicant extends State<SignupApplicantful >{
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

  void InsertApplicantData()async{
    final response = await http.post("http://resumeranker.hopto.org/insert_signup_applicant.php",
        body: {
          "A": uname,
          "B": uemail,
          "C": upassword,
          "D": ucono,
        }
    );
    var respbody = json.decode(response.body);
    print(respbody);
    if(respbody == 1)
    {
      setState(() {
        loading= false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Loginpage();
      }));
    }
    else
    {
      setState(() {
        loading = false;
      });
      Show_Aleart(context, "Detail Not Valid...");
    }
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
      InsertApplicantData();
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
                                     labelText: 'Name:',
                                     labelStyle: TextStyle(fontFamily: 'design.graffiti.comicsansms', color: Colors.black),
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: Colors.blue))),
                               ),
                               TextField(
                                 controller : email,
                                 enabled: loading==true?false:true,
                                 decoration: InputDecoration(
                                     labelText: 'Email:',
                                     labelStyle: TextStyle(
                                         fontFamily: 'design.graffiti.comicsansms',
                                         color: Colors.black),
                                     // hintText: 'EMAIL',
                                     // hintStyle: ,
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
                                     labelText: 'Re-Password:',
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
                                     labelText: 'Contact Number:',
                                     labelStyle: TextStyle(
                                         fontFamily: 'design.graffiti.comicsansms',
                                         color: Colors.black),
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: Colors.blue))),
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
                                          if (uname == "" || uemail == "" || upassword == "" || ucono == "" || urepassword == "") {
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

