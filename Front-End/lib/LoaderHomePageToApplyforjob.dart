import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'HomePageRecruiter.dart';
import 'applyforjob.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoderHomePageToApplyforjob extends StatefulWidget {
  LoderHomePageToApplyforjob(
      this.email, this.compnyname, this.compnyemail, this.post);
  final String email, compnyname, compnyemail, post;

  @override
  _LoderHomePageToApplyforjob createState() =>
      _LoderHomePageToApplyforjob(email, compnyname, compnyemail, post);
}

class _LoderHomePageToApplyforjob extends State<LoderHomePageToApplyforjob> {
  _LoderHomePageToApplyforjob(email, compnyname, compnyemail, post);
  bool _loadingInProgress = true;
  List test = [];
  void fetchdata() async {
    final response =
        await http.post("http://resumeranker.hopto.org/que_paper.php", body: {
      "A": widget.compnyemail,
      "B": widget.post,
    });
    if (response.statusCode == 200) {
      setState(() {
        test = json.decode(response.body);
      });
      setState(() {
        _loadingInProgress = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return applyforjob(widget.email, widget.compnyname, widget.compnyemail,
            widget.post, test);
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
      fetchdata();
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
