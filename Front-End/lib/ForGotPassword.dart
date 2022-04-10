import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Component/utils.dart';
import '../Component/SizeRatio.dart';
import '../Component/api.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
class ForGotPassword extends StatefulWidget {

  @override
  _ForGotPassword createState() => new _ForGotPassword();
}

class  _ForGotPassword extends State<ForGotPassword >{
  bool loading=false,screenflag=false,screenflag2=false;
  int verificationcode;
  int enteredcode;

  TextEditingController email =TextEditingController();
  String get uemail => email.text;

  TextEditingController password =TextEditingController();
  String get upassword => password.text;

  TextEditingController repassword =TextEditingController();
  String get urepassword => repassword.text;


  void verify() async {
    if(verificationcode==enteredcode){
      setState(() {
        screenflag2=true;
      });
    }else{
      aleart(context, "Please Enter valid verification code");
    }
  }
  void changepassword() async{
    if(upassword==null || urepassword==null){
      aleartdetailsrequired(context);
    }else{
      if(upassword==urepassword){
        setState(() {
          loading = true;
        });
        var body = {
          "A": uemail,
          "B": upassword,
        };
        var res = await api(context, "forgotpassword.php", body);
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      }else{
        aleart(context, "Password must be same");
      }
    }
  }
  void onsubmit()async{
    if(uemail==null){
      aleart(context, "Please enter your email");
    }else{
      setState(() {
        loading = true;
      });
      var body = {
        "A": uemail,
      };
      var res = await api(context, "email_checker.php", body);
      setState(() {
        loading = false;
      });
      if(res==0){
       aleart(context, "Your email does not exist in database");
      }else{
        setState(() {
          verificationcode=res;
          screenflag=true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(screenflag==false){
          return true;
        }else if(screenflag==true && screenflag2==false){
          setState(() {
            screenflag=false;
          });
          return false;
        }else {
          setState(() {
            screenflag2=false;
          });
          return false;
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        home:Scaffold(
          appBar: AppBar(
            title: Text('Forgot Password'),
          ),
          body:loading==false?Center(
            child: screenflag==false?Padding(
              padding:  EdgeInsets.all(width*0.05),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    textField(context,'Email:',TextInputType.emailAddress,false,email),
                    SizedBox(height: height*0.05),
                    btn(context,"Submit",width*0.06,height*0.07,width,onsubmit),
                  ],
                ),
              ),
            ):Padding(
              padding:  EdgeInsets.all(width*0.05),
              child: screenflag2==false?SingleChildScrollView(
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
                    btn(context,"Submit",width*0.06,height*0.07,width,verify),
                  ],
                ),
              ):
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    textField(context,'New Password:',TextInputType.emailAddress,false,password),
                    SizedBox(height: height*0.05),
                    textField(context,'Confirm Password:',TextInputType.emailAddress,false,repassword),
                    SizedBox(height: height*0.05),
                    btn(context,"Change Password",width*0.06,height*0.07,width,changepassword),
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