import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/HomePageApplicant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:email_validator/email_validator.dart';
class ResumeBuilder extends StatefulWidget {
  ResumeBuilder(this.email,this.collagenamedata,this.compnydata,this.skillnamedata,this.postdata,this.bachlerdata,this.masterdata);
  final String email;
  List collagenamedata=[],compnydata=[],skillnamedata=[],bachlerdata=[],postdata=[],masterdata=[];
  @override
  _ResumeBuilder createState() => _ResumeBuilder(email,collagenamedata,compnydata,skillnamedata,postdata,bachlerdata,masterdata);
}

class _ResumeBuilder extends State<ResumeBuilder> {
  _ResumeBuilder(email,collagenamedata,compnydata,skillnamedata,postdata,bachlerdata,masterdata);

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

  TextEditingController per12 =TextEditingController();
  String get per122 => per12.text;

  TextEditingController cpidiploma =TextEditingController();
  String get cpidiploma2=>cpidiploma.text;

  TextEditingController cpigraduation =TextEditingController();
  String get cpigraduation2=>cpigraduation.text;

  TextEditingController cpipostgraduation =TextEditingController();
  String get cpipostgraduation2=>cpipostgraduation.text;

  TextEditingController otherdetails =TextEditingController();
  String get otherdetails2=>otherdetails.text;

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  bool scienceordeploma,postgraduation;
  bool graduation=true;
  String boardselection,passingyearselection,courseselectiondiploma,collageselectiondiploma,passingyearselectiondiploma,compnynameexp,postexp,noyearexp;
  String passingyeargraduation,collageselectiongraduation,courseselectiongraduation,Programgraduation;
  String programpostgraduation,courseselectionpostgraduation,collageselectionpostgraduation,passingyearselectionpostgraduation;
  List passingyeardata= [{"year": '2019'},{"year": '2018'},{"year": '2017'},{"year": '2016'},{"year": '2015'},{"year": '2014'},{"year": '2013'},{"year": '2012'},{"year": '2011'},{"year": '2010'},{"year": '2009'},{"year": '2008'},{"year": '2007'},{"year": '2006'},{"year": '2005'},{"year": '2004'},{"year": '2003'},{"year": '2002'},{"year": '2001'},{"year": '2000'}];
  List boarddata=[{"Board": 'GSEB'},{"Board": 'CBSC'}];
  List Programgraduationdata=[{"program": 'BE'},{"program": 'B.Tech'},{"program": 'BCA'},{"program": 'BSC'}];
  List programpostgraduationdata=[{"program": 'ME'},{"program": 'M.Tech'},{"program": 'MCA'},{"program": 'MSC'}];
  List coursediplomadata=[],collagenamedata=[],coursesnamedata=[],coursepostgraduationdata=[{"name": 'First Select The Program'}],coursegraduationdata=[{"name": 'First Select The Program'}];
  List yearno = [{"ID":'1'}, {"ID":'2'},{"ID":'3'},{"ID":'4'},{"ID":'5'},{"ID":'6'},{"ID":'7'},{"ID":'8'},{"ID":'9'},{"ID":'10'},{"ID":'above 10'}];
  void error()
  {
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
                    return Homepage(widget.email);
                  }));
                },
              )
            ],
          );
        });
  }
  void fetchData() async {
    final response = await http.post(
    "http://resumeranker.hopto.org/getCourses.php",
        body: {
          "A": "Diploma",
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        coursesnamedata = json.decode(response.body);
        scienceordeploma = false;
      });
    }
    else{
      error();
    }
  }
  void fetchData2(String a) async {
    graduation=false;
    final response = await http.post(
        "http://resumeranker.hopto.org/getCourses.php",
        body: {
          "A": a.toString(),
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        coursegraduationdata = json.decode(response.body);
        graduation=true;
      });
    }
    else{
      error();
    }
  }
  bool postfalge=true;
  void fetchData3(String a) async {
    postfalge=false;
    final response = await http.post(
        "http://resumeranker.hopto.org/getCourses.php",
        body: {
          "A": a,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        coursepostgraduationdata = json.decode(response.body);
        postfalge=true;
      });
    }
    else{
      error();
    }
  }
  Future<File> filebio,file12,filediploma,filegraduation,filepostgraduation;
  String base64Imagebio,base64Image12,base64Imagediploma,base64Imagegraduation,base64Imagepostgraduation;
  File tmpFilebio,tmpFile12,tmpFilediploma,tmpFilegraduation,tmpFilepostgraduation;
  chooseImage12() {
    setState(() {file12 = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  chooseImagediploma() {
    setState(() {filediploma = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  chooseImagegraduation() {
    setState(() {filegraduation = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  chooseImagepostgraduation() {
    setState(() {filepostgraduation = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  chooseImagebio() {
    setState(() {filebio = ImagePicker.pickImage(source: ImageSource.gallery);});
  }
  bool Apptestflag=true;
  bool Apptestflag2=true;
  Widget showImage12() {
    return FutureBuilder<File>(
      future: file12,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile12 = snapshot.data;
          base64Image12 = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFile12.path.split('/').last;
          var file = File(tmpFile12.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            base64Image12=null;
            file=null;
            tmpFile12=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return const Text('No Image Selected', textAlign: TextAlign.center,);
        }},);
  }
  Widget showImagediploma() {
    return FutureBuilder<File>(
      future: filediploma,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFilediploma = snapshot.data;
          base64Imagediploma = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFilediploma.path.split('/').last;
          var file = File(tmpFilediploma.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            base64Imagediploma=null;
            file=null;
            tmpFilediploma=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return const Text('No Image Selected', textAlign: TextAlign.center,);
        }},);
  }
  Widget showImagegraduation() {
    return FutureBuilder<File>(
      future: filegraduation,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFilegraduation = snapshot.data;
          base64Imagegraduation = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFilegraduation.path.split('/').last;
          var file = File(tmpFilegraduation.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            base64Imagegraduation=null;
            file=null;
            tmpFilegraduation=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return const Text('No Image Selected', textAlign: TextAlign.center,);
        }},);
  }
  Widget showImagebio() {
    return FutureBuilder<File>(
      future: filebio,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFilebio = snapshot.data;
          base64Imagebio = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFilebio.path.split('/').last;
          var file = File(tmpFilebio.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            base64Imagebio=null;
            file=null;
            tmpFilebio=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return const Text('No Image Selected', textAlign: TextAlign.center,);
        }},);
  }
  Widget showImagepostgraduation() {
    return FutureBuilder<File>(
      future: filepostgraduation,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFilepostgraduation = snapshot.data;
          base64Imagepostgraduation = base64Encode(snapshot.data.readAsBytesSync());
          String fileName2 = tmpFilepostgraduation.path.split('/').last;
          var file = File(tmpFilepostgraduation.path);
          int size=file.lengthSync() ;
          if(size<=102400){
            return Text(fileName2, textAlign: TextAlign.center,);}
          else{
            base64Imagepostgraduation=null;
            file=null;
            tmpFilepostgraduation=null;
            return const Text('Select less than 100kb Icon', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0,),);
          }}
        else if (null != snapshot.error) {
          return const Text('Error Picking Image', textAlign: TextAlign.center,);
        } else {
          return const Text('No Image Selected', textAlign: TextAlign.center,);
        }},);
  }
  bool server1Selected = false;
  bool server2Selected = false;
  bool server3Selected = false;
  bool server4Selected = false;
  var ans = new List(6);
  void checkans(){
    int count=0;
    for(int i=1;i<=5;i++){
      if(ans[i]==AppTestdata[i-1]["Ans"]){
        count=count+1;
      }
    }
    print(indicateskill);
    print(count);
    if(indicateskill==1){
      skill1mark=count;
    }
    else if(indicateskill==2){
      skill2mark=count;
    }else if(indicateskill==3){
      skill3mark=count;
    }else if(indicateskill==4){
      skill4mark=count;
    }
    else{
      skill5mark=count;
    }
  }
  void assign(var s,int p)
  {
    print(s);
    print(Apptestsrno);
    ans[Apptestsrno]=s;
    print( ans[Apptestsrno]);
    setState(() {
      server1Selected = false;
      server2Selected = false;
      server3Selected = false;
      server4Selected = false;
    });
      if(p==1)
      {
        setState(() {
          server1Selected = true;
        });
      }
      else if(p==2)
      {
        setState(() {
          server2Selected = true;
        });
      }
      else if(p==3){
        setState(() {
          server3Selected = true;
        });
      }
      else if(p==4){
        setState(() {
          server4Selected = true;
        });
      }
  }
  int _start = 10;
  int time;
  int indicateskill=0;

  void startTimer() {
    _start = 10;
    Timer _timer;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
              time = _start;
              _start = _start - 1;
              if (_start < 1) {
               setState(() {
                 server1Selected = false;
                  server2Selected = false;
                  server3Selected = false;
                  server4Selected = false;
                 if(Apptestsrno<=5){
                   if(Apptestsrno<5){
                     Apptestsrno=Apptestsrno+1;
                   }
                   if(Apptestsrno==5){
                     checkans();
                     Apptestflag=true;
                     Apptestflag2=true;

                   }
                 }

               });
                _start=10;
              }
            }
            ),
    );

  }
 String skill1;
  String skill2;
  String skill3;
  String skill4;
  String skill5;
  bool skillflag=true;
  List AppTestdata=[];
  bool timerapp=false;
  void fetchque(String skill,String type) async {
    Apptestflag=false;
    Apptestflag2=false;
    final response = await http.post(
        "http://resumeranker.hopto.org/getAppTest.php",
        body: {
          "A": "C",
          "B": type,
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        Apptestsrno=1;
        AppTestdata = json.decode(response.body);
        Apptestflag2=true;
        if(timerapp==true){
          _start=10;
        }
        else{
          startTimer();
          timerapp=true;
        }

      });
    }
    else{
      error();
    }
  }
  int skill1mark,skill2mark,skill3mark,skill4mark,skill5mark;
  int Apptestsrno=1;
  void optionmessage(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('You give only one time..'),
            actions: <Widget>[

              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
  bool exp=true;
  bool checkexp=false;
  bool checkexp2=false;
  bool checkexp3=false;
  void insertexp() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/Addexp.php",
        body: {
          "A": widget.email,
          "B":noyearexp,
          "C":postexp,
          "D":compnynameexp,
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        noyearexp=null;
        postexp=null;
        compnynameexp=null;
        exp=true;
      });
    }
    else{
      error();
    }
  }
  bool insertresume=true;
  void insertalldata() async {
     insertresume=false;
     if(scienceordeploma==true && postgraduation==true){
       final response = await http.post(

           "http://resumeranker.hopto.org/Addresume.php",
           body: {
             "A": widget.email,
             "B":fname2,
             "C":mname2,
             "D":lname2,
             "E":email2,
             "F":cono2,
             "G":ladd2,
             "H":city2,
             "I":dis2,
             "J":ta2,
             "K":pin2,
             "L":selectedDate.toString(),
             "M":base64Imagebio,
             "NN":scienceordeploma.toString(),
             "N":boardselection,
             "O":passingyearselection,
             "P":per122,
             "Q":base64Image12,
             "R":"abc",
             "S":"abc",
             "T":"0001",
             "U":"1.1",
             "V":"abc",
             "W":Programgraduation,
             "X":courseselectiongraduation,
             "Y":collageselectiongraduation,
             "Z":passingyeargraduation,
             "AA":cpigraduation2,
             "BB":base64Imagegraduation,
             "CC":postgraduation.toString(),
             "DD":programpostgraduation,
             "EE":courseselectionpostgraduation,
             "FF":collageselectionpostgraduation,
             "GG":passingyearselectionpostgraduation,
             "HH":cpipostgraduation2,
             "II":base64Imagepostgraduation,
             "JJ":skill1,
             "KK":skill2,
             "LL":skill3,
             "MM":skill4,
             "OO":skill5,
             "PP":skill1mark.toString(),
             "QQ":skill2mark.toString(),
             "RR":skill3mark.toString(),
             "SS":skill4mark.toString(),
             "TT":skill5mark.toString(),
             "UU":otherdetails2,
           }
       );

       if (response.statusCode == 200) {
         if(json.decode(response.body)==1){
           insertresume=true;
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return Homepage(widget.email);
           }));
         }
       }
       else{
         print("error");
       }
     }
     if(scienceordeploma==false && postgraduation==true){
       final response = await http.post(

           "http://resumeranker.hopto.org/Addresume.php",
           body: {
             "A": widget.email,
             "B":fname2,
             "C":mname2,
             "D":lname2,
             "E":email2,
             "F":cono2,
             "G":ladd2,
             "H":city2,
             "I":dis2,
             "J":ta2,
             "K":pin2,
             "L":selectedDate.toString(),
             "M":base64Imagebio,
             "NN":scienceordeploma.toString(),
             "N":"abc",
             "O":"0001",
             "P":"10.10",
             "Q":"abc",
             "R":courseselectiondiploma,
             "S":collageselectiondiploma,
             "T":passingyearselectiondiploma,
             "U":cpidiploma2,
             "V":base64Imagediploma,
             "W":Programgraduation,
             "X":courseselectiongraduation,
             "Y":collageselectiongraduation,
             "Z":passingyeargraduation,
             "AA":cpigraduation2,
             "BB":base64Imagegraduation,
             "CC":postgraduation.toString(),
             "DD":programpostgraduation,
             "EE":courseselectionpostgraduation,
             "FF":collageselectionpostgraduation,
             "GG":passingyearselectionpostgraduation,
             "HH":cpipostgraduation2,
             "II":base64Imagepostgraduation,
             "JJ":skill1,
             "KK":skill2,
             "LL":skill3,
             "MM":skill4,
             "OO":skill5,
             "PP":skill1mark.toString(),
             "QQ":skill2mark.toString(),
             "RR":skill3mark.toString(),
             "SS":skill4mark.toString(),
             "TT":skill5mark.toString(),
             "UU":otherdetails2,
           }
       );

       if (response.statusCode == 200) {
         if(json.decode(response.body)==1){
           insertresume=true;
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return Homepage(widget.email);
           }));
         }
       }
       else{
         print("error");
       }
     }
     if(scienceordeploma==true && postgraduation==false){
       final response = await http.post(

           "http://resumeranker.hopto.org/Addresume.php",
           body: {
             "A": widget.email,
             "B":fname2,
             "C":mname2,
             "D":lname2,
             "E":email2,
             "F":cono2,
             "G":ladd2,
             "H":city2,
             "I":dis2,
             "J":ta2,
             "K":pin2,
             "L":selectedDate.toString(),
             "M":base64Imagebio,
             "NN":scienceordeploma.toString(),
             "N":boardselection,
             "O":passingyearselection,
             "P":per122,
             "Q":base64Image12,
             "R":"abc",
             "S":"abc",
             "T":"0001",
             "U":"1.1",
             "V":"abc",
             "W":Programgraduation,
             "X":courseselectiongraduation,
             "Y":collageselectiongraduation,
             "Z":passingyeargraduation,
             "AA":cpigraduation2,
             "BB":base64Imagegraduation,
             "CC":postgraduation.toString(),
             "DD":"abc",
             "EE":"abc",
             "FF":"abc",
             "GG":"0001",
             "HH":"1.1",
             "II":"abc",
             "JJ":skill1,
             "KK":skill2,
             "LL":skill3,
             "MM":skill4,
             "OO":skill5,
             "PP":skill1mark.toString(),
             "QQ":skill2mark.toString(),
             "RR":skill3mark.toString(),
             "SS":skill4mark.toString(),
             "TT":skill5mark.toString(),
             "UU":otherdetails2,
           }
       );

       if (response.statusCode == 200) {
         if(json.decode(response.body)==1){
           insertresume=true;
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return Homepage(widget.email);
           }));
         }
       }
       else{
         print("error");
       }
     }
     if(scienceordeploma==false && postgraduation==false){
       final response = await http.post(

           "http://resumeranker.hopto.org/Addresume.php",
           body: {
             "A": widget.email,
             "B":fname2,
             "C":mname2,
             "D":lname2,
             "E":email2,
             "F":cono2,
             "G":ladd2,
             "H":city2,
             "I":dis2,
             "J":ta2,
             "K":pin2,
             "L":selectedDate.toString(),
             "M":base64Imagebio,
             "NN":scienceordeploma.toString(),
             "N":"abc",
             "O":"0001",
             "P":"10.10",
             "Q":"abc",
             "R":courseselectiondiploma,
             "S":collageselectiondiploma,
             "T":passingyearselectiondiploma,
             "U":cpidiploma2,
             "V":base64Imagediploma,
             "W":Programgraduation,
             "X":courseselectiongraduation,
             "Y":collageselectiongraduation,
             "Z":passingyeargraduation,
             "AA":cpigraduation2,
             "BB":base64Imagegraduation,
             "CC":postgraduation.toString(),
             "DD":"abc",
             "EE":"abc",
             "FF":"abc",
             "GG":"0001",
             "HH":"1.1",
             "II":"abc",
             "JJ":skill1,
             "KK":skill2,
             "LL":skill3,
             "MM":skill4,
             "OO":skill5,
             "PP":skill1mark.toString(),
             "QQ":skill2mark.toString(),
             "RR":skill3mark.toString(),
             "SS":skill4mark.toString(),
             "TT":skill5mark.toString(),
             "UU":otherdetails2,
           }
       );

       if (response.statusCode == 200) {
         if(json.decode(response.body)==1){
           insertresume=true;
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return Homepage(widget.email);
           }));
         }
       }
       else{
         print("error");
       }
     }
  }
  int validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 0;
    }
    else{
      return 1;
    }

  }
  List expdata=[];
  void fetchexp() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/getexp.php",
        body: {
          "A": widget.email,
        }
    );
    if (response.statusCode == 200) {
      expdata=json.decode(response.body);
      checkexp3=false;
      checkexp2=true;
    }
    else{
      error();
    }
  }
 int checkbio(){
   if(fname2==null || mname2==null || lname==null || email2==null || cono2==null || ladd2==null || city2==null || dis2==null || ta2==null || pin2==null || base64Imagebio==null){
     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title: Text('Warning'),
             content: Text('Please Enter All the details of Bio'),
             actions: <Widget>[

               new FlatButton(
                 child: new Text('Ok'),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               )
             ],
           );
         });
     return 0;
   }
   else{
     return 1;
   }
 }
 int check12ordiploma(){
    if(scienceordeploma!=true && scienceordeploma!=false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text('Please select 11&12(Science) or diploma ..'),
              actions: <Widget>[

                new FlatButton(
                  child: new Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
    else {
      if (scienceordeploma == true) {
        if (boardselection == null || passingyearselection == null ||
            per122 == null || base64Image12 == null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Warning'),
                  content: Text('Enter All The Details of 11&12(Science)..'),
                  actions: <Widget>[

                    new FlatButton(
                      child: new Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
          return 0;
        }
        else {
          return 1;
        }
      }
      else {
        if (scienceordeploma == false) {
          if (courseselectiondiploma == null ||
              collageselectiondiploma == null ||
              passingyearselectiondiploma == null || cpidiploma2 == null ||
              base64Imagediploma == null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Warning'),
                    content: Text('Enter All The Details of Diploma..'),
                    actions: <Widget>[

                      new FlatButton(
                        child: new Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
            return 0;
          }
          else {
            return 1;
          }
        }
      }
    }
 }
 int checkgraduation(){
   if(Programgraduation==null || courseselectiongraduation==null || collageselectiongraduation==null || passingyeargraduation==null || cpigraduation2==null || base64Imagegraduation==null){
     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title: Text('Warning'),
             content: Text('Enter All The Details of Graduation..'),
             actions: <Widget>[
               new FlatButton(
                 child: new Text('Ok'),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               )
             ],
           );
         });
     return 0;
   }
   else{
     return 1;
   }
 }
 int checkpostgraduation() {
    if(postgraduation!=true && postgraduation!=false){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text(
                  'Please select postgraduation Yes or No.'),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return 0;
    }
    else {
      if (postgraduation == true) {
        if (programpostgraduation == null ||
            courseselectionpostgraduation == null ||
            collageselectionpostgraduation == null ||
            passingyearselectionpostgraduation == null ||
            cpipostgraduation2 == null || base64Imagepostgraduation == null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Warning'),
                  content: Text(
                      'Enter All The Details of Post Graduation..'),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
          return 0;
        }
        else {
          return 1;
        }
      }
      else {
        return 1;
      }
    }
 }
 int chekskill(){
   if(skill1==null || skill2==null || skill3==null || skill4==null || skill5==null || skill1mark==null || skill2mark==null || skill3mark==null || skill4mark==null || skill5mark==null ){
     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title: Text('Warning'),
             content: Text(
                 'Enter All The Skills ans give Test ..'),
             actions: <Widget>[
               new FlatButton(
                 child: new Text('Ok'),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               )
             ],
           );
         });
     return 0;
   }
   else{
     return 1;
   }
 }
 int checkexpsection(){
   if(checkexp2==false){
     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title: Text('Warning'),
             content: Text(
                 'Enter Your Experience. '),
             actions: <Widget>[
               new FlatButton(
                 child: new Text('Ok'),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               )
             ],
           );
         });
     return 0;
   }
   else{
     return 1;
   }
 }
 int checkotherdetails(){
   if(otherdetails==null){
     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title: Text('Warning'),
             content: Text(
                 'Enter the details About Your Achivement & Projects etc. '),
             actions: <Widget>[
               new FlatButton(
                 child: new Text('Ok'),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               )
             ],
           );
         });
     return 0;
   }
   else {
     return 1;
   }
 }
  @override
  Widget build(BuildContext context) {


    double width = MediaQuery. of(context). size. width;
    double hight = MediaQuery. of(context). size. height;
    return  WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Aleart'),
                  content: Text('Do you want to go Home, delete all the details accroding this post..'),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Yes'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Homepage(widget.email);
                        }));
                      },
                    ),
                    new FlatButton(
                      child: new Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });

          return false;
        },
    child: MaterialApp(
      home: Scaffold(
        body: Center(
        child:  Container(
              constraints: BoxConstraints.expand(),
          height: hight,
          width: width,
          decoration: BoxDecoration(
          image: DecorationImage(
          image: new AssetImage('assets/resume01.jpeg',),
          fit: BoxFit.cover)
          ),
          child:insertresume==true?Container(
          child:Apptestflag==true?SingleChildScrollView(
            child:Column(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.fromLTRB(5,60,5,5),
                  child:Card(
                    margin: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child:Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:  Column(
                        children: <Widget>[
                          new Text("About Your Bio",style: new TextStyle(fontSize: 20.0,color: Colors.blue),),
                          TextField(
                            controller:fname,
                            decoration: InputDecoration(
                                labelText: 'Enter First Name:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                          ),
                          TextField(
                            controller:mname,
                            decoration: InputDecoration(
                                labelText: 'Enter Middle Name:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),

                          ),
                          TextField(
                            controller:lname,
                            decoration: InputDecoration(
                                labelText: 'Enter Last name:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),

                          ),
                          TextField(
                            controller:email,
                            decoration: InputDecoration(
                                labelText: 'Enter Your Email:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),

                          ),
                          new Text("Enter Your Address:",style: new TextStyle(fontSize: 15.0,color: Colors.black87),),
                          TextField(
                            controller:ladd,
                            decoration: InputDecoration(
                                labelText: 'Local Address:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),

                          ),
                          TextField(
                            controller:city,
                            decoration: InputDecoration(
                                labelText: 'City:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),

                          ),
                          TextField(
                            controller:dis,
                            decoration: InputDecoration(
                                labelText: 'District:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),

                          ),
                          TextField(
                            controller:ta,
                            decoration: InputDecoration(
                                labelText: 'Sub District:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                          ),
                          Text(" "),
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select Your Birth Date'),
                          ),
                          Text("${selectedDate.toLocal()}".split(' ')[0]),
                          Text(''),
                          OutlineButton(
                            onPressed: chooseImagebio,
                            child: Text('Select Result'),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          showImagebio(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: new EdgeInsets.fromLTRB(5,5,5,5),
                  child:Card(
                    margin: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child:Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:  Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child: Column(
                              children: <Widget>[
                                new Text("Enter Eduacation Details:",style: new TextStyle(fontSize: 20.0,color: Colors.blue),),
                                Text(" "),
                                new Text("Which You Doing",style: new TextStyle(fontSize: 15.0,color: Colors.blue),),
                                RadioListTile(
                                  groupValue: scienceordeploma,
                                  title: Text('11th-12th(Science)'),
                                  value: true,
                                  onChanged: (val1) {
                                    setState(() {
                                      scienceordeploma = val1;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  groupValue: scienceordeploma,
                                  title: Text('Diploma'),
                                  value: false,
                                  onChanged: (val2) {
                                    setState(() {
                                      fetchData();
                                    });
                                  },
                                ),
                               Text(" "),
                              ],
                            ),
                          ),
                          scienceordeploma==true?Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child:Card(
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                child:  Column(
                                  children: <Widget>[
                                    new Text("Please Enter Your Higher Secondary Details ",
                                      style: new TextStyle(
                                          fontSize: 20.0, color: Colors.blue),),
                                    new DropdownButton(
                                      hint: new Text('Select Youe Board'),
                                      items: boarddata.map((item){
                                        return new DropdownMenuItem(
                                          child:new Text(item['Board']),
                                          value: item['Board'].toString(),
                                        );

                                      }).toList(),
                                      onChanged: (newVal){
                                        setState(() {
                                          boardselection=newVal;
                                        });
                                      },
                                      value: boardselection,

                                    ),
                                    new DropdownButton(
                                      hint: new Text('Select Youe Passing Year'),
                                      items: passingyeardata.map((item){

                                        return new DropdownMenuItem(
                                          child:new Text(item['year']),
                                          value: item['year'].toString(),
                                        );

                                      }).toList(),
                                      onChanged: (newVal){
                                        setState(() {
                                          passingyearselection=newVal;
                                        });
                                      },
                                      value: passingyearselection,

                                    ),
                                    TextField(
                                      controller:per12,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Enter Percentage of 12th:',
                                          labelStyle: TextStyle(
                                              fontFamily: 'design.graffiti.comicsansms',
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blue))),

                                    ),
                                    OutlineButton(
                                      onPressed: chooseImage12,
                                      child: Text('Select Result'),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    showImage12(),
                                  ],
                                ),
                              ),
                            ),
                          ):Container(),
                          scienceordeploma==false?  Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child:Card(
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                child: Column(
                                  children: <Widget>[
                                    new Text("Please Enter Your Diploma Details ",
                                      style: new TextStyle(
                                          fontSize: 20.0, color: Colors.blue),),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Select Youe Course'),
                                        items: coursesnamedata .map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            if(newVal=='First Select The Program')
                                            {
                                              courseselectiondiploma=null;
                                            }
                                            else{
                                              courseselectiondiploma = newVal;
                                            }
                                          });
                                        },
                                        value: courseselectiondiploma,

                                      ),
                                      new DropdownButton(
                                        isExpanded: true,
                                        hint: new Text('Select Youe collage'),
                                        items: widget.collagenamedata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['name']),
                                            value: item['name'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            collageselectiondiploma = newVal;
                                          });
                                        },
                                        value: collageselectiondiploma,

                                      ),
                                      new DropdownButton(
                                        hint: new Text('Select Youe Passing Year'),
                                        items: passingyeardata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['year']),
                                            value: item['year'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            passingyearselectiondiploma = newVal;
                                          });
                                        },
                                        value: passingyearselectiondiploma,

                                      ),
                                    TextField(
                                      controller:cpidiploma,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Enter Your CPI:',
                                          labelStyle: TextStyle(
                                              fontFamily: 'design.graffiti.comicsansms',
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blue))),

                                    ),
                                    OutlineButton(
                                      onPressed: chooseImagediploma,
                                      child: Text('Chooss Icon'),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    showImagediploma(),
                                  ],
                                ),
                              ),
                            ),
                          ):Container(),
                          graduation==true ?Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child:Card(
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                child: Column(
                                  children: <Widget>[
                                    new Text("Please Enter Your Graduation Details ",
                                      style: new TextStyle(
                                          fontSize: 20.0, color: Colors.blue),),
                                     new DropdownButton(
                            isExpanded: true,
                            hint: new Text('Select Youe Program'),
                            items: widget.bachlerdata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['name']),
                                value: item['name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                Programgraduation = newVal;
                                courseselectiongraduation=null;
                                fetchData2(newVal);

                              });
                            },
                            value: Programgraduation,

                          ),
                          new DropdownButton(
                            isExpanded: true,
                            hint: new Text('Select Youe Course'),
                            items:  coursegraduationdata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['name']),
                                value: item['name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                courseselectiongraduation = newVal;
                              });
                            },
                            value: courseselectiongraduation,

                          ),
                          new DropdownButton(
                            isExpanded: true,
                            hint: new Text('Select Youe collage'),
                            items: widget.collagenamedata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['name']),
                                value: item['name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                collageselectiongraduation = newVal;
                              });
                            },
                            value: collageselectiongraduation,

                          ),
                          new DropdownButton(
                            hint: new Text('Select Youe Passing Year'),
                            items: passingyeardata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['year']),
                                value: item['year'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                passingyeargraduation = newVal;
                              });
                            },
                            value: passingyeargraduation,

                          ),

                                    TextField(
                                      controller:cpigraduation,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Enter Your CPI:',
                                          labelStyle: TextStyle(
                                              fontFamily: 'design.graffiti.comicsansms',
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blue))),

                                    ),
                                    OutlineButton(
                                      onPressed: chooseImagegraduation,
                                      child: Text('Select Result'),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    showImagegraduation(),
                                  ],
                                ),
                              ),
                            ),
                          ): Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child:Card(
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                child:  CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child:Card(
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                child:  Column(
                                  children: <Widget>[
                                    new Text("You are complite Post Graduation Yes or Not ",
                                      style: new TextStyle(
                                          fontSize: 20.0, color: Colors.blue),),
                                    new Text("If You Done Postgraduation then fill the details other wise check the radio button"),
                                    RadioListTile(
                                      groupValue:  postgraduation,
                                      title: Text('If Yes'),
                                      value: true,
                                      onChanged: (val1) {
                                        setState(() {
                                          postgraduation= val1;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      groupValue:  postgraduation,
                                      title: Text('If No'),
                                      value: false,
                                      onChanged: (val1) {
                                        setState(() {
                                          postgraduation= val1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                         postgraduation==true?Container(
                           child:postfalge==true?Container(
                            padding: new EdgeInsets.fromLTRB(5,5,5,5),
                            child:Card(
                              margin: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child:Container(
                                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                child:  Column(
                                  children: <Widget>[
                                    new Text("Please Enter Your Post Graduation Details ",
                                      style: new TextStyle(
                                          fontSize: 20.0, color: Colors.blue),),
                                    new DropdownButton(
                                      isExpanded: true,
                                      hint: new Text('Select Youe Program'),
                                      items: widget.masterdata.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(item['name']),
                                          value: item['name'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          courseselectionpostgraduation=null;
                                          programpostgraduation = newVal;

                                          fetchData3(newVal);

                                        });
                                      },
                                      value: programpostgraduation,

                                    ),
                                    new DropdownButton(
                                      isExpanded: true,
                                      hint: new Text('Select Youe Course'),
                                      items:  coursepostgraduationdata.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(item['name']),
                                          value: item['name'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          if(newVal=='First Select The Program')
                                            {
                                              courseselectionpostgraduation=null;
                                            }
                                          else{
                                            courseselectionpostgraduation = newVal;
                                          }

                                        });
                                      },
                                      value: courseselectionpostgraduation,

                                    ),
                                    new DropdownButton(
                                      isExpanded: true,
                                      hint: new Text('Select Youe collage'),
                                      items: widget.collagenamedata.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(item['name']),
                                          value: item['name'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          collageselectionpostgraduation = newVal;
                                        });
                                      },
                                      value: collageselectionpostgraduation,

                                    ),
                                    new DropdownButton(
                                      hint: new Text('Select Youe Passing Year'),
                                      items: passingyeardata.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(item['year']),
                                          value: item['year'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          passingyearselectionpostgraduation = newVal;
                                        });
                                      },
                                      value: passingyearselectionpostgraduation,

                                    ),

                                    TextField(
                                      controller:cpipostgraduation,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Enter Your CPI:',
                                          labelStyle: TextStyle(
                                              fontFamily: 'design.graffiti.comicsansms',
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blue))),

                                    ),
                                    OutlineButton(
                                      onPressed: chooseImagepostgraduation,
                                      child: Text('Select Result'),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    showImagepostgraduation(),
                                  ],
                                ),
                              ),
                            ),
                           ):Container(
                             padding: new EdgeInsets.fromLTRB(5,5,5,5),
                             child:Card(
                               margin: EdgeInsets.all(5.0),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(15.0),
                               ),
                               elevation: 5,
                               child:Container(
                                 padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                                 child:  CircularProgressIndicator(),
                               ),
                             ),
                           ),
                          ) : Container(),
                        ],
                      ),
                    ),
                  ),
                ),




                Container(
                  padding: new EdgeInsets.fromLTRB(5,5,5,5),
                  child:Card(
                    margin: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child:skillflag==true?Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:  Column(
                        children: <Widget>[
                          new Text("Slect Skills Priority Wise ",style: new TextStyle( fontWeight:FontWeight.bold,fontSize: 18.0,color: Colors.black),),
                          new DropdownButton(
                            hint: Text("1st Skill",style: new TextStyle(fontSize: 18.0,color: Colors.black),),
                            items:widget.skillnamedata.map((item){
                              return new DropdownMenuItem(
                                child:new Text(item['skills_name']),
                                value: item['skills_name'],
                              );

                            }).toList(),
                            onChanged: (newVal){
                              setState(() {
                                skill1=newVal;
                              });
                            },
                            value:skill1,

                          ),
                          new DropdownButton(
                            hint: new Text('2nd Skill'),
                            items: widget.skillnamedata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['skills_name']),
                                value: item['skills_name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                skill2 = newVal;
                              });
                            },
                            value: skill2,

                          ),
                          new DropdownButton(
                            hint: new Text('3rd Skill'),
                            items: widget.skillnamedata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['skills_name']),
                                value: item['skills_name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                skill3 = newVal;
                              });
                            },
                            value: skill3,

                          ),
                          new DropdownButton(
                            hint: new Text('4th Skill'),
                            items: widget.skillnamedata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['skills_name']),
                                value: item['skills_name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                skill4 = newVal;
                              });
                            },
                            value: skill4,

                          ),
                          new DropdownButton(
                            hint: new Text('5th Skill'),
                            items: widget.skillnamedata.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['skills_name']),
                                value: item['skills_name'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                skill5 = newVal;
                              });
                            },
                            value: skill5,

                          ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                          onPressed:(){
                            if(skill1==null || skill2==null || skill3==null || skill4==null || skill5==null)
                              {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Warning'),
                                        content: Text('Plese select All the Skills'),
                                        actions: <Widget>[

                                          new FlatButton(
                                            child: new Text('Ok'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            else{
                              if(skill1==skill2 || skill1==skill3 ||skill1==skill4 ||skill1==skill5 || skill2==skill4 ||skill2==skill5|| skill2 == skill3 || skill3==skill4 ||skill3==skill5)
                                {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content: Text('Plese select Differant Skills'),
                                          actions: <Widget>[

                                            new FlatButton(
                                              child: new Text('Ok'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              else{
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Warning'),
                                        content: Text('Confirm ,After you Dose Not Change Skill.. '),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('YES'),
                                            onPressed: () {
                                              setState(() {
                                                skillflag=false;
                                              });
                                              Navigator.pop(context);
                                            },

                                          ),
                                          new FlatButton(
                                            child: new Text('NO'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },

                                          )
                                        ],
                                      );
                                    });

                              }

                            }



                          },
                          color: Colors.blue,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:Center(
                            child: Text("Save Skills",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'design.graffiti.comicsansms'),),
                          ),
                        ),
                        ],
                      ),
                    ):
                    Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:Column(
                        children: <Widget>[
                          Text("=>Please Give Test For Selected Five Skills,Add One By Vacancy : "+skill1,style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'design.graffiti.comicsansms'),),
                          Text("=>During The Test You Do Not Go Back,Press Back Button You go to Home And Erase The Data Whatever Written in Resum Builder: "+skill1,style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'design.graffiti.comicsansms'),),
                          Text(" "),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)
                            ),
                            onPressed:(){
                              if(skill1mark==null){
                                setState(() {
                                  indicateskill=1;
                                });
                                fetchque(skill1,"Professional");
                              }
                              else{

                                optionmessage();
                              }

                            },
                            color: skill1mark==null?Colors.blue:Colors.orangeAccent,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:Center(
                              child: Text(skill1,style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'design.graffiti.comicsansms'),),
                            ),
                          ),
                          Text(" "),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)
                            ),
                            onPressed:(){
                              if(skill2mark==null) {
                                fetchque(skill2, "Intermediate");
                                setState(() {
                                  indicateskill=2;
                                });
                              }
                              else{

                                optionmessage();
                              }

                            },
                            color: skill2mark==null?Colors.blue:Colors.orangeAccent,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:Center(
                              child: Text(skill2,style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'design.graffiti.comicsansms'),),
                            ),
                          ),
                          Text(" "),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)
                            ),
                            onPressed:(){
                              if(skill3mark==null){
                                fetchque(skill3,"Intermediate");
                                setState(() {
                                  indicateskill=3;
                                });
                              }
                              else{

                                optionmessage();
                              }

                            },
                            color: skill3mark==null?Colors.blue:Colors.orangeAccent,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:Center(
                              child: Text(skill3,style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'design.graffiti.comicsansms'),),
                            ),
                          ),
                          Text(" "),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)
                            ),
                            onPressed:(){
                              if(skill4mark==null){
                                fetchque(skill4,"Intermediate");
                                setState(() {
                                  indicateskill=4;
                                });
                              }
                              else{

                                optionmessage();
                              }

                            },
                            color: skill4mark==null?Colors.blue:Colors.orangeAccent,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:Center(
                              child: Text(skill4,style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'design.graffiti.comicsansms'),),
                            ),
                          ),
                          Text(" "),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)
                            ),
                            onPressed:(){

                              if(skill5mark==null){
                                fetchque(skill2,"Beginner");
                                setState(() {
                                  indicateskill=5;
                                });
                              }
                              else{

                                optionmessage();
                              }
                            },
                            color: skill5mark==null?Colors.blue:Colors.orangeAccent,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:Center(
                              child: Text(skill5,style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'design.graffiti.comicsansms'),),
                            ),
                          ),
                          Text(" "),
                        ],
                      ),
                    ),
                  ),
                ),
               checkexp==false?Container(
                 child:Column(
                   children: <Widget>[
                     exp==true? Container(
                       padding: new EdgeInsets.fromLTRB(5,5,5,5),
                       child:Card(
                         margin: EdgeInsets.all(5.0),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(15.0),
                         ),
                         elevation: 5,
                         child:Container(
                           padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                           child:  Column(
                             children: <Widget>[
                               new DropdownButton(
                                 isExpanded: true,
                                 hint: new Text('Select number of Year'),
                                 items:yearno.map((item){
                                   return new DropdownMenuItem(
                                     child:new Text(item['ID']),
                                     value: item['ID'].toString(),
                                   );

                                 }).toList(),
                                 onChanged: (newVal){
                                   setState(() {
                                     noyearexp=newVal;
                                   });
                                 },
                                 value: noyearexp,

                               ),
                               new DropdownButton(
                                 isExpanded: true,
                                 hint: new Text('Select post'),
                                 items: widget.postdata.map((item){
                                   return new DropdownMenuItem(
                                     child:new Text(item['post_name']),
                                     value: item['post_name'].toString(),
                                   );

                                 }).toList(),
                                 onChanged: (newVal){
                                   setState(() {
                                     postexp=newVal;
                                   });
                                 },
                                 value: postexp,

                               ),
                               new DropdownButton(
                                 isExpanded: true,
                                 hint: new Text('Select Compny name'),
                                 items: widget.compnydata.map((item){
                                   return new DropdownMenuItem(
                                     child:new Text(item['compnyname']),
                                     value: item['compnyname'].toString(),
                                   );

                                 }).toList(),
                                 onChanged: (newVal){
                                   setState(() {
                                     compnynameexp=newVal;
                                   });
                                 },
                                 value: compnynameexp,

                               ),
                               RaisedButton(
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18.0),
                                     side: BorderSide(color: Colors.red)
                                 ),
                                 onPressed:(){
                                   if(noyearexp==null || compnynameexp==null || postexp==null){
                                     showDialog(
                                         context: context,
                                         builder: (context) {
                                           return AlertDialog(
                                             title: Text('Warning'),
                                             content: Text('Plese Enter All the Details'),
                                             actions: <Widget>[

                                               new FlatButton(
                                                 child: new Text('Ok'),
                                                 onPressed: () {
                                                   Navigator.pop(context);
                                                 },
                                               )
                                             ],
                                           );
                                         });
                                   }
                                   else{
                                     setState(() {
                                       exp=false;
                                     });
                                   }

                                 },
                                 color:Colors.blue,
                                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                 child:Center(
                                   child: Text("Save Experience",style: TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'design.graffiti.comicsansms'),),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ):
                     Container(
                       padding: new EdgeInsets.fromLTRB(5,5,5,5),
                       child:Card(
                         margin: EdgeInsets.all(5.0),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(15.0),
                         ),
                         elevation: 5,
                         child:Container(
                           padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                           child:  Column(
                             children: <Widget>[
                               Text("No of Year :  "+ noyearexp,style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: 'design.graffiti.comicsansms'),),
                               Text(" "),
                               Text("Post Name :  "+ postexp,style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: 'design.graffiti.comicsansms'),),
                               Text(" "),
                               Text("Compny Name :  "+compnynameexp,style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: 'design.graffiti.comicsansms'),),
                               RaisedButton(
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18.0),
                                     side: BorderSide(color: Colors.red)
                                 ),
                                 onPressed:(){
                                   insertexp();
                                 },
                                 color:Colors.blue,
                                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                 child:Center(
                                   child: Text("Save & Add Experience",style: TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'design.graffiti.comicsansms'),),
                                 ),
                               ),
                               RaisedButton(
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18.0),
                                     side: BorderSide(color: Colors.red)
                                 ),
                                 onPressed:(){
                                   checkexp=true;
                                   checkexp3=true;
                                   insertexp();
                                   fetchexp();

                                 },
                                 color:Colors.blue,
                                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                 child:Center(
                                   child: Text("Confirm & Save (No More Experience) )",style: TextStyle(
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
                   ],
                 ),
               ):Container(),
                checkexp2==true? Container(
                  padding: new EdgeInsets.fromLTRB(5,10,5,5),
                  child:Card(
                    margin: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child:Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:  SingleChildScrollView(
                        child:  new ListView.builder(
                          shrinkWrap: true,
                          // itemCount: spacecrafts.length,
                          itemCount: expdata.length,

                          itemBuilder: (BuildContext context, int index) {
                            print(expdata.length);
                            return ListTile(

                              title: new Card(
                                margin: EdgeInsets.all(5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                //color: Colors.yellowAccent,
                                elevation: 5.0,
                                child: new Container(
                                  child:Center(
                                    child:Column(
                                      children: <Widget>[
                                        Text("Exp: "+(index+1).toString()),
                                        Text("No. of Year : "+expdata[index]["noyear"] ),
                                        Text("Post Name : "+expdata[index]["post"]),
                                        Text("Compny Name: "+expdata[index]["compnyname"]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ):Container(),
              /* checkexp2==true? Container(
                 child:SingleChildScrollView(
                 child:  new ListView.builder(
                   shrinkWrap: true,
               // itemCount: spacecrafts.length,
               itemCount: expdata.length,

                 itemBuilder: (BuildContext context, int index) {
                   print(expdata.length);
                   return ListTile(

                     title: new Card(

                       //color: Colors.yellowAccent,
                       elevation: 5.0,
                       child: new Container(
                         child:Center(
                           child:Column(
                             children: <Widget>[
                               Text("Exp: "+index.toString()),
                               Text("No. of Year : "+expdata[index]["noyear"] ),
                               Text("Post Name : "+expdata[index]["post"]),
                               Text("Compny Name: "+expdata[index]["compnyname"]),
                             ],
                           ),
                         ),
                       ),
                     ),
                   );
                 },
               ),
                 ),
          )
                :Container(),*/
                checkexp3==true?Container(
                  padding: new EdgeInsets.fromLTRB(5,5,5,5),
                  child:Card(
                    margin: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child:Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:  CircularProgressIndicator(),
                    ),
                  ),
                ):Container(),
                 Container(
                  padding: new EdgeInsets.fromLTRB(5,5,5,5),
                  child:Card(
                    margin: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child:Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                      child:  Column(
                        children: <Widget>[
                          Text(" "),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            controller: otherdetails,
                            decoration: InputDecoration(
                                labelText: 'Enter your details:',
                                labelStyle: TextStyle(
                                    fontFamily: 'design.graffiti.comicsansms',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                            maxLines: null,
                          ),
                          Text(" "),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: new EdgeInsets.fromLTRB(10.0,25.0,10.0,10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)
                        ),
                        onPressed:(){
                          if(checkbio()==1){
                            if(EmailValidator.validate(email2)==true){
                              if(validateMobile(cono2)==1)
                              {
                                if(check12ordiploma()==1){
                                  if(checkgraduation()==1)
                                    {
                                      if(checkpostgraduation()==1){
                                        if(chekskill()==1){
                                          if(checkexpsection()==1){
                                            if(checkotherdetails()==1){
                                              insertalldata();
                                            }
                                          }
                                        }
                                      }
                                    }
                                }
                              }
                              else{
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Warning'),
                                        content: Text('Please Enter valid mobail no..'),
                                        actions: <Widget>[

                                          new FlatButton(
                                            child: new Text('Ok'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Warning'),
                                      content: Text('Please Enter Valid Email..'),
                                      actions: <Widget>[

                                        new FlatButton(
                                          child: new Text('Ok'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }

                          }



                        },
                        color: Colors.redAccent,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child:Center(
                          child: Text("Confirm & Save Resume ",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'design.graffiti.comicsansms'),),
                        ),
                      ),
                      Text(" "),
                    ],
                  ),
                ),
              ],
            ),
          ):SingleChildScrollView(
            child:Column(
              children: <Widget>[
                Apptestflag2==true? Container(
                  child:Column(
                    children: <Widget>[
                     Container(
                        padding: new EdgeInsets.fromLTRB(0,50.0,0,0),
                        child:Card(
                          margin: EdgeInsets.all(7.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child:Container(
            padding: new EdgeInsets.fromLTRB(10.0,50.0,10.0,10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_start.toString(),style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'design.graffiti.comicsansms'),),
                Text("Question: "+Apptestsrno.toString(),style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'design.graffiti.comicsansms'),),
                Text(" "),
                Text("=> "+AppTestdata[Apptestsrno-1]["que"],style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'design.graffiti.comicsansms'),),
                Text(" "),
              ],
            ),
          ),
        ),
        ),
                      Container(
                        padding: new EdgeInsets.fromLTRB(0,0.0,0,0),
                        child:Card(
                          margin: EdgeInsets.all(7.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10.0,17.0,10.0,10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(_start.toString(),style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: 'design.graffiti.comicsansms'),),
                                Text("Select One Of This:",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'design.graffiti.comicsansms'),),
                                Text(" "),
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)
                                    ),
                                    onPressed:(){
                                      assign("A",1);
                                    },
                                    color: server1Selected == true ? Colors.green : Colors.blue,
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child:Center(
                                      child: Text(AppTestdata[Apptestsrno-1]["A"],style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)
                                    ),
                                    onPressed:(){
                                      assign("B",2);
                                    },
                                    color: server2Selected == true ? Colors.green : Colors.blue,
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child:Center(
                                      child: Text(AppTestdata[Apptestsrno-1]["B"],style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)
                                    ),
                                    onPressed:(){
                                      assign("C",3);
                                    },
                                    color: server3Selected == true ? Colors.green : Colors.blue,
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child:Center(
                                      child: Text(AppTestdata[Apptestsrno-1]["C"],style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)
                                    ),
                                    onPressed:(){
                                      assign("D",4);
                                    },
                                    color: server4Selected == true ? Colors.green : Colors.blue,
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child:Center(
                                      child: Text(AppTestdata[Apptestsrno-1]["D"],style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'design.graffiti.comicsansms'),),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: new EdgeInsets.fromLTRB(0,10.0,0,0),
                        child:Card(
                          margin: EdgeInsets.all(7.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child:Container(
                            padding: new EdgeInsets.fromLTRB(10.0,25.0,10.0,10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.blue)
                                  ),
                                  onPressed:(){
                                    setState(() {
                                      if(Apptestsrno<5){
                                        server1Selected = false;
                                        server2Selected = false;
                                        server3Selected = false;
                                        server4Selected = false;
                                        Apptestsrno=Apptestsrno+1;
                                       _start=10;
                                      }
                                      else{
                                        checkans();
                                        server1Selected = false;
                                        server2Selected = false;
                                        server3Selected = false;
                                        server4Selected = false;
                                        Apptestflag2=true;
                                        Apptestflag=true;
                                      }
                                    });
                                  },
                                  color: Colors.redAccent,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child:Center(
                                    child: Apptestsrno==5?Text("Go To Skill",style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'design.graffiti.comicsansms'),):Text("Next Que",style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'design.graffiti.comicsansms'),),
                                  ),
                                ),
                                Text(" "),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            ):Container(
            padding: new EdgeInsets.fromLTRB(5,hight-20,5,5),
            child:Card(
              margin: EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child:Container(
                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                child:  CircularProgressIndicator(),
              ),
            ),
           ),
              ],
            ),
          ),

        ):Container(
            padding: new EdgeInsets.fromLTRB(5,5,5,5),
            child:Card(
              margin: EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child:Container(
                padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                child:  CircularProgressIndicator(),
              ),
            ),
          ),
      ),
      ),
      ),
    ),
    );
  }
}