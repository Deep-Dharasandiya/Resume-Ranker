import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_app2/main.dart';
import 'package:phone_number/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'SizeRatio.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:phone_number/phone_number.dart';
Future<bool> networkcheck(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
    aleart(context,"This Device Not Connected To Internet...");
    return Future<bool>.value(false);
  }
  else {
    return Future<bool>.value(true);
  }
}

aleart(BuildContext context,String message) async {
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
aleartdetailsrequired(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text("All Details Required"),
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
Future<dynamic> exitaleart(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Aleart'),
          content: Text('Do you want to Exit'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Yes'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            new FlatButton(
              child: new Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
Widget text(BuildContext context, String label,Color clr,double size,FontWeight weight) {
  return Text(label,
      overflow: TextOverflow.ellipsis,
      style:TextStyle(
      fontSize: size,
      color: clr,
      fontWeight: weight,
      fontFamily: "design.graffiti.comicsansms",
      letterSpacing: 0));
}
Widget text2(BuildContext context, String label,Color clr,double size,FontWeight weight) {
  return Text(label,
      style:TextStyle(
          fontSize: size,
          color: clr,
          fontWeight: weight,
          fontFamily: "design.graffiti.comicsansms",
          letterSpacing: 0));
}
Widget textField(BuildContext context, String label, TextInputType inputType,bool flag, TextEditingController data) {
  return Padding(
    padding: EdgeInsets.only(bottom: width*0.04),
    child: TextField(
      controller:data,
      obscureText: flag,
      keyboardType: inputType,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          hintText: label,
          labelStyle: TextStyle(fontSize: width*0.05,fontFamily: 'design.graffiti.comicsansms', color: Colors.black),
          ),
    ),
  );
}
Widget btn(BuildContext context, String label,double s,double h,double w, Function fn) {
  return InkWell(
      onTap: fn,
      child:  Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
        Colors.blue,
        Colors.deepPurple
        ]
        ),
        borderRadius: BorderRadius.circular(width*0.02),
        boxShadow: [
        BoxShadow(
        color: Color(0xFF6078ea).withOpacity(0.3),
        offset: Offset(0.0,width*0.02),
        blurRadius: width*0.02
        )
        ]),

        child: Material(
        color: Colors.transparent,
          child: Center(
              child: text(context,label,Colors.white,s,FontWeight.normal),
           ),
        ),
      ),
  );
}
Widget simplebtn(BuildContext context, String label,double s,double h,double w, Function fn) {
  return InkWell(
    onTap: fn,
    child:  Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.lightBlueAccent
              ]
          ),
          borderRadius: BorderRadius.circular(width*0.02),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF6078ea).withOpacity(0.3),
                offset: Offset(0.0,width*0.02),
                blurRadius: width*0.02
            )
          ]),

      child: Material(
        color: Colors.transparent,
        child: Center(
          child: text(context,label,Colors.white,s,FontWeight.normal),
        ),
      ),
    ),
  );
}
Widget horizontalline(BuildContext context,double w,Color clr) {
  return Container(
      width: w,
      height: 1.0,
      color: clr
  );
}
Widget loginpagesignupoption(BuildContext context,String lable,Function fn) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,

    children: <Widget>[
      text(context,lable,Colors.grey,width*0.04,FontWeight.normal),
      FlatButton(
        padding:  EdgeInsets.all(width*0.03),
        textColor: Colors.blue,
        onPressed: fn,
        child: text(context,"Create Account",Colors.blue,width*0.04,FontWeight.normal),
      ),

    ],
  );
}
Widget progressindicator(BuildContext context) {
  return  Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: width*0.05,
          ),
          text(context,"Please Wait..",Colors.blue,width*0.05,FontWeight.normal),
        ],
      ),
    ),
  );
}
bool emailvalidaor(String email){
  return  EmailValidator.validate(email);
}
bool phonevalidaor(String phone) {
  print(phone.length);
  if(phone.length==10){
    int flag=0;
    for(int i=0;i<10;i++){
      if(i==0){
        if( phone[i]=='1' || phone[i]=='2'||phone[i]=='3'||phone[i]=='4'||phone[i]=='5'||phone[i]=='6'||
            phone[i]=='7'||phone[i]=='8'||phone[i]=='9'){
          flag=flag+1;
        }
      }else{
        if(phone[i]=='0' || phone[i]=='1' || phone[i]=='2'||phone[i]=='3'||phone[i]=='4'||phone[i]=='5'||phone[i]=='6'||
          phone[i]=='7'||phone[i]=='8'||phone[i]=='9'){
        flag=flag+1;
      }
      }
    }
    if(flag==10){
      return true;
    }else{
      return false;
    }
  }else{
    return false;
  }
}
bool pinvalidetor(String phone) {
  print(phone.length);
  if(phone.length==6){
    int flag=0;
    for(int i=0;i<6;i++){
      if(i==0){
        if( phone[i]=='1' || phone[i]=='2'||phone[i]=='3'||phone[i]=='4'||phone[i]=='5'||phone[i]=='6'||
            phone[i]=='7'||phone[i]=='8'||phone[i]=='9'){
          flag=flag+1;
        }
      }else{
        if(phone[i]=='0' || phone[i]=='1' || phone[i]=='2'||phone[i]=='3'||phone[i]=='4'||phone[i]=='5'||phone[i]=='6'||
            phone[i]=='7'||phone[i]=='8'||phone[i]=='9'){
          flag=flag+1;
        }
      }
    }
    if(flag==6){
      return true;
    }else{
      return false;
    }
  }else{
    return false;
  }
}
bool percentagevalidator(double per,String mode) {
  if(mode=='100'){
    if(per<=100){
      return true;
    }else{
      return false;
    }
  }else{
    if(per<=10){
      return true;
    }else{
      return false;
    }
  }
}
bool monthvalidator(String start,String end,bool complete) {
  if(complete==true){
    var startsplit=start.split("-");
    var endsplit=end.split("-");
    if(double.parse(endsplit[0])>=double.parse(startsplit[0])){
      if(double.parse(endsplit[0])==double.parse(startsplit[0])) {
        if (double.parse(endsplit[1]) > double.parse(startsplit[1])) {
          return true;
        } else {
          return false;
        }
        }else{
        return true;
      }
      }
     else{
      return false;
    }
  }else{
    return true;
  }

}


Function setimage;
chooseImage() async{
  Future<dynamic> file;
  String base64Image;
  String path='';
  file = ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20,);
  var temp=(await file).toString();
  path=temp.substring(7,temp.length-1);
  var nobytes =  File(path).readAsBytesSync().lengthInBytes;
  var bytes =  File(path).readAsBytesSync();
  if((nobytes/1024)<=100){
    base64Image = base64Encode(bytes);
    setimage(path,base64Image,true,'');
  }else{
    setimage(path,base64Image,false,'Select less than 100kb Icon');
  }
}
Widget takeimage(BuildContext context, Function fn) {
  setimage=fn;
  return  Container(
    child: Center(
      child: Padding(
        padding:  EdgeInsets.all(width*0.05),
        child:simplebtn(context,"Select Image",width*0.04,height*0.07,width*0.30,chooseImage),
      ),
    ),
  );
}
Widget homepagecard(BuildContext context, String name,Color clr,Color clr2,IconData i) {
  return  Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(width: width*0.005, color: Colors.blue),
      borderRadius: BorderRadius.circular(width*0.02),
    ),
    padding: EdgeInsets.all(width*0.03),
    child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: height*0.02),
            Icon(
              i,
              size: width*0.18,
              color: Colors.blue,
            ),
            SizedBox(height: height*0.02),
            text2(context,name,Colors.blue,width*0.05,FontWeight.normal),
          ],
        )),
  );
}
Future<void> logout(BuildContext context) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.remove('auth');
   prefs.remove('role');
   prefs.remove('email');
   prefs.remove('details');
   Navigator.push(context, MaterialPageRoute(builder: (context){
     return Loginpage();
   }));
}
Future<bool> applyforjob(BuildContext context,String email,String coemail,String post,String score) async {
    var body={
      "A":email,
      "B": coemail,
      "C": post,
      "D":score,
    };
    var res = await api(context, "insert_apply_for_job.php", body);
    if(res==1){
      return Future<bool>.value(true);
    }else{
      aleart(context,'Server Did Not Rsponce Try again Later');
      return Future<bool>.value(false);
    }
}
/*Widget dropdownbtn(BuildContext context, List l,Function fn) {
  var selected;
  return  new DropdownButton(
    hint: new Text('Select Your Program'),
    items: l.map((item){
      return new DropdownMenuItem(
        child:new Text(item),
        value: item,
      );
    }).toList(),
    onChanged: (newVal){
      selected=newVal;
      fn(newVal);
    },
    value: selected,
  );
}*/
void year(BuildContext context)async{
  DateTime newDateTime = await showRoundedDatePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 10),
    lastDate: DateTime(DateTime.now().year + 10),
    initialDatePickerMode: DatePickerMode.year,

    theme: ThemeData(primarySwatch: Colors.blue),
  );
}