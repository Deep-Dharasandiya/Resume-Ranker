import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/HomePageApplicant.dart';
import 'package:flutter_app2/ResumeBuilder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app2/ShowVacancy.dart';
class LoderHomePageApplicantToResumeBuilder extends StatefulWidget {
  LoderHomePageApplicantToResumeBuilder(this.email);
  final String email;
  @override
  _LoderHomePageApplicantToResumeBuilder createState() => _LoderHomePageApplicantToResumeBuilder(email);
}

class _LoderHomePageApplicantToResumeBuilder extends State<LoderHomePageApplicantToResumeBuilder> {
  _LoderHomePageApplicantToResumeBuilder(email);
  bool _loadingInProgress=true;
  List coursediplomadata=[],collagenamedata=[],compnydata=[],skillnamedata=[],bachlerdata=[],postdata=[],masterdata=[];
  void fetchData() async {
    final response = await http.get(
        'http://resumeranker.hopto.org/getcollagename.php');
    if (response.statusCode == 200) {
      setState(() {
        print("collagenamedata");
        collagenamedata = json.decode(response.body);
      });
      final response3 = await http.get(
          'http://resumeranker.hopto.org/getcompnyname.php');
      if (response3.statusCode == 200) {
        setState(() {
          print("compnydata");
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ResumeBuilder(widget.email, collagenamedata, compnydata, skillnamedata,postdata,bachlerdata,masterdata);
                  }));
                });
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
  }
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

  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0)
    {
      fetchData();
      t=t+1;
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: _loadingInProgress? CircularProgressIndicator(): Text(' ')
        ),
      ),
    );
  }
}