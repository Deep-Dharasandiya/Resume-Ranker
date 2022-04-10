import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'Quize.dart';
import 'Home.dart';

class TechnicalSkills extends StatefulWidget {
  TechnicalSkills(this.email);
  String email;
  @override
  _TechnicalSkills createState() => _TechnicalSkills(email);
}

class _TechnicalSkills extends State<TechnicalSkills> {
  _TechnicalSkills(email);
  bool home=true,Mainloader=true,update=false;
  double leval=0;
  List skill_names=[],skill_selected=[];
  String Skill,id,skill_level,ID;

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
                    return Home(widget.email);
                  }));
                },
              )
            ],
          );
        });
  }

  int skillchecker(String name){
    int count=0;
    for(int i=0;i<skill_selected.length;i++){
      if(name==skill_selected[i]['name']){
        count=count+1;
      }
    }
    if(count==0){
      return 1;
    }
    else{
      return 0;
    }

  }

  void fetchskillsname()async{
    final response4 = await http.get(
        'http://resumeranker.hopto.org/skill_getdata.php');
    if (response4.statusCode == 200) {
      setState(() {
        skill_names = json.decode(response4.body);
      });
      fetchtechnicalskill();
    }
    else{
      error();
    }
  }

  void deleteskill(String d)async{
    setState(() {
      Mainloader=true;
    });
    final response = await http.post(
        "http://resumeranker.hopto.org/delete_resume_technicalskills.php",
        body: {
          "A": d,
        }
    );
    if (response.statusCode == 200) {
      if(json.decode(response.body)==1){
        fetchtechnicalskill();
      }
    }
    else{
      setState(() {
        Mainloader=false;
      });
      error();
    }
  }

  void fetchtechnicalskill() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/get_resume_technicalskills.php",
        body: {
          "A": widget.email,
        }
    );

    if (response.statusCode == 200) {
      setState(() {
        skill_selected = json.decode(response.body);
          Mainloader=false;
          home=true;
      });
    }
    else{
      error();
    }
  }

  void setval(){
    if(leval==1){
      skill_level="Beginner";
    }
    if(leval==2){
      skill_level="Intermediate";
    }
    if(leval==3){
      skill_level="Professional";
    }
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Quize(widget.email,Skill,skill_level,ID);
    }));


  }

  void insert_person_info() async {
    final response = await http.post(
        "http://resumeranker.hopto.org/insert_resume_technicalskills.php",
        body: {
          "A": widget.email,
          "B":Skill,
          "C":skill_level,
          "D":ID,
        }
    );
    if (response.statusCode == 200) {
      setState(() {

      });
      if(json.decode(response.body)==1){
        setState(() {
          Mainloader=true;
        });
        fetchtechnicalskill();
      }
    }
    else{
      setState(() {
        Mainloader=true;
      });
      error();
    }
  }

  void updateskill(String s,skillname,level){
    setState(() {
      ID=s;
      Skill=skillname;
    });
    if(level=='Beginner'){
    leval=1;
    }else if(level=='Intermediate'){
      leval=2;
    }else{
      leval=3;
    }
    setState(() {
      home=false;
    });
  }

  int t=0;
  @override
  Widget build(BuildContext context) {
    if(t==0){
      fetchskillsname();

      t=t+1;
    }
    return WillPopScope(
        onWillPop: () async {
          if(home==false){
            setState(() {
              home=true;
            });
            return false;
          }
          else{
            return true;
          }
        },
     child:Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child:Text("Skills",style: TextStyle(color: Colors.black, fontFamily: 'design.graffiti.comicsansms'),),
            ),

            home==true? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child:Text("Done",style: TextStyle(color: Colors.blueGrey, fontFamily: 'design.graffiti.comicsansms'),),
            ):Container(),
          ],
        ),
      ),
      body: Mainloader==false?Center(
        child: home==false?Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child:Container(
                      padding: new EdgeInsets.fromLTRB(10,10.0,10,10),
                    child: Column(
                      children: <Widget>[
                        new DropdownButton(
                          isExpanded: true,
                          hint: new Text('Skill Name:'),
                          items: skill_names.map((item){
                            return new DropdownMenuItem(
                              child:new Text(item['skills_name']),
                              value: item['skills_name'].toString(),
                            );

                          }).toList(),
                          onChanged: (newVal){
                            if(update==false){
                              setState(() {
                                Skill=newVal;
                              });
                            }
                            else{
                              Show_Aleart(context, "Can't Update Skill Name...");
                            }

                          },
                          value: Skill,

                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.blue[700],
                            inactiveTrackColor: Colors.blue[100],
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: Colors.blueAccent,
                            overlayColor: Colors.blue.withAlpha(32),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.blue[700],
                            inactiveTickMarkColor: Colors.blue[100],
                            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.blueAccent,
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            value: leval,
                            min: 0,
                            max: 3,
                            divisions: 3,
                            label: '$leval',
                            onChanged: (value) {
                              setState(
                                    () {
                                  leval = value;
                                },
                              );
                            },
                          ),
                        ),
                        leval==1?Text("Begginer",style: new TextStyle(fontSize:15,color: Colors.blue),):
                        leval==2?Text("Intermidiate",style: new TextStyle(fontSize:15,color: Colors.blue),):
                        leval==3?Text("Professional",style: new TextStyle(fontSize:15,color: Colors.blue),):Text("Select Skill Leval...",style: new TextStyle(fontSize:15,color: Colors.blue),),
                      ],
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
                    if(Skill=='' || leval==0 ){
                      Show_Aleart(context, "Enter Both Details");
                    }
                    else{
                      if(skillchecker(Skill)==1 || update==true){
                        setval();
                      }
                      else{
                        Show_Aleart(context, "Skill Already Taken...");
                      }
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
              ]
          ):Stack(
            children: <Widget>[
              Container(
                child:Stack(
                  children: <Widget>[
                    skill_selected.length !=0 ? ListView.builder(
                      itemCount: skill_selected.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(

                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          //elevation: 3.0,

                          child: new Container(
                            child:SingleChildScrollView(
                              padding: EdgeInsets.all(5),
                              child:Container(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(skill_selected[index]['name'],style: new TextStyle(fontSize:18,color: Colors.black),),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(skill_selected[index]['lavel'],style: new TextStyle(fontSize:18,color: Colors.black),),
                                      ],
                                    ),

                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child:  FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                update=true;
                                              });
                                              updateskill(skill_selected[index]['id'],skill_selected[index]['name'],skill_selected[index]['lavel']);
                                            },
                                            child:  new Icon(Icons.update , size: 25,color: Colors.blue,),
                                          ),
                                        ),

                                        Expanded(
                                          child:  FlatButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Conformation'),
                                                      content: Text(
                                                          'Are You Sure, You Want To Delete This Vacancy... '),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                          child: new Text('Yes'),
                                                          onPressed: () {
                                                            deleteskill(skill_selected[index]['id']);
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
                                            },
                                            child:  new Icon(Icons.delete_outline , size: 25,color: Colors.blue,),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),

                              ),
                            ),
                          ),
                        );
                      },
                    ):Container(
                      child:Center(
                        child:Text("Plese Add Skills.."),
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: FloatingActionButton(
                          onPressed:(){
                            String temp;
                             setState(() {
                               update=false;
                               leval=0;
                               Skill=temp;
                               ID='0';
                               home=false;
                             });
                          },
                          tooltip: 'Add Vacancy',
                          child: new Icon(Icons.add,size: 30),
                        ),//Your widget here,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ):Center(
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
    );
  }
}