import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Showinterviewhistory extends StatefulWidget {
  Showinterviewhistory(this.data);
  List data=[];
  @override
  _Showinterviewhistory createState() => new _Showinterviewhistory(data);
}
class  _Showinterviewhistory extends State<Showinterviewhistory > {
  _Showinterviewhistory(data);
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  List interview=[];
  void fetchdata()async{
    var res = await api(context, "get_skills.php", {});
    setState(() {
      interview=widget.data;
      //skills=res;
      loading=false;
    });

  }

  @override
  Widget build(BuildContext context) {

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Technical Skill Details'),
          ),
          body:loading==false?Center(
            child:Container(
                child:ListView.builder(
                    padding: EdgeInsets.all(width * 0.05),
                    itemCount: interview.length,
                    itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                    Expanded(child: text2(context, interview[0]['title'] ,Colors.black, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context,  interview[0]['address'],Colors.black, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, interview[0]['date'] ,Colors.black, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, interview[0]['time'] ,Colors.black, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, interview[0]['post'] ,Colors.black, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: text2(context, interview[0]['requireddocument'] ,Colors.black, width * 0.05, FontWeight.normal)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      );
                    }
                )
            )


          ):progressindicator(context),
        ),
    );
  }
}