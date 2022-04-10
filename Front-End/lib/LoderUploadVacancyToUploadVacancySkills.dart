import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/HomePageApplicant.dart';
import 'package:flutter_app2/main.dart';
import 'HomePageRecruiter.dart';
import 'SignUpPageApplicant.dart';
import 'SignUpPageRecruiter.dart';
import 'UploadVacancy.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoderUploadVacancyToUploadVacancySkills extends StatefulWidget {
  LoderUploadVacancyToUploadVacancySkills(
      this.email, this.mySelection, this.no_vacancy2);
  final String email, mySelection, no_vacancy2;
  @override
  _LoderUploadVacancyToUploadVacancySkills createState() =>
      _LoderUploadVacancyToUploadVacancySkills(email, mySelection, no_vacancy2);
}

class _LoderUploadVacancyToUploadVacancySkills
    extends State<LoderUploadVacancyToUploadVacancySkills> {
  _LoderUploadVacancyToUploadVacancySkills(email, mySelection, no_vacancy2);
  bool _loadingInProgress = true;

  void insertdata() async {
    final response = await http
        .post("http://resumeranker.hopto.org/vacancy_upload2.php", body: {
      "A": widget.mySelection,
      "B": widget.no_vacancy2,
      "C": widget.email,
    });
    var respbody = json.decode(response.body);
    if (respbody == 1) {
      setState(() {
        _loadingInProgress = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Homepage1(widget.email);
      }));
    } else {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Homepage1(widget.email);
                    }));
                  },
                )
              ],
            );
          });
    }
  }

  int t = 0;
  @override
  Widget build(BuildContext context) {
    if (t == 0) {
      insertdata();
      t = t + 1;
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child:
                _loadingInProgress ? CircularProgressIndicator() : Text(' ')),
      ),
    );
  }
}
