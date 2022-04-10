import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'HomePageApplicant.dart';
import 'HomePageRecruiter.dart';
class LoderMainToHomePageApplicant extends StatefulWidget {
  LoderMainToHomePageApplicant(this.email,this.password);
  final String email,password;
  @override
  _LoderMainToHomePageApplicant createState() => _LoderMainToHomePageApplicant(email,password);
}

class _LoderMainToHomePageApplicant extends State<LoderMainToHomePageApplicant> {
  _LoderMainToHomePageApplicant(email,password);
  bool _loadingInProgress=true;
  String name;
  Future<void> set1(String mail,name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.setInt("intvalue", 1);
    prefs?.setString("Email", mail);
    prefs?.setString("Name", name);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Home(widget.email);
    }));
  }
  Future<void> set2(String mail,name) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.setInt("intvalue", 2);
    prefs?.setString("Email", mail);
    prefs?.setString("Name", name);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Homepage1(widget.email);
    }));
  }

 void Name(int i)async {
    final response = await http.post("http://resumeranker.hopto.org/returnapplicantname.php",
        body: {
          "A": widget.email,
        }
    );
    setState(() {
      name= json.decode(response.body);
    });
    if(i==1){
      set1(widget.email,name);
    }
    else {
      set2(widget.email, name);
    }
  }

  void insertdata()async {
    final response = await http.post("http://resumeranker.hopto.org/login.php",
        body: {
          "A": widget.email,
          "B": widget.password,
        }
    );

    print(response.body);
    var respbody = json.decode(response.body);

    if (respbody == 1) {
      Name(1);
      setState(() {
        _loadingInProgress = false;
      });
    }

    else if (respbody == 2)
    {
      setState(() {
        _loadingInProgress = false;
      });
      Name(2);

    }
    else
    {
      setState(() {
        _loadingInProgress = false;
      });
      _displayDialog2(context);
    }

  }

  _displayDialog2(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('Please Enter Correct Details'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Loginpage();
                  }));
                },
              ),
            ],
          );
        });
  }
  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0)
      {
        insertdata();
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