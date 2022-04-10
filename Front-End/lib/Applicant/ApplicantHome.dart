import 'package:flutter/material.dart';
import 'package:flutter_app2/Applicant/JobStatus.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder.dart';
import 'package:flutter_app2/Applicant/ShowInterview.dart';
import 'package:flutter_app2/Applicant/ShowVacancy.dart';
import 'package:flutter_app2/Applicant/TechnicalSkillTest.dart';
import 'package:flutter_app2/ShowResume.dart';
import '../Component/SizeRatio.dart';
import '../Component/utils.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class ApplicantHome extends StatefulWidget {
  @override
  _ApplicantHome createState() => new _ApplicantHome();
}
class _ApplicantHome extends State<ApplicantHome> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        exitaleart(context);
        return false;
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Home'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Drawer Header'),
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      logout(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            body: Center(
                child: Container(
                    constraints: BoxConstraints.expand(),
                    child: GridView.count(
                      primary: true,
                      padding: EdgeInsets.fromLTRB(width*0.05,height*0.08, width*0.05, height*0.08),
                      crossAxisSpacing: width*0.05,
                      mainAxisSpacing: width*0.05,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ShowVacancy();
                            }));
                          },
                            child: homepagecard(context,'Apply for job',Colors.white,Colors.blue,Icons.work),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ResumeBuilder("applicant home");
                              }));
                            },
                            child: homepagecard(context,'Resume Builder',Colors.blue,Colors.white,Icons.post_add)
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return JobStatus();
                              }));
                            },
                            child: homepagecard(context,'Job Status',Colors.blue,Colors.white,Icons.person_search)
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ShowInterview();
                              }));
                            },
                            child: homepagecard(context,'Interview',Colors.white,Colors.blue,Icons.groups)
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ShowResume([],[],[],[],[],[]);
                              }));
                            },
                            child: homepagecard(context,'Resume',Colors.white,Colors.blue,Icons.description)
                        ),
                        InkWell(
                            onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                                return TechnicalSkillTest();
                              }));
                            },
                            child: homepagecard(context,'Skill Test',Colors.blue,Colors.white,Icons.quiz)
                        ),
                      ],
                    ))),
          ),
      ),
    );
  }
}