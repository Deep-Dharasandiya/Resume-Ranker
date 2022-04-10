import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TechnicalSkillInfo extends StatefulWidget {
  @override
  _TechnicalSkillInfo createState() => new _TechnicalSkillInfo();
}
class  _TechnicalSkillInfo extends State<TechnicalSkillInfo > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  String Email='';
  String selectedskill,selectedlavel;
  List skills=[];
  List skilldata=[];

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_skills.php", {});
    setState(() {
      skills=res;
    });
    fetchskilldata();
  }
  void fetchskilldata()async{
    var res = await api(context, "get_resume_technicalskills.php", {"A":Email});
    setState(() {
      skilldata=res;
      if(res.length==0){
        additem();
      }
      loading=false;
    });
  }
  void insertskilldata()async {
    if(selectedskill ==null || selectedlavel == null ){
      aleartdetailsrequired(context);
    }else{
      setState(() {
        loading=true;
      });
      var body={
        "A":Email ,
        "B": selectedskill,
        "C": selectedlavel,
      };
      var res = await api(context, "insert_resume_technicalskills.php", body);
      if(res==1){
        fetchskilldata();
        setState(() {
          screenflag=false;
        });
      }else{
        aleart(context,'Server Did Not Rsponce Try again Later');
      }
    }

  }
  void ondelete(var skill,var lavel,var eligible)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B":skill,
      "C":lavel,
      "D":eligible,
    };
    var res = await api(context, "delete_resume_technicalskills.php", body);
    if(res==1){
      fetchskilldata();
    }else{
      aleart(context,'Server Did not Responce Try again later');
    }
  }
  void additem(){
    setState(() {
      selectedskill =null;
      selectedlavel =null;
      screenflag=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(screenflag==false || (screenflag==true && skilldata.length==0)){
            return true;
          }else{
            setState(() {
              screenflag=false;
            });
            return false;
          }
        },
     child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Technical Skill Details'),
        ),
        body:loading==false?Center(
          child:screenflag==false?Container(
              child:ListView.builder(
                  padding: EdgeInsets.all(width * 0.05),
                  itemCount: skilldata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap:(){
                        setState(() {
                          selectedskill =skilldata[index]['name'];
                          selectedlavel=skilldata[index]['lavel'];
                          screenflag=true;
                        });
                      },
                      child: Card(
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
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    ondelete(skilldata[index]['name'],skilldata[index]['lavel'],skilldata[index]['eligible']);
                                  },
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  text(context, "Skill Name : ", Colors.white, width * 0.05, FontWeight.w500),
                                  text(context, skilldata[index]['name'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              Row(
                                children: [
                                  text(context, "Skill Lavel : ", Colors.white, width * 0.05, FontWeight.w500),
                                  text(context, skilldata[index]['lavel'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }
              )
          ):Container(
            child:Padding(
              padding:  EdgeInsets.all(width*0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    new DropdownButton(
                      hint:  text(context,"Select Technical Skill:",Colors.black,width*0.05,FontWeight.normal),
                      isExpanded: true,
                      items: skills.map((item){
                        return new DropdownMenuItem(
                          child:new Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (newVal){
                        setState(() {
                         selectedskill=newVal;
                        });
                      },
                      value: selectedskill,
                    ),
                    new DropdownButton(
                      hint:  text(context,"Select Skill Lavel:",Colors.black,width*0.05,FontWeight.normal),
                      isExpanded: true,
                      items: ['Beginner','Intermediate','Professional'].map((item){
                        return new DropdownMenuItem(
                          child:new Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (newVal){
                        setState(() {
                          selectedlavel=newVal;
                        });
                      },
                      value: selectedlavel,
                    ),
                    SizedBox(height: height*0.03),
                    Row(
                      children: [
                        Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.60,insertskilldata)),
                      ],
                    ),

                    SizedBox(height: height*0.03),
                  ],
                ),
              ),
            ),
          ),

        ):progressindicator(context),
        floatingActionButton: loading==false && screenflag==false?FloatingActionButton(
          onPressed: () {
            additem();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ):null,
      ),
     ),
    );
  }
}