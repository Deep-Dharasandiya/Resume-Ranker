import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/HomePageApplicant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app2/ShowVacancy.dart';
class LoderHomePageApplicantToShowVacancy extends StatefulWidget {
  LoderHomePageApplicantToShowVacancy(this.email);
  final String email;
  @override
  _LoderHomePageApplicantToShowVacancy createState() => _LoderHomePageApplicantToShowVacancy(email);
}

class _LoderHomePageApplicantToShowVacancy extends State<LoderHomePageApplicantToShowVacancy> {
  _LoderHomePageApplicantToShowVacancy(email);
  bool _loadingInProgress=true;
  List data1=[],data2=[];
  void fetchData1() async {

    final response = await http.get(
        'http://resumeranker.hopto.org/get_vacancy.php');
    if (response.statusCode == 200) {

        data1 = json.decode(response.body);
      final response2 = await http.get(
          'http://resumeranker.hopto.org/get_vacancy_icon.php');
      if (response2.statusCode == 200) {
          data2 = json.decode(response2.body);
          setState(() {
            _loadingInProgress=true;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return show_vacancy(widget.email,data1,data2);
          }));
      }
      else
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
    }
    else{
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
  }





  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0)
    {
      fetchData1();
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