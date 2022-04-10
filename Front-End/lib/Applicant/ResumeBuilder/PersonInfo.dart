
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phone_number/phone_number.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PersonInfo extends StatefulWidget {

  @override
  _PersonInfo createState() => new _PersonInfo();
}

class  _PersonInfo extends State<PersonInfo > {
  bool loading=true;
  String Email='';
  String selecteddob="yyyy-mm-dd";
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

  /*TextEditingController dob =TextEditingController(text: 'DD-MM-YYYY');
  String get dob2=> dob.text;*/

  TextEditingController self =TextEditingController();
  String get self2=> self.text;

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

  void initState() {
    super. initState();
    fetchpersondata();
  }



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
  void fetchpersondata() async{
    String springFieldUSASimple = '+14175555470';
    PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
    print(phoneNumber);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email=prefs.getString('email');
    setState(() {
      Email=email;
    });
    var body= {
      "A": Email,
    };
    var res = await api(context, "get_resume_person_info.php", body);
    if(res.length!=0){
      fname =TextEditingController(text: res[0]['fname']);
      mname =TextEditingController(text: res[0]['mname']);
      lname =TextEditingController(text: res[0]['lname']);
      this.email=TextEditingController(text: res[0]['resume_email']);
      cono=TextEditingController(text: res[0]['cono']);
      selecteddob=res[0]['dob'];
      self=TextEditingController(text: res[0]['aboutself']);
      ladd=TextEditingController(text: res[0]['ladd']);
      city=TextEditingController(text: res[0]['city']);
      dis=TextEditingController(text: res[0]['dis']);
      ta=TextEditingController(text: res[0]['ta']);
      pin=TextEditingController(text: res[0]['pin']);
      setState(() {
        base64Image=res[0]['profile_picture'];
        imagevalid=true;
      });
    }
    setState(() {
      loading=false;
    });
  }
  void onsavehandle()async{
    if(fname2==null || mname2==null || lname==null || email2==null || cono2==null || ladd2==null || city2==null ||
        dis2==null || ta2==null || pin2==null || base64Image==null || self2==null||selecteddob=='yyyy-mm-dd') {
     aleartdetailsrequired(context);
    }else{
      if(emailvalidaor(email2)==true) {
        if (phonevalidaor(cono2)==true) {
          if(pinvalidetor(pin2)==true){
            var body={
              "A":Email,
              "B":fname2,
              "C":mname2,
              "D":lname2,
              "E":email2,
              "F":cono2,
              "G":base64Image,
              "H":selecteddob,
              "I":self2,
              "J":ladd2,
              "K":city2,
              "L":dis2,
              "M":ta2,
              "N":pin2,
            };
            setState(() {
              loading = true;
            });
            var res = await api(context, "insert_resume_person_info.php", body);
            setState(() {
              loading = false;
            });
            if(res==1){
              Navigator.pop(context);
            }else{
              aleart(context,"Server Did Not Responce..");
            }
          }else{
            aleart(context,"Enter Valid Pin Number");
          }

        }else{
          aleart(context,"Enter Valid Phone Number");
        }
      }else{
        aleart(context,"Enter Valid Email Address");
      }

    }

  }
  void date()async{
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: DateTime(DateTime.now().year+1),
      initialDatePickerMode: DatePickerMode.day,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    setState(() {
      selecteddob= (newDateTime.day).toString()+"-"+(newDateTime.month).toString()+"-"+(newDateTime.year).toString();
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Personal Details'),
        ),
        body:loading==false?Center(
          child:SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(width*0.05),
              child: Column(
                children: [
                  textField(context,'First Name:',TextInputType.text,false,fname),
                  textField(context,'Middle Name:',TextInputType.text,false,mname),
                  textField(context,'Last Name:',TextInputType.text,false,lname),
                  textField(context,'Email:',TextInputType.emailAddress,false,email),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: TextField(
                    controller:cono,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contect Number:",
                      hintText: "Contect Number:",
                      labelStyle: TextStyle(fontSize: width*0.05,fontFamily: 'design.graffiti.comicsansms', color: Colors.black),
                    ),
                  ),
                ),
                  //textField(context,'Contect Number:',TextInputType.number,false,cono),
                  InkWell(
                    onTap: (){date();},
                    child:Column(
                      children: [
                        Align(alignment:Alignment.topLeft,child: text(context,"Birth Date:",Colors.black,width*0.05,FontWeight.normal)),
                        Container(
                          height: height*0.05,
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(width*0.01),
                            border:Border.all(color: Colors.black),
                          ),

                          margin:EdgeInsets.only(top:width*0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              text(context,selecteddob,Colors.black,width*0.05,FontWeight.normal),
                              new Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height*0.02),
                  //textField(context,'Date of Birth:',TextInputType.number,false,dob),
                  textField(context,'About Your Self:',TextInputType.multiline,false,self),
                  textField(context,'Local Address:',TextInputType.text,false,ladd),
                  textField(context,'City:',TextInputType.text,false,city),
                  textField(context,'District:',TextInputType.text,false,dis),
                  textField(context,'Sub District:',TextInputType.text,false,ta),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: TextField(
                      controller:pin,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pin Code:",
                        hintText: "Pin Code:",
                        labelStyle: TextStyle(fontSize: width*0.05,fontFamily: 'design.graffiti.comicsansms', color: Colors.black),
                      ),
                    ),
                  ),
                  //textField(context,'Pin Code:',TextInputType.number,false,),
                  SizedBox(height: height*0.03),
                  Row(
                    children: [
                      text(context,"Profile Picture:",Colors.black,width*0.05,FontWeight.normal),
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
                          Image.memory(base64.decode(base64Image), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.03),
                  btn(context,"Save",width*0.06,height*0.07,width,onsavehandle),
                  SizedBox(height: height*0.03),
                ],
              ),
            ),
          ),
        ):progressindicator(context),
      ),
    );
  }
}
