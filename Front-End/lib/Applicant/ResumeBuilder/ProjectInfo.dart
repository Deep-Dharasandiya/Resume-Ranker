import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProjectInfo extends StatefulWidget {
  @override
  _ProjectInfo createState() => new _ProjectInfo();
}
class  _ProjectInfo extends State<ProjectInfo > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  String Email='';
  List projectdata=[];
  bool iscompleted =false;
 String selectedstartdate="dd-mm-yyyy",selectedenddate="dd-mm-yyyy";
  TextEditingController title =TextEditingController();
  String get title2 => title.text;

  TextEditingController repo =TextEditingController();
  String get repo2 => repo.text;

  TextEditingController des =TextEditingController();
  String get des2 => des.text;
  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    fetchprojectdata();
  }
  void fetchprojectdata()async{
    var res = await api(context, "get_resume_project_info.php", {"A":Email});
    setState(() {
      projectdata=res;
      if(res.length==0){
        additem();
      }
      loading=false;
    });
  }
  void insertprojectdata()async {
    var enddate='';
    if(iscompleted==true){
      enddate=selectedenddate;
    }
    else{
      enddate='Present';
    }
    if(title2 ==null || repo2 == null || des2==null || selectedstartdate=="dd-mm-yyyy" ){
      aleartdetailsrequired(context);
    }else{
      setState(() {
        loading=true;
      });
      var body={
        "A":Email ,
        "B": iscompleted.toString(),
        "C": title2,
        "D": repo2,
        "E": des2,
        "F": selectedstartdate,
        "G": enddate,
      };
      var res = await api(context, "insert_resume_projects.php", body);
      if(res==1){
        fetchprojectdata();
        setState(() {
          screenflag=false;
        });
      }else{
        aleart(context,'Server Did Not Rsponce Try again Later');
      }
    }

  }

  void ondelete(var title)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B":title,
    };
    var res = await api(context, "delete_resume_project.php", body);
    if(res==1){
      fetchprojectdata();
    }else{
      aleart(context,'Server Did not Responce Try again later');
    }
  }
  void additem(){
    setState(() {
      title =TextEditingController(text: null);
      repo =TextEditingController(text: null);
      iscompleted=false;
      selectedstartdate ="dd-mm-yyyy";
      selectedenddate ="dd-mm-yyyy";
      des =TextEditingController(text:null);
      screenflag=true;
    });
  }
  void date(var a)async{
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDatePickerMode: DatePickerMode.day,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    setState(() {
      if(a=='start'){
        selectedstartdate= (newDateTime.day).toString()+"-"+(newDateTime.month).toString()+"-"+(newDateTime.year).toString();
      }else{
        selectedenddate=(newDateTime.day).toString()+"-"+(newDateTime.month).toString()+"-"+(newDateTime.year).toString();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(screenflag==false || (screenflag==true && projectdata.length==0)){
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
          title: Text('Project Details'),
        ),
        body:loading==false?Center(
          child:screenflag==false?Container(
              child:ListView.builder(
                  padding:  EdgeInsets.all(width*0.05),
                  itemCount: projectdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap:(){
                        setState(() {
                          title =TextEditingController(text: projectdata[index]['title']);
                          repo =TextEditingController(text: projectdata[index]['repo']);
                          iscompleted=projectdata[index]['completed']=='true';
                          selectedstartdate =projectdata[index]['startdate'];
                          selectedenddate =projectdata[index]['enddate'];
                          des =TextEditingController(text:projectdata[index]['aboutproject']);
                          screenflag=true;
                        });
                      },
                      child: Card(
                        color: Colors.blue,
                        margin: EdgeInsets.only(top: width*0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 0,
                        child:Padding(
                          padding: EdgeInsets.all(width*0.05),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    ondelete(projectdata[index]['title']);
                                  },
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  text(context, "Project Title : ", Colors.white, width * 0.05, FontWeight.w500),
                                  text(context, projectdata[index]['title'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              Row(
                                children: [
                                  text(context, "GitHub Link : ", Colors.white, width * 0.05, FontWeight.w500),
                                  text(context, projectdata[index]['repo'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              Row(
                                children: [
                                  text(context, "About Project: ", Colors.white, width * 0.05, FontWeight.w500),
                                  text(context, projectdata[index]['aboutproject'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              Row(
                                children: [
                                  text(context, "Duration : ", Colors.white, width * 0.05, FontWeight.w500),
                                  Expanded(
                                      child: text(context, projectdata[index]['startdate'] + " - " + projectdata[index]['enddate'],
                                          Colors.white,
                                          width * 0.05,
                                          FontWeight.normal)),
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
                    textField(context,'Project Title:',TextInputType.text,false,title),
                    textField(context,'Project Git Repo.:',TextInputType.text,false,repo),
                    textField(context,'About Project:',TextInputType.text,false,des),
                    Row(
                      children: [
                        Checkbox(
                          value: iscompleted,
                          onChanged: (bool value) {
                            setState(() {
                              iscompleted = value;
                            });
                          },
                        ),
                        Expanded(child: text(context,"Project Completed",Colors.black,width*0.05,FontWeight.normal)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){date('start');},
                            child:Column(
                              children: [
                                Align(alignment:Alignment.topLeft,child: text(context,"Start Date:",Colors.black,width*0.05,FontWeight.normal)),
                                Container(
                                  height: height*0.05,
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(width*0.01),
                                    border:Border.all(color: Colors.black),
                                  ),

                                  margin:EdgeInsets.only(top:width*0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      text(context,selectedstartdate,Colors.black,width*0.05,FontWeight.normal),
                                      new Icon(Icons.calendar_today),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: width*0.03),
                        iscompleted==true?Expanded(
                          child: InkWell(
                            onTap: (){date('end');},
                            child:Column(
                              children: [
                                Align(alignment:Alignment.topLeft,child: text(context,"End Date:",Colors.black,width*0.05,FontWeight.normal)),
                                Container(
                                  height: height*0.05,
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(width*0.01),
                                    border:Border.all(color: Colors.black),
                                  ),

                                  margin:EdgeInsets.only(top:width*0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      text(context,selectedenddate,Colors.black,width*0.05,FontWeight.normal),
                                      new Icon(Icons.calendar_today),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ),
                        )
                            :Expanded(child: Container()),
                      ],
                    ),
                    SizedBox(height: height*0.03),
                    Row(
                      children: [
                        Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.60,insertprojectdata)),
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