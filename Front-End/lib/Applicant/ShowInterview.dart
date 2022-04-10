import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ShowInterview extends StatefulWidget {
  @override
  _ShowInterview createState() => new _ShowInterview();
}
class  _ShowInterview extends State<ShowInterview > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  String Email='';
  List interview=[];

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_interview_detailes_applicant.php", {"A":Email});
    setState(() {
      interview=res;
      loading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Interview'),
          ),
          body:loading==false?Center(
            child:Container(
                child:interview.length!=0?ListView.builder(
                    padding: EdgeInsets.all(width * 0.05),
                    itemCount: interview.length,
                    itemBuilder: (BuildContext context, int index) {
                      return  Card(
                          color:Colors.blue,
                          margin: EdgeInsets.only(top:width*0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 0,
                          child:Padding(
                            padding: EdgeInsets.all(width*0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Compny Name : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, "TCS",Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Title : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, interview[index]['title'],Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Location : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, interview[index]['address'],Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Date : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, interview[index]['date'],Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Time : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, interview[index]['time'],Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Required Document : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, interview[index]['requireddocument'],Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, "Remark : ", Colors.white, width * 0.05, FontWeight.w500)),
                                    Expanded(child: text2(context, interview[index]['remark'],Colors.white, width * 0.05, FontWeight.normal)),
                                  ],
                                ),

                              ],
                            ),
                          ),
                      );
                    }
                ):Row(
                  children: [
                    Expanded(child: text2(context, "Wait for Schedual", Colors.black, width * 0.05, FontWeight.w500)),
                  ],
                ),
            ),

          ):progressindicator(context),
        ),
    );
  }
}