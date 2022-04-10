import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'Applicant/ApplicantSignUp.dart';
import 'ForGotPassword.dart';
import 'Recruiter/RecruiterSignUp.dart';
import 'Applicant/ApplicantHome.dart';
import 'Recruiter/RecruiterHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Component/utils.dart';
import 'Component/SizeRatio.dart';
import 'Component/api.dart';
void main()  async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,

  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status=prefs.getBool('auth');
  if(status==true ) {
    String role=prefs.getString('role');
    if(role=='applicant'){
      runApp(MaterialApp( debugShowCheckedModeBanner:false,home:ApplicantHome() ));
    }else{
      runApp(MaterialApp(debugShowCheckedModeBanner:false,home:RecruiterHome() ));
    }
  }
  else{
    runApp(MaterialApp(debugShowCheckedModeBanner:false,home:Loginpage() ));
  }
}

class Loginpage extends StatefulWidget {
  @override
  _Loginpage createState() => new _Loginpage();
}
class _Loginpage extends State<Loginpage>{
  bool loading=false;
  TextEditingController email =TextEditingController();
  String get uemail => email.text;

  TextEditingController password =TextEditingController();
  String get upassword => password.text;


  void onapplicantsignup(){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ApplicanSignUp();
        }));
  }
  void onreqruitersignup(){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecruiterSignUp();
    }));
  }

  void onloginhandle() async {
    if(uemail=="" || upassword=="")
    {
      aleartdetailsrequired(context);
    }
    else
    {
      setState(() {
        loading=true;
      });
      var data={
        "A": uemail,
        "B": upassword,
      };
      var res=await api(context,"login.php",data);

      if(res==0){
        aleart(context,"Username and Password Incorrect..");
      }
      else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs?.setBool("auth", true);
        prefs?.setString("email", res[0]['email']);
        prefs?.setString("role", res[0]['role']);
        prefs?.setString("details", res.toString());
        if(res[0]['role']=='applicant'){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ApplicantHome();
          }));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return RecruiterHome();
          }));
        }
        setState(() {
          loading=false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        exitaleart(context);
        return false;
      },
      child:Scaffold(
            body: Center(
              child: loading==false?Container(
                 child: Stack(
                   fit:  StackFit.expand,
                   children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Image.asset(
                                'assets/resume01.jpeg',
                                height: height*0.4,
                                width:width,
                                fit: BoxFit.cover
                            )
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding:  EdgeInsets.fromLTRB(width*0.05, height*0.30, width*0.05, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: height*0.34,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(width*0.03),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0,width*0.03),
                                        blurRadius: width*0.03),
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0,-width*0.01),
                                        blurRadius: width*0.03),
                                  ]),
                              child: Padding(
                                padding:  EdgeInsets.all(width*0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    text(context,'Login',Colors.blue,width*0.08,FontWeight.normal),
                                    SizedBox(height: width*0.03,),
                                    textField(context,'Username or Email',TextInputType.emailAddress,false,email),
                                    textField(context,'Password',TextInputType.text,true,password),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: (){
                                          /*  Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return ForGotPassword ();
                                            }));*/
                                          },
                                            child: text(context,"Forgot Password",Colors.blue,width*0.04,FontWeight.normal),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height*0.05),
                            btn(context,"Login",width*0.06,height*0.07,width*0.30,onloginhandle),
                            SizedBox(height: height*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                horizontalline(context,width*0.03,Colors.black12),
                                text(context,"Sign Up",Colors.black,width*0.05,FontWeight.normal),
                                horizontalline(context,width*0.03,Colors.black12),
                              ],
                            ),
                            loginpagesignupoption(context,"Create an applicant account?",onapplicantsignup),
                            loginpagesignupoption(context,"Create a company account?",onreqruitersignup),
                          ],
                        ),
                      ),
                    ),
                 ],
              )
            ): progressindicator(context),
      ),
     ),
    );
  }
}