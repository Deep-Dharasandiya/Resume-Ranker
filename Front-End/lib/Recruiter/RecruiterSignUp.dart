import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Component/utils.dart';
import '../Component/SizeRatio.dart';
import '../Component/api.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
class RecruiterSignUp extends StatefulWidget {

  @override
  _RecruiterSignUp createState() => new _RecruiterSignUp();
}

class  _RecruiterSignUp extends State<RecruiterSignUp >{
  bool loading=false,screenflag=false;
  int verificationcode;
  int enteredcode;
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
  Future<dynamic> file;
  String base64Image='';
  String path='';
  bool imagevalid=false;

  void setimage(String p,String base64,bool flag,String msg){
    if(flag==true){
      print(path);
      setState(() {
        path=p;
        base64Image=base64;
        imagevalid=true;
      });
    }
    else{
      aleart(context,msg);
    }
  }
  void verify() async {
    if(upassword==urepassword) {
      if (uname == "" ||regi2==""|| uemail == "" || upassword == "" || urepassword == "" || ucono == "" || ladd2 == "" ||
          city2 == "" || dis2 == "" || ta2 == "" || pin2 == "" || contain2 == "" || other2 == "" || base64Image==null || imagevalid==false) {
        aleartdetailsrequired(context);
      }else{
        if(emailvalidaor(uemail)==true) {
          if(phonevalidaor(ucono)) {
            setState(() {
              loading = true;
            });
            var body = {
              "A": uemail,
            };
            var res = await api(context, "send_verification_code.php", body);
            print(res);
            setState(() {
              verificationcode=res;
              screenflag=true;
              loading = false;
            });

          }
          else{
            aleart(context,"Enter Valid Contect Number..");
          }
        }
        else{
          aleart(context,"Enter Valid Email Address..");
        }
      }
    }
    else{
      aleart(context,"Enter Same Password..");
    }
  }
  void onsignuphandle2() async{
    setState(() {
      loading = true;
    });
    var body = {
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
    };
    var res = await api(context, "insert_signup_recruiter.php", body);
    setState(() {
      loading = false;
    });
    if(res==1){
      Navigator.pop(context);
    }else{
      aleart(context,res);
      setState(() {
        screenflag=false;
      });
    }
  }
  void onsignuphandle() async{
    if(upassword==urepassword) {
      if (uname == "" ||regi2==""|| uemail == "" || upassword == "" || urepassword == "" || ucono == "" || ladd2 == "" ||
          city2 == "" || dis2 == "" || ta2 == "" || pin2 == "" || contain2 == "" || other2 == "" || base64Image==null || imagevalid==false) {
        aleartdetailsrequired(context);
      }else{
        if(emailvalidaor(uemail)==true) {
          if(phonevalidaor(ucono)) {
            setState(() {
              loading = true;
            });
            var body = {
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
            };
            var res = await api(context, "insert_signup_recruiter.php", body);
            setState(() {
              loading = false;
            });
            if(res==1){
              Navigator.pop(context);
            }else{
              aleart(context,res);
            }

          }
          else{
            aleart(context,"Enter Valid Contect Number..");
          }
        }
        else{
          aleart(context,"Enter Valid Email Address..");
        }
      }
    }
    else{
      aleart(context,"Enter Same Password..");
    }

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(screenflag==false){
            return true;
          }else{
            setState(() {
              screenflag=false;
            });
            return false;
          }
        },
    child: MaterialApp(
      debugShowCheckedModeBanner:false,
      home:Scaffold(
        appBar: AppBar(
          title: Text('SignUp'),
        ),
        body:loading==false?Center(
          child: screenflag==false?Padding(
            padding:  EdgeInsets.all(width*0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  textField(context,'Name:',TextInputType.text,false,name),
                  textField(context,'Company Registration Number:',TextInputType.text,false,regi),
                  textField(context,'Email:',TextInputType.emailAddress,false,email),
                  textField(context,'Password:',TextInputType.text,true,password),
                  textField(context,'Re-Password:',TextInputType.text,true,repassword),
                  textField(context,'Contact Number:',TextInputType.number,false,cono),
                  textField(context,'Compny Contain:',TextInputType.multiline,false,contain),
                  textField(context,'Local Address:',TextInputType.text,false,ladd),
                  textField(context,'City:',TextInputType.text,false,city),
                  textField(context,'District:',TextInputType.text,false,dis),
                  textField(context,'Sub District:',TextInputType.text,false,ta),
                  textField(context,'Pin Code:',TextInputType.number,false,pin),
                  textField(context,'Other Details:',TextInputType.multiline,false,other),
                  SizedBox(height: height*0.03),
                  Row(
                    children: [
                      text(context,"Company Logo:",Colors.black,width*0.05,FontWeight.normal),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Expanded(child: takeimage(context,setimage)),
                      SizedBox(width: width*0.05),
                      Expanded(
                        child: Container(
                          height: 100,
                          width: 100,

                          child:imagevalid==false?Icon(Icons.image, color: Colors.black,size: width*0.10,):
                          Image.file(File(path), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.03),
                  btn(context,"SignUp",width*0.06,height*0.07,width,verify),
                  SizedBox(height: height*0.03),
                ],
              ),
            ),
          ):Padding(
            padding:  EdgeInsets.all(width*0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child:  Text("Verify Your Email:",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  ),
                  Container(
                    height: height*0.01,
                  ),
                  OTPTextField(
                    length: 6,
                    width: (width- 3*(width/20)),
                    //fieldWidth:50,
                    style: TextStyle(
                        fontSize: 17
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      setState(() {
                        enteredcode=int.parse(pin);
                      });
                      print("Completed: " + pin);
                    },
                  ),

                  Container(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child:  Text("Enter your OTP which is already sent on "+uemail,style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),),
                  ),
                  Container(
                    height: 20,
                  ),
                  btn(context,"Verify & SignUp",width*0.06,height*0.07,width,onsignuphandle2),
                ],
              ),
            ),
          ),
        ):progressindicator(context),
      ),
    ),
    );
  }
}