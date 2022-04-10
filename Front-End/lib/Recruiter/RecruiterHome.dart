import 'package:flutter/material.dart';
import 'package:flutter_app2/Applicant/ResumeBuilder.dart';
import 'package:flutter_app2/Recruiter/ApplyedApplicant.dart';
import 'package:flutter_app2/Recruiter/Interview.dart';
import 'package:flutter_app2/Recruiter/UploadJob.dart';
import '../Component/SizeRatio.dart';
import '../Component/utils.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class RecruiterHome extends StatefulWidget {
  @override
  _RecruiterHome createState() => new _RecruiterHome();
}
class _RecruiterHome extends State<RecruiterHome> {
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
            actions: <Widget>[],
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
                            return UploadJob();
                          }));
                        },
                        child: homepagecard(context,'Upload Job',Colors.white,Colors.blue,Icons.work),
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ApplyedApplicant();
                            }));
                          },
                          child: homepagecard(context,'Applyed',Colors.blue,Colors.white,Icons.post_add)
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return Interview();
                            }));
                          },
                          child: homepagecard(context,'Interview',Colors.blue,Colors.white,Icons.query_builder)
                      ),
                     /* InkWell(
                          onTap: (){

                          },
                          child: homepagecard(context,'Result',Colors.white,Colors.blue,Icons.emoji_events)
                      ),*/

                    ],
                  ))),
        ),
      ),
    );
  }
}