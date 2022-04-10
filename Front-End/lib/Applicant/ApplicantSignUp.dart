import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Component/utils.dart';
import '../Component/SizeRatio.dart';
import '../Component/api.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
class ApplicanSignUp extends StatefulWidget {

  @override
  _ApplicanSignUp createState() => new _ApplicanSignUp();
}

class  _ApplicanSignUp extends State<ApplicanSignUp >{
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

  void verify() async {
    if (upassword == urepassword) {
      if (uname == "" || uemail == "" || upassword == "" || ucono == "" ||
          urepassword == "") {
        aleartdetailsrequired(context);
      } else {
        if (emailvalidaor(uemail) == true) {
          if (phonevalidaor(ucono)) {
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
          else {
            aleart(context, "Enter Valid Contect Number..");
          }
        }
        else {
          aleart(context, "Enter Valid Email Address..");
        }
      }
    }
  }
  void onsignuphandle2() async{
    if(verificationcode==verificationcode){
      setState(() {
        loading = true;
      });
      var body = {
        "A": uname,
        "B": uemail,
        "C": upassword,
        "D": ucono,
      };
      var res = await api(context, "insert_signup_applicant.php", body);
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
    }else{
      aleart(context, "Please Enter Valid Code");
    }

  }
  void onsignuphandle() async{
    if(upassword==urepassword) {
      if (uname == "" || uemail == "" || upassword == "" || ucono == "" ||
          urepassword == "") {
        aleartdetailsrequired(context);
      }else{
        if(emailvalidaor(uemail)==true) {
          if(phonevalidaor(ucono)) {
            setState(() {
              loading = true;
            });
            var body = {
              "A": uname,
              "B": uemail,
              "C": upassword,
              "D": ucono,
            };
            var res = await api(context, "insert_signup_applicant.php", body);
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
                    textField(context,'Email:',TextInputType.emailAddress,false,email),
                    textField(context,'Password:',TextInputType.text,true,password),
                    textField(context,'Re-Password:',TextInputType.text,true,repassword),
                    textField(context,'Contact Number:',TextInputType.number,false,cono),
                    SizedBox(height: height*0.05),
                    btn(context,"SignUp",width*0.06,height*0.07,width,verify),
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