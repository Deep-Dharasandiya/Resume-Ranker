import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/HomePageApplicant.dart';
import 'package:flutter_app2/main.dart';
import 'SignUpPageApplicant.dart';
import 'SignUpPageRecruiter.dart';
import 'UploadVacancy.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoderHomePageRecruiterToUploadVacancy extends StatefulWidget {
  LoderHomePageRecruiterToUploadVacancy(this.email);
  final String email;
  @override
  _LoderHomePageRecruiterToUploadVacancy createState() =>
      _LoderHomePageRecruiterToUploadVacancy(email);
}

class _LoderHomePageRecruiterToUploadVacancy
    extends State<LoderHomePageRecruiterToUploadVacancy> {
  _LoderHomePageRecruiterToUploadVacancy(email);
  bool _loadingInProgress = true;
  List postname = [], skillname = [];

  Show_Aleart(BuildContext context, String message) async {
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

  void fetchData() async {
    if (t == 0) {
      t = t + 1;
      final response =
          await http.get('http://resumeranker.hopto.org/vacancy_post.php');
      if (response.statusCode == 200) {
        final responseskill =
            await http.get('http://resumeranker.hopto.org/vacancy_skills.php');
        if (responseskill.statusCode == 200) {
          setState(() {
            postname = json.decode(response.body);
            skillname = json.decode(responseskill.body);
            _loadingInProgress = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UploadVacncy(widget.email);
          }));
        } else {
          _loadingInProgress = false;
          Show_Aleart(context, "Server Not Responding...");
        }
      } else {
        _loadingInProgress = false;
        Show_Aleart(context, "Server Not Responding...");
      }
    }
  }

  int t = 0;
  @override
  Widget build(BuildContext context) {
    if (t == 0) {
      fetchData();
      t = t + 1;
    }
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    double ratio = hight / width;
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _loadingInProgress
              ? Container(
                  padding: EdgeInsets.only(top: hight / 2),
                  child: Column(children: <Widget>[
                    CircularProgressIndicator(),
                    Text(" "),
                    Text("Please Wait..."),
                  ]),
                )
              : Container(),
        ),
      ),
    );
  }
}
