import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ShowResume.dart';
class ShowResume_Recruiter extends StatefulWidget {
  ShowResume_Recruiter(this.email);
  String email;
  @override
  _ShowResume_Recruiter createState() => new _ShowResume_Recruiter(email);
}

class _ShowResume_Recruiter extends State<ShowResume_Recruiter> {
  _ShowResume_Recruiter(email);
  List resumes=[];
  void fetchresume() async {
    final response = await http.post("http://resumeranker.hopto.org/fetch_resumes.php",
        body: {
          "A": widget.email
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        resumes = json.decode(response.body);
        print(resumes);
      });


    }

  }
  int t=0;
  Widget build(BuildContext context) {
    if(t==0){
      fetchresume();
      t=t+1;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child:Text("resumes",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
            ),
            Icon(Icons.search, color: Colors.blue,),
            Text(' '),
            Icon(Icons.filter, color: Colors.blue,),
          ],
        ),
        actions: <Widget>[
        ],
      ),
      body: Container(
        child:ListView.builder(
            shrinkWrap: true,
            itemCount:resumes.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                child:Container(
                  child:GestureDetector(
                    onTap: () {

                    },
                    child: Card(
                      elevation: 5,
                      child:Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(resumes[index]['name']),
                            Text(resumes[index]['email']),
                            Text(resumes[index]['post']),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        )
      ),
    );
  }
}