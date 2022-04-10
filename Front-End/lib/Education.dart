import 'dart:convert';
import 'dart:ui';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'main.dart';

class Education extends StatefulWidget {
  Education(this.email);
  String email;
  @override
  _Education createState() => _Education(email);
}

class _Education extends State<Education> {
  _Education(email);
  bool Mainloader=true,Heigher_Secondray=false,Diploma=false,Graduation=false,PostGraduation=false,PHD=false;
  List Diplomacourses=[],Bechlorcourses=[],Mastercourses=[],eduacation=[];
  List collagenamedata=[],compnydata=[],skillnamedata=[],bachlerdata=[],postdata=[],masterdata=[];
  String Heigher_Secondray_Stream,Heigher_Secondray_Complited_Year=' ',Diploma_Complited_Year=' ',Graduation_Complited_Year=' ',PostGraduation_Complited_Year=' ',Heigher_Secondray_Board,Diploma_Course,Collage_Diploma,Collage_Graduation,Collage_PostGraduation,Collage_PHD,Graduation_Program,Graduation_Course,PostGraduation_Program,PostGraduation_Course;
  List passingyeardata= [{"year": '2030'},{"year": '2029'},{"year": '2028'},{"year": '2027'},{"year": '2026'},{"year": '2025'},{"year": '2024'},{"year": '2023'},{"year": '2022'},{"year": '2021'},{"year": '2020'},{"year": '2019'},{"year": '2018'},{"year": '2017'},{"year": '2016'},{"year": '2015'},{"year": '2014'},{"year": '2013'},{"year": '2012'},{"year": '2011'},{"year": '2010'},{"year": '2009'},{"year": '2008'},{"year": '2007'},{"year": '2006'},{"year": '2005'},{"year": '2004'},{"year": '2003'},{"year": '2002'},{"year": '2001'},{"year": '2000'}];
  List boarddata=[{"Board": 'GSEB'},{"Board": 'CBSC'}];
  List Stream=[{"stream": 'Science'},{"stream": 'Commerce'}];
  String  hse_stream,hse_board,hse_py,hse_pr,hse_result,diploma_course,diploma_collage,diploma_py,diploma_pr,diploma_result,graduation_program,graduation_course,graduation_collage;
  String graduation_py,graduation_pr,graduation_result,postgraduation_program,postgraduation_course,postgraduation_collage,postgraduation_py,postgraduation_pr,postgraduation_result;
  String phd_sub,phd_aboutsub,phd_collage,phd_result;
  String DOB;
  int doby,dobm;

  String Result_Higher_Secondary,Result_Diploma,Result_Graduation,Result_PostGraduation,Result_PHD;
  Future<File> File_Result_Higher_Secondary,File_Result_Diploma,File_Result_Graduation,File_Result_PostGraduation,File_Result_PHD;
  File tmpFile_Result_Higher_Secondary,tmpFile_Result_Diploma,tmpFile_Result_Graduation,tmpFile_Result_PostGraduation,tmpFile_Result_PHD;
  String filenamehse=" ",filenamediploma=" ",filenamegra=" ",filenamepostgra=" ",filenamephd=" ";

  TextEditingController per12 =TextEditingController();
  String get per122 => per12.text;

  TextEditingController cpi_diploma =TextEditingController();
  String get cpi_diploma2 => cpi_diploma.text;

  TextEditingController cpi_graduation =TextEditingController();
  String get cpi_graduation2 => cpi_graduation.text;

  TextEditingController cpi_postgraduation =TextEditingController();
  String get cpi_postgraduation2 => cpi_postgraduation.text;

  TextEditingController phd_subject =TextEditingController();
  String get phd_subject2 => phd_subject.text;

  TextEditingController phd_aboutsubject =TextEditingController();
  String get phd_aboutsubject2 => phd_aboutsubject.text;

  /*void Year_Selection()async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != Heigher_Secondray_Complited_Year)
      setState(() {
        Heigher_Secondray_Complited_Year = picked;
      });
  }*/

  void fetchData() async {
    /* final response9 = await http.post(
        "http://resumeranker.hopto.org/get_dob.php",
        body: {
          "A": widget.email,
        }
    );
    if (response9.statusCode == 200) {
      setState(() {
        setState(() {
          DOB = json.decode(response9.body);
        });
      });
      if(DOB=='0'){
        Navigator.of(context).pop();
        Show_Aleart(context, 'First Edit Person Info');
      }else{
        var a=DOB.split('-');
         doby=int.parse(a[0]);
         dobm=int.parse(a[1]);*/
    final response = await http.get(
        'http://resumeranker.hopto.org/getcollagename.php');
    if (response.statusCode == 200) {
      setState(() {
        collagenamedata = json.decode(response.body);
      });
      final response3 = await http.get(
          'http://resumeranker.hopto.org/getcompnyname.php');
      if (response3.statusCode == 200) {
        setState(() {
          compnydata = json.decode(response3.body);
        });
        final response4 = await http.get(
            'http://resumeranker.hopto.org/skill_getdata.php');
        if (response4.statusCode == 200) {
          setState(() {
            skillnamedata = json.decode(response4.body);
          });
          final response5 = await http.get(
              'http://resumeranker.hopto.org/getpostname.php');
          if (response5.statusCode == 200) {
            setState(() {
              postdata = json.decode(response5.body);
            });
            final response6 = await http.get(
                'http://resumeranker.hopto.org/getbachelordata.php');
            if (response6.statusCode == 200) {
              setState(() {
                bachlerdata = json.decode(response6.body);
              });
              final response7 = await http.get(
                  'http://resumeranker.hopto.org/masterdata.php');
              if (response7.statusCode == 200) {
                setState(() {
                  masterdata = json.decode(response7.body);
                });
                final response8 = await http.post(
                    "http://resumeranker.hopto.org/getCourses.php",
                    body: {
                      "A": "Diploma",
                    }
                );
                if (response8.statusCode == 200) {
                  setState(() {
                    Diplomacourses = json.decode(response8.body);
                  });
                  fetcheduacation();
                }
                else{
                  error();
                }
              }
              else{
                error();
              }
            }
            else{
              error();
            }
          }
          else {
            error();
          }
        }
        else {
          error();
        }
      }
      else {
        error();
      }
    }
    else{
      error();
    }
    /* }
    }
    else{
      error();
    }*/

  }

  void BechlorCourses(String a) async {
    final response = await http.post(
        "http://resumeranker.hopto.org/getCourses.php",
        body: {
          "A": a.toString(),
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        Bechlorcourses = json.decode(response.body);
      });
    }
    else{
      error();
    }
  }

  void MasterCourses(String a) async {
    final response = await http.post(
        "http://resumeranker.hopto.org/getCourses.php",
        body: {
          "A": a,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        Mastercourses = json.decode(response.body);
      });
    }
    else{
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
                    return Home(widget.email,);
                  }));
                },
              )
            ],
          );
        });
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

  void assignval(){
    if(Heigher_Secondray==true){
      hse_stream=Heigher_Secondray_Stream;
      hse_board = Heigher_Secondray_Board;
      hse_py = Heigher_Secondray_Complited_Year;
      hse_pr = per122;
      hse_result=Result_Higher_Secondary;
    }else{
      hse_stream ='abc';
      hse_board = "abc";
      hse_py ="0";
      hse_pr = "0";
      hse_result="abc";
    }
    if(Diploma==true){
      diploma_course=Diploma_Course;
      diploma_collage=Collage_Diploma;
      diploma_py=Diploma_Complited_Year;
      diploma_pr=cpi_diploma2;
      diploma_result=Result_Diploma;
    }else{
      diploma_course="abc";
      diploma_collage="abc";
      diploma_py="0";
      diploma_pr="0";
      diploma_result="abc";
    }
    if(Graduation==true){
      graduation_program=Graduation_Program;
      graduation_course=Graduation_Course;
      graduation_collage=Collage_Graduation;
      graduation_py=Graduation_Complited_Year;
      graduation_pr=cpi_graduation2;
      graduation_result=Result_Graduation;
    }else{
      graduation_program="abc";
      graduation_course="abc";
      graduation_collage="abc";
      graduation_py="0";
      graduation_pr="0";
      graduation_result="abc";
    }
    if(PostGraduation==true){
      postgraduation_program=PostGraduation_Program;
      postgraduation_course=PostGraduation_Course;
      postgraduation_collage=Collage_PostGraduation;
      postgraduation_py=PostGraduation_Complited_Year;
      postgraduation_pr=cpi_postgraduation2;
      postgraduation_result=Result_PostGraduation;
    }else{
      postgraduation_program="abc";
      postgraduation_course="abc";
      postgraduation_collage="abc";
      postgraduation_py="0";
      postgraduation_pr="0";
      postgraduation_result="abc";
    }
    if(PHD==true){
      phd_sub=phd_subject2;
      phd_aboutsub=phd_aboutsubject2;
      phd_collage=Collage_PHD;
      phd_result=Result_PHD;
    }else{
      phd_sub="abc";
      phd_aboutsub="abc";
      phd_collage="abc";
      phd_result="abc";
    }
    insert_education();
  }

  void insert_education() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/insert_resume_eduacation.php",
        body: {
          "A": widget.email,
          "B":Heigher_Secondray.toString(),
          "C":hse_board,
          "D":hse_py,
          "E":hse_pr,
          "F":hse_result,
          "G":Diploma.toString(),
          "H":diploma_course,
          "I":diploma_collage,
          "J":diploma_py,
          "K":diploma_pr,
          "L":diploma_result,
          "M":Graduation.toString(),
          "N":graduation_program,
          "O":graduation_course,
          "P":graduation_collage,
          "Q":graduation_py,
          "R":graduation_pr,
          "S":graduation_result,
          "T":PostGraduation.toString(),
          "U":postgraduation_program,
          "V":postgraduation_course,
          "W":postgraduation_collage,
          "X":postgraduation_py,
          "Y":postgraduation_pr,
          "Z":postgraduation_result,
          "AA":PHD.toString(),
          "AB":phd_sub,
          "AC":phd_aboutsub,
          "AD":phd_collage,
          "AE":phd_result,
          "AF":filenamehse,
          "AG":filenamediploma,
          "AH":filenamegra,
          "AI":filenamepostgra,
          "AJ":filenamephd,
          "AK":hse_stream,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
      });
      if(json.decode(response.body)==1){
        setState(() {
          Mainloader=false;
        });
        Navigator.of(context).pop();
      }
    }
    else{
      setState(() {
      });
      error();
    }
  }

  void fetcheduacation() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_eduacation.php",
        body: {
          "A": widget.email,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        eduacation = json.decode(response.body);
      });
      if(eduacation.length!=0){
        if(eduacation[0]['postgraduation_unit']=='true'){
          MasterCourses(eduacation[0]['postgraduation_program']);
        }
        if(eduacation[0]['graduation_unit']=='true'){
          BechlorCourses(eduacation[0]['graduation_program']);
        }
        setvalue();
      }
      else{
        setState(() {
          Mainloader=false;
        });
      }

    }
    else{
      error();
    }
  }

  void setvalue(){
    print(eduacation[0]['hse_unit']);
    if(eduacation[0]['hse_unit']=='true'){
      Heigher_Secondray=true;
      Heigher_Secondray_Stream=eduacation[0]['hse_stream'];
      Heigher_Secondray_Board=eduacation[0]['hse_board'];
      Heigher_Secondray_Complited_Year=eduacation[0]['hse_py'];
      per12 =TextEditingController(text: eduacation[0]['hse_pr']);
      Result_Higher_Secondary=eduacation[0]['hse_result'];
      filenamehse=eduacation[0]['hse_resultname'];
    }
    if(eduacation[0]['diploma_unit']=='true'){
      Diploma=true;
      Diploma_Course=eduacation[0]['diploma_course'];
      Collage_Diploma=eduacation[0]['diploma_collage'];
      Diploma_Complited_Year=eduacation[0]['diploma_py'];
      cpi_diploma=TextEditingController(text: eduacation[0]['diploma_cpi']);
      Result_Diploma=eduacation[0]['diploma_result'];
      filenamediploma=eduacation[0]['diploma_resultname'];
    }
    if(eduacation[0]['graduation_unit']=='true'){
      Graduation=true;
      Graduation_Program=eduacation[0]['graduation_program'];
      Graduation_Course=eduacation[0]['graduation_course'];
      Collage_Graduation=eduacation[0]['graduation_collage'];
      Graduation_Complited_Year=eduacation[0]['graduation_py'];
      cpi_graduation=TextEditingController(text: eduacation[0]['graduation_cpi']);
      Result_Graduation=eduacation[0]['graduation_result'];
      filenamegra=eduacation[0]['gra_resultname'];
    }
    if(eduacation[0]['postgraduation_unit']=='true'){
      PostGraduation=true;
      PostGraduation_Program=eduacation[0]['postgraduation_program'];
      PostGraduation_Course=eduacation[0]['postgraduation_course'];
      Collage_PostGraduation=eduacation[0]['postgraduation_collage'];
      PostGraduation_Complited_Year=eduacation[0]['postgraduation_py'];
      cpi_postgraduation=TextEditingController(text: eduacation[0]['postgraduation_cpi']);
      Result_PostGraduation=eduacation[0]['postgraduation_result'];
      filenamepostgra=eduacation[0]['postgra_resultname'];
    }
    if(eduacation[0]['phd_unit']=='true'){
      PHD=true;
      phd_subject=TextEditingController(text: eduacation[0]['phd_sub']);;
      phd_aboutsubject=TextEditingController(text: eduacation[0]['phd_aboutsub']);;
      Collage_PHD=eduacation[0]['phd_collage'];
      Result_PHD=eduacation[0]['phd_degree'];
      filenamephd=eduacation[0]['phd_resultname'];
    }
    Mainloader=false;
  }

  void valuechecker(){
    int temp=0;
    if(Heigher_Secondray==true){
      if(Heigher_Secondray_Stream=='' || Heigher_Secondray_Board=='' || Heigher_Secondray_Complited_Year==' ' || per122=='' || Result_Higher_Secondary=='' || filenamehse==' ' ){
        temp=temp+1;
      }
    }
    if(Diploma==true){
      if(Diploma_Course=='' || Collage_Diploma=='' || Diploma_Complited_Year==' ' || cpi_diploma2=='' || Result_Diploma=='' || filenamediploma==' '){
        temp=temp+1;
      }
    }
    if(Graduation==true){
      if(Graduation_Program=='' || Graduation_Course=='' || Collage_Graduation=='' || Graduation_Complited_Year==' ' || cpi_graduation2=='' || Result_Graduation=='' || filenamegra==' '){
        temp=temp+1;
      }
    }
    if(PostGraduation==true){
      if(PostGraduation_Program=='' || PostGraduation_Course=='' || Collage_PostGraduation=='' || PostGraduation_Complited_Year==' ' || cpi_postgraduation2=='' || Result_PostGraduation=='' || filenamepostgra==' '){
        temp=temp+1;
      }
    }
    if(PHD==true){
      if(phd_subject2=='' || phd_aboutsubject2=='' || Collage_PHD=='' || Result_PHD=='' || filenamephd==' '){
        temp=temp+1;
      }
    }
    if(temp==0){
      setState(() {
        Mainloader=true;
      });
      assignval();
    }else{
      Show_Aleart(context, "Enter All The Details");
    }
  }

  Choose_Result_Higher_Secondary() {
    setState(() {File_Result_Higher_Secondary = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  Choose_Result_Diploma() {
    setState(() {File_Result_Diploma = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  Choose_Result_Graduation() {
    setState(() {File_Result_Graduation = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  Choose_Result_PostGraduation() {
    setState(() {File_Result_PostGraduation = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  Choose_Result_PHD() {
    setState(() {File_Result_PHD = ImagePicker.pickImage(source: ImageSource.gallery);});
  }

  Widget Show_Result_Higher_Secondary() {
    return FutureBuilder<File>(
      future: File_Result_Higher_Secondary,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile_Result_Higher_Secondary = snapshot.data;
          Result_Higher_Secondary = base64Encode(snapshot.data.readAsBytesSync());
          String fileNamehse = tmpFile_Result_Higher_Secondary.path.split('/').last;
          var file = File(tmpFile_Result_Higher_Secondary.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            filenamehse=fileNamehse;
            return Text(filenamehse, textAlign: TextAlign.center,);}
          else{
            Result_Higher_Secondary=null;
            file=null;
            tmpFile_Result_Higher_Secondary=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return  Text(filenamehse, textAlign: TextAlign.center,);
        }},);
  }
  Widget Show_Result_Diploma() {
    return FutureBuilder<File>(
      future: File_Result_Diploma,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile_Result_Diploma = snapshot.data;
          Result_Diploma = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFile_Result_Diploma.path.split('/').last;
          var file = File(tmpFile_Result_Diploma.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            filenamediploma=fileName2;
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            Result_Diploma=null;
            file=null;
            tmpFile_Result_Diploma=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return Text(filenamediploma, textAlign: TextAlign.center,);
        }},);
  }
  Widget Show_Result_Graduation() {
    return FutureBuilder<File>(
      future: File_Result_Graduation,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile_Result_Graduation = snapshot.data;
          Result_Graduation = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFile_Result_Graduation.path.split('/').last;
          var file = File(tmpFile_Result_Graduation.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            filenamegra=fileName2;
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            Result_Graduation=null;
            file=null;
            tmpFile_Result_Graduation=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return Text(filenamegra, textAlign: TextAlign.center,);
        }},);
  }
  Widget Show_Result_PostGraduation() {
    return FutureBuilder<File>(
      future: File_Result_PostGraduation,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile_Result_PostGraduation = snapshot.data;
          Result_PostGraduation = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFile_Result_PostGraduation.path.split('/').last;
          var file = File(tmpFile_Result_PostGraduation.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            filenamepostgra=fileName2;

            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            Result_PostGraduation=null;
            file=null;
            tmpFile_Result_PostGraduation=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return Text(filenamepostgra, textAlign: TextAlign.center,);
        }},);
  }
  Widget Show_Result_PHD() {
    return FutureBuilder<File>(
      future: File_Result_PHD,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile_Result_PHD = snapshot.data;
          Result_PHD = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFile_Result_PHD.path.split('/').last;
          var file = File(tmpFile_Result_PHD.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            filenamephd=fileName2;
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            Result_PHD=null;
            file=null;
            tmpFile_Result_PHD=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return Text(filenamephd, textAlign: TextAlign.center,);
        }},);
  }
  void _selectDate(BuildContext context,int i) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != DateTime.now())
      setState(() {
        DateTime selectedDate = picked;
        if(i==1){
          setState(() {
            Heigher_Secondray_Complited_Year=selectedDate.toString().split(" ")[0];
          });
        }
        else if(i==2){
          setState(() {
            Diploma_Complited_Year=selectedDate.toString().split(" ")[0];
          });
        }
        else if(i==3){
          setState(() {
            Graduation_Complited_Year=selectedDate.toString().split(" ")[0];
          });
        }else{
          setState(() {
            PostGraduation_Complited_Year=selectedDate.toString().split(" ")[0];
          });
        }
      });
  }

  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0){
      fetchData();
      t=t+1;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Text("Education",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
      ),
      body:Center(
        child:SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Mainloader==false? Container(
                child:Container(
                  //padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                  child:  Column(
                    children: <Widget>[
                      Container(
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,0.0,10,0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("Heigher Secondary Education",style: TextStyle(fontSize:20,color: Colors.blue, fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                    Diploma==false?Switch(
                                      value: Heigher_Secondray,
                                      onChanged: (value){
                                        setState(() {
                                          Heigher_Secondray=value;
                                        });
                                      },
                                    ):Container(),
                                  ],
                                ),
                                Heigher_Secondray==true?Container(
                                  child: Column(
                                    children: <Widget>[
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Stream'),
                                        items: Stream.map((item){
                                          return new DropdownMenuItem(
                                            child:new Text(item['stream']),
                                            value: item['stream'].toString(),
                                          );

                                        }).toList(),
                                        onChanged: (newVal){
                                          setState(() {
                                            Heigher_Secondray_Stream=newVal;
                                          });
                                        },
                                        value: Heigher_Secondray_Stream,

                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Board'),
                                        items: boarddata.map((item){
                                          return new DropdownMenuItem(
                                            child:new Text(item['Board']),
                                            value: item['Board'].toString(),
                                          );

                                        }).toList(),
                                        onChanged: (newVal){
                                          setState(() {
                                            Heigher_Secondray_Board=newVal;
                                          });
                                        },
                                        value: Heigher_Secondray_Board,

                                      ),
                                      /*new DropdownButton(
                                       isExpanded: true,
                                       hint: new Text('Passing Year'),
                                       items: passingyeardata.map((item){

                                         return new DropdownMenuItem(
                                           child:new Text(item['year']),
                                           value: item['year'].toString(),
                                         );

                                       }).toList(),
                                       onChanged: (newVal){
                                         setState(() {
                                           Heigher_Secondray_Complited_Year=newVal;
                                         });
                                       },
                                       value: Heigher_Secondray_Complited_Year,

                                     ),*/
                                      RaisedButton(
                                        onPressed:(){
                                          _selectDate(context,1);
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
                                                      Text(" Completed Date : "+Heigher_Secondray_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                      // Text("                      "+Heigher_Secondray_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller:per12,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'Percentage of 12th:',
                                            labelStyle: TextStyle(
                                                fontFamily: 'design.graffiti.comicsansms',
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue))),

                                      ),
                                      RaisedButton(
                                        onPressed:(){
                                          Choose_Result_Higher_Secondary();
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Final Result Copy:",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                      Show_Result_Higher_Secondary(),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,0.0,10,0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("Diploma",style: TextStyle(fontSize:20,color: Colors.blue, fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                    Heigher_Secondray==false?Switch(
                                      value: Diploma,
                                      onChanged: (value){
                                        setState(() {
                                          Diploma=value;
                                        });
                                      },
                                    ):Container(),
                                  ],
                                ),
                                Diploma==true?Container(
                                  child: Column(
                                    children: <Widget>[
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Course:'),
                                        items: Diplomacourses .map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Diploma_Course = newVal;
                                          });
                                        },
                                        value: Diploma_Course,

                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Collage:'),
                                        items:collagenamedata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Collage_Diploma = newVal;
                                          });
                                        },
                                        value: Collage_Diploma,

                                      ),
                                      /* new DropdownButton(
                                          isExpanded: true,
                                          hint: new Text('Passing Year:'),
                                          items: passingyeardata.map((item){

                                            return new DropdownMenuItem(
                                              child:new Text(item['year']),
                                              value: item['year'].toString(),
                                            );

                                          }).toList(),
                                          onChanged: (newVal){
                                            setState(() {
                                              Diploma_Complited_Year=newVal;
                                            });
                                          },
                                          value: Diploma_Complited_Year,

                                        ),*/
                                      RaisedButton(
                                        onPressed:(){
                                          _selectDate(context,2);
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
                                                      Text(" Completed Date : "+Diploma_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                      //Text("                      "+Diploma_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller:cpi_diploma,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'CPI:',
                                            labelStyle: TextStyle(
                                                fontFamily: 'design.graffiti.comicsansms',
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue))),

                                      ),
                                      RaisedButton(
                                        onPressed:(){
                                          Choose_Result_Diploma();
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Final Result Copy:",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                      Show_Result_Diploma(),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,0.0,10,0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("Graduation",style: TextStyle(fontSize:20,color: Colors.blue, fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                    Switch(
                                      value: Graduation,
                                      onChanged: (value){
                                        setState(() {
                                          Graduation=value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Graduation==true?Container(
                                  child: Column(
                                    children: <Widget>[
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Program:'),
                                        items: bachlerdata.map((item){
                                          return new DropdownMenuItem(
                                            child:new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal){
                                          BechlorCourses(newVal);
                                          setState(() {
                                            Graduation_Course=null;
                                            Graduation_Program=newVal;

                                          });

                                        },
                                        value: Graduation_Program,
                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Course:'),
                                        items:  Bechlorcourses.map((item){
                                          return new DropdownMenuItem(
                                            child:new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal){
                                          setState(() {
                                            Graduation_Course=newVal;
                                          });
                                        },
                                        value: Graduation_Course,
                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Collage:'),
                                        items:collagenamedata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Collage_Graduation = newVal;
                                          });
                                        },
                                        value: Collage_Graduation,

                                      ),
                                      /*new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Passing Year'),
                                        items: passingyeardata.map((item){

                                          return new DropdownMenuItem(
                                            child:new Text(item['year']),
                                            value: item['year'].toString(),
                                          );

                                        }).toList(),
                                        onChanged: (newVal){
                                          setState(() {
                                            Graduation_Complited_Year=newVal;
                                          });
                                        },
                                        value: Graduation_Complited_Year,

                                      ),*/
                                      RaisedButton(
                                        onPressed:(){
                                          _selectDate(context,3);
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
                                                      Text(" Completed Date : "+Graduation_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                      // Text("                      "+Graduation_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller:cpi_graduation,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'CPI:',
                                            labelStyle: TextStyle(
                                                fontFamily: 'design.graffiti.comicsansms',
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue))),
                                      ),
                                      RaisedButton(
                                        onPressed:(){
                                          Choose_Result_Graduation();
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Final Result Copy:",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                      Show_Result_Graduation(),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,0.0,10,0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("PostGraduation",style: TextStyle(fontSize:20,color: Colors.blue, fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                    Switch(
                                      value: PostGraduation,
                                      onChanged: (value){
                                        setState(() {
                                          PostGraduation=value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                PostGraduation==true?Container(
                                  child: Column(
                                    children: <Widget>[
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Program:'),
                                        items: masterdata.map((item){
                                          return new DropdownMenuItem(
                                            child:new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal){
                                          MasterCourses(newVal);
                                          setState(() {
                                            PostGraduation_Course=null;
                                            PostGraduation_Program=newVal;

                                          });

                                        },
                                        value: PostGraduation_Program,
                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Course:'),
                                        items: Mastercourses.map((item){
                                          return new DropdownMenuItem(
                                            child:new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal){
                                          setState(() {
                                            PostGraduation_Course=newVal;
                                          });
                                        },
                                        value: PostGraduation_Course,
                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Collage:'),
                                        items:collagenamedata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Collage_PostGraduation = newVal;
                                          });
                                        },
                                        value: Collage_PostGraduation,

                                      ),
                                      /* new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Passing Year'),
                                        items: passingyeardata.map((item){

                                          return new DropdownMenuItem(
                                            child:new Text(item['year']),
                                            value: item['year'].toString(),
                                          );

                                        }).toList(),
                                        onChanged: (newVal){
                                          setState(() {
                                            PostGraduation_Complited_Year=newVal;
                                          });
                                        },
                                        value: PostGraduation_Complited_Year,

                                      ),*/
                                      RaisedButton(
                                        onPressed:(){
                                          _selectDate(context,4);
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
                                                      Text(" Completed Date : "+PostGraduation_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                      //Text("                      "+PostGraduation_Complited_Year,style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller:cpi_postgraduation,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'CPI:',
                                            labelStyle: TextStyle(
                                                fontFamily: 'design.graffiti.comicsansms',
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue))),
                                      ),
                                      RaisedButton(
                                        onPressed:(){
                                          Choose_Result_PostGraduation();
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Final Result Copy:",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                      Show_Result_PostGraduation(),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10,0.0,10,0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("P.H.D",style: TextStyle(fontSize:20,color: Colors.blue, fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                    Switch(
                                      value: PHD,
                                      onChanged: (value){
                                        setState(() {
                                          PHD=value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                PHD==true?Container(
                                  child: Column(
                                    children: <Widget>[
                                      TextField(
                                        controller:phd_subject,
                                        decoration: InputDecoration(
                                            labelText: 'Subject:',
                                            labelStyle: TextStyle(
                                                fontFamily: 'design.graffiti.comicsansms',
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue))),
                                      ),
                                      TextField(
                                        controller:phd_aboutsubject,
                                        minLines:null,
                                        decoration: InputDecoration(
                                            labelText: 'About Subject:',
                                            labelStyle: TextStyle(
                                                fontFamily: 'design.graffiti.comicsansms',
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue))),
                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Collage:'),
                                        items:collagenamedata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Collage_PHD = newVal;
                                          });
                                        },
                                        value: Collage_PHD,

                                      ),
                                      RaisedButton(
                                        onPressed:(){
                                          Choose_Result_PHD();
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                        child:Center(
                                          child: Container(
                                            //padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Degree Copy:",style: TextStyle(color: Colors.black54, fontFamily: 'design.graffiti.comicsansms'),),
                                                      Show_Result_PHD(),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                              ],
                            ),
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
                          if(PHD==true){
                            if(PostGraduation==true){
                              if(Graduation==true){
                                if(Diploma==true || Heigher_Secondray==true){
                                  valuechecker();
                                }
                                else{
                                  Show_Aleart(context, "Either H.S.E Or Diploma Details Required, If Done Graduation");
                                }
                              }
                              else {
                                Show_Aleart(context, "Graduation Details Required, If Done Post Graduation");
                              }
                            }
                            else{
                              Show_Aleart(context, "Post Graduation Details Required, If Done P.H.D");
                            }
                          }else if(PostGraduation==true){
                            if(Graduation==true){
                              if(Diploma==true || Heigher_Secondray==true){
                                valuechecker();
                              }
                              else{
                                Show_Aleart(context, "Either H.S.E Or Diploma Details Required, If Done Graduation");
                              }
                            }
                            else{
                              Show_Aleart(context, "Graduation Details Required, If Done Post Graduation");
                            }
                          }else if(Graduation==true){
                            if(Diploma==true || Heigher_Secondray==true){
                              valuechecker();
                            }
                            else{
                              Show_Aleart(context, "Either H.S.E Or Diploma Details Required, If Done Graduation");
                            }
                          }
                          else{
                            Show_Aleart(context, "At least Graduation Complasory For Appling Specific Job.... ");
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
                    ],
                  ),
                ),
              ): Container(
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
            ],
          ),
        ),
      ),
    );
  }
}