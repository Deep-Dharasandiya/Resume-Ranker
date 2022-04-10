import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UploadJob extends StatefulWidget {
  @override
  _UploadJob createState() => new _UploadJob();
}
class  _UploadJob extends State<UploadJob > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  String Email='';
  List post=[],skill=[];
  List jobdata=[];
  String selectedpost,selectedlocation,selectedlastdate="yyyy-mm-dd";
  List requiredskill=[];
  List que=[];
  String selectedskill,selectedlavel,selectedans;
  bool requiredskillflag=false ,queflag=false,requiredskilleditflag=false,queeditflag=false;
  int ind;

  TextEditingController no =TextEditingController();
  String get no2 => no.text;

  TextEditingController minsalary =TextEditingController();
  String get minsalary2 => minsalary.text;

  TextEditingController maxsalary =TextEditingController();
  String get maxsalary2 => maxsalary.text;

  TextEditingController other =TextEditingController();
  String get other2 => other.text;

  TextEditingController  question=TextEditingController();
  String get question2 => question.text;

  TextEditingController a =TextEditingController();
  String get a2 => a.text;

  TextEditingController b =TextEditingController();
  String get b2 => b.text;

  TextEditingController c =TextEditingController();
  String get c2 => c.text;

  TextEditingController d =TextEditingController();
  String get d2 => d.text;

  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_post.php", {});
    var res1 = await api(context, "get_skills.php", {});
    setState(() {
      post=res;
      skill=res1;
    });
    fetchjobdata();
  }
  void fetchjobdata()async{
    var res = await api(context, "get_vacancy.php", {"A":Email});
    setState(() {
      jobdata=res;
      if(res.length==0){
        additem();
      }
      loading=false;
    });
  }
  void insertjobdata()async {
    if(selectedpost ==null || selectedlocation == null || no2==null ||minsalary2==null || maxsalary2==null ||other2==null||
       selectedlastdate=="yyyy-mm-dd" ){
      aleartdetailsrequired(context);
    }else{
      setState(() {
        loading=true;
      });

      var body={
        "A":Email ,
        "B": no2,
        "C": selectedpost,
        "D":minsalary2,
        "E":maxsalary2,
        "F":other2,
        "G":selectedlastdate,
        "H":selectedlocation,
        "I":jsonEncode(requiredskill),
        "J":jsonEncode(que),
      };
      var res = await api(context, "insert_vacancy.php", body);
      if(res==1){
        fetchjobdata();
        setState(() {
          screenflag=false;
        });
      }else{
        aleart(context,'Server Did Not Rsponce Try again Later');
      }
    }

  }
  void deleterequiredskill(int index){
    setState(() {
      requiredskill.replaceRange(index,index+1,[]);
    });
  }
  void deleteque(int index){
    setState(() {
      que.replaceRange(index,index+1,[]);
    });
  }
  void insertrequiredskill(){
    if(selectedskill==null || selectedlavel==null){
      aleartdetailsrequired(context);
    }else{
      bool flag=false;
      for(int i=0;i<requiredskill.length;i++){
        if(selectedskill==requiredskill[i]['name']){
          if(i!=ind){
            flag=true;
            break;
          }

        }
      }
      if(flag==false){
        var obj = {
          'name': selectedskill,
          'lavel': selectedlavel,
        };
        setState(() {
          if(requiredskilleditflag==false){
            requiredskill.add(obj);
          }else{
            requiredskill.replaceRange(ind,ind+1,[obj]);
            ind=null;
            requiredskilleditflag=false;
          }
          requiredskillflag=false;
        });
      }else{
        aleart(context, 'Skill Already Selected');
      }
    }
  }
  void insertque(){
    if( selectedans==null || question2==null || a2==null ||b2==null ||c2==null||d2==null){
      aleartdetailsrequired(context);
    }else{
      bool flag=false;
      for(int i=0;i<que.length;i++){
        if(question2==que[i]['que']){
          if(i!=ind){
            flag=true;
            break;
          }
        }
      }
      if(flag==false){
        var obj = {
          'que': question2,
          'a': a2,
          'b': b2,
          'c': c2,
          'd': d2,
          'ans':selectedans,
        };
        setState(() {
          if(queeditflag==false){
            que.add(obj);
          }else{
            que.replaceRange(ind,ind+1,[obj]);
            ind=null;
            queeditflag=false;
          }
          queflag=false;
        });
      }else{
        aleart(context, 'Quetion Already Entered');
      }
    }
  }
  void ondelete(var post)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B":post,
    };
    var res = await api(context, "delete_vacancy.php", body);
    if(res==1){
      fetchjobdata();
    }else{
      aleart(context,'Server Did not Responce Try again later');
    }
  }
  void additem(){
    setState(() {
      selectedpost =null;
      selectedlocation =null;
      no =TextEditingController(text:null);
      minsalary =TextEditingController(text:null);
      maxsalary =TextEditingController(text:null);
      other=TextEditingController(text:null);
      selectedlastdate ="yyyy-mm-dd";
      requiredskill=[];
      que=[];
      screenflag=true;
    });
  }
  void date()async{
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDatePickerMode: DatePickerMode.day,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    setState(() {
      selectedlastdate=DateFormat('yyyy-MM-dd').format(newDateTime);
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(screenflag==false && requiredskillflag==false && queflag==false){
            return true;
          }else if(screenflag==true && requiredskillflag==false && queflag==false ){
            if(jobdata.length==0){
              return true;
            }else{
              setState(() {
                screenflag=false;
              });
              return false;
            }

          }
          else if(screenflag==true && requiredskillflag==true && queflag==false){
            setState(() {
              requiredskillflag=false;
            });
            return false;
          }else{
            setState(() {
              queflag=false;
            });
          }
        },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Upload Job'),
        ),
        body:loading==false?Center(
          child:screenflag==false?Container(
              child:ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: jobdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap:(){
                        setState(() {
                          selectedpost =jobdata[index]['post'];
                          selectedlocation=jobdata[index]['location'];
                          no =TextEditingController(text:jobdata[index]['no']);
                          minsalary =TextEditingController(text:jobdata[index]['minsalary']);
                          maxsalary =TextEditingController(text:jobdata[index]['maxsalary']);
                          other=TextEditingController(text:jobdata[index]['vacancydata']);
                          selectedlastdate =jobdata[index]['lastdate'];
                          requiredskill=jsonDecode(jobdata[index]['requiredskill']);
                          que=jsonDecode(jobdata[index]['que']);
                          screenflag=true;
                        });
                      },
                      child: Card(
                        color: Colors.blue,
                        margin: EdgeInsets.only(top:width*0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 0,
                        child:Padding(
                          padding:EdgeInsets.all(width*0.05),
                          child: Column(
                            children: [

                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    ondelete(jobdata[index]['post']);
                                  },
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                              Align(
                                alignment:Alignment.topLeft,
                                child: text2(context, jobdata[index]['post'],Colors.white, width * 0.06, FontWeight.bold),
                              ),
                              SizedBox(height: height*0.005),
                              Row(
                                children: [
                                  Icon(Icons.person,color: Colors.white,size: width*0.05,),
                                  text(context, " "+jobdata[index]['no'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              SizedBox(height: height*0.005),
                              Row(
                                children: [
                                  Icon(Icons.payments,color: Colors.white,size: width*0.05,),
                                  text(context, " "+jobdata[index]['minsalary']+" - "+jobdata[index]['maxsalary'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              SizedBox(height: height*0.005),
                              Row(
                                children: [
                                  Icon(Icons.home,color: Colors.white,size: width*0.05,),
                                  text(context, " "+jobdata[index]['location'],Colors.white, width * 0.05, FontWeight.normal),
                                ],
                              ),
                              SizedBox(height: height*0.01),
                              Align(
                                alignment:Alignment.bottomRight,
                                child: text2(context, "Apply By "+jobdata[index]['lastdate'],Colors.white, width * 0.04, FontWeight.normal),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }
              )
          ):Container(
            child:requiredskillflag==false && queflag==false?Padding(
              padding:  EdgeInsets.all(width*0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    new DropdownButton(
                      hint:  text(context,"Select Job Post:",Colors.black,width*0.05,FontWeight.normal),
                      isExpanded: true,
                      items: post.map((item){
                        return new DropdownMenuItem(
                          child:new Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (newVal){
                        setState(() {
                          selectedpost=newVal;
                        });
                      },
                      value: selectedpost,
                    ),
                    new DropdownButton(
                      hint:  text(context,"Select Job Location:",Colors.black,width*0.05,FontWeight.normal),
                      isExpanded: true,
                      items: ['Work From Home(Permanent)','Work From Home(Temporary)','At Office'].map((item){
                        return new DropdownMenuItem(
                          child:new Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (newVal){
                        setState(() {
                          selectedlocation=newVal;
                        });
                      },
                      value: selectedlocation,
                    ),
                    SizedBox(height: width*0.01),
                    textField(context,'Number Of Vacancy:',TextInputType.number,false,no),
                    textField(context,'Min Salary:',TextInputType.number,false,minsalary),
                    textField(context,'Max Salary:',TextInputType.number,false,maxsalary),
                    textField(context,'Job Requirment:',TextInputType.multiline,false,other),
                    InkWell(
                        onTap: (){date();},
                        child:Column(
                          children: [
                            Align(alignment:Alignment.topLeft,child: text(context,"Last Date:",Colors.black,width*0.05,FontWeight.normal)),
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
                                  text(context,selectedlastdate,Colors.black,width*0.05,FontWeight.normal),
                                  new Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: height*0.03),
                    Align(
                      alignment:Alignment.topLeft,
                        child: text(context,"Required Skill:",Colors.black,width*0.06,FontWeight.w600)
                    ),
                    Container(
                        child:ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                          itemCount: requiredskill.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                setState(() {
                                  selectedskill=requiredskill[index]['name'];
                                  selectedlavel=requiredskill[index]['lavel'];
                                  requiredskilleditflag=true;
                                  ind=index;
                                  requiredskillflag=true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: width*0.05),
                                child:Align(
                                  alignment:Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:text2(context, "• "+requiredskill[index]['name']+" : "+ requiredskill[index]['lavel']+" Level",Colors.black, width * 0.05,
                                            FontWeight.normal),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            deleterequiredskill(index);
                                          },
                                          child: Icon(Icons.close, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                            );
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: width*0.02),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            selectedskill=null;
                            selectedlavel=null;
                            requiredskillflag=true;
                          });
                        },
                        child:Icon(Icons.add_circle,size: width*0.10,color: Colors.blue,)
                      ),
                    ),
                    SizedBox(height: height*0.03),
                    Align(
                        alignment:Alignment.topLeft,
                        child: text(context,"Quize Question:",Colors.black,width*0.06,FontWeight.w600)
                    ),
                    Container(
                      child:ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: que.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap:(){
                                setState(() {
                                  selectedans=que[index]['ans'];
                                  question=TextEditingController(text: que[index]['que']);
                                  a=TextEditingController(text: que[index]['a']);
                                  b=TextEditingController(text: que[index]['b']);
                                  c=TextEditingController(text: que[index]['c']);
                                  d=TextEditingController(text: que[index]['d']);
                                  queeditflag=true;
                                  ind=index;
                                  queflag=true;
                                });
                              },
                              child: Card(
                                color:Colors.blue,
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
                                            deleteque(index);
                                          },
                                          child: Icon(Icons.close, color: Colors.white),
                                        ),
                                      ),
                                      Align(
                                          alignment:Alignment.topLeft,
                                          child: text(context, "Que:"+(index+1).toString()+" : "+que[index]['que'], Colors.white, width * 0.05, FontWeight.w400),
                                      ),
                                      Align(
                                        alignment:Alignment.topLeft,
                                        child: text(context, "A)  : "+que[index]['a'], Colors.white, width * 0.05, FontWeight.w400),
                                      ),
                                      Align(
                                        alignment:Alignment.topLeft,
                                        child: text(context, "B) : "+que[index]['b'], Colors.white, width * 0.05, FontWeight.w400),
                                      ),
                                      Align(
                                        alignment:Alignment.topLeft,
                                        child: text(context, "C) : "+que[index]['c'], Colors.white, width * 0.05, FontWeight.w400),
                                      ),
                                      Align(
                                        alignment:Alignment.topLeft,
                                        child: text(context, "D) : "+que[index]['d'], Colors.white, width * 0.05, FontWeight.w400),
                                      ),
                                      Align(
                                        alignment:Alignment.topLeft,
                                        child: text(context, "Answer : "+que[index]['ans'], Colors.white, width * 0.05, FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: width*0.02),
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              selectedans=null;
                              question=TextEditingController(text: null);
                              a=TextEditingController(text: null);
                              b=TextEditingController(text: null);
                              c=TextEditingController(text: null);
                              d=TextEditingController(text: null);
                              queflag=true;
                            });
                          },
                          child:Icon(Icons.add_circle,size: width*0.10,color: Colors.blue,)
                      ),
                    ),
                    SizedBox(height: height*0.03),
                    Row(
                      children: [
                        Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.60,insertjobdata)),
                      ],
                    ),

                    SizedBox(height: height*0.03),
                  ],
                ),
              ),
            ):Container(
              child:SingleChildScrollView(
                child: Column(
                  children: [
                    requiredskillflag==true?Padding(
                      padding: EdgeInsets.all(width*0.05),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new DropdownButton(
                                hint:  text(context,"Select Technical Skill:",Colors.black,width*0.05,FontWeight.normal),
                                isExpanded: true,
                                items: skill.map((item){
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
                                  Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.30,insertrequiredskill)),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ):Container(),
                    queflag==true?Padding(
                      padding: EdgeInsets.fromLTRB(width*0.05,width*0.05,width*0.05,width*0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textField(context,'Question:',TextInputType.text,false,question),
                            textField(context,'Option:A',TextInputType.text,false,a),
                            textField(context,'Option:B',TextInputType.text,false,b),
                            textField(context,'Option:C',TextInputType.text,false,c),
                            textField(context,'Option:D',TextInputType.text,false,d),
                            new DropdownButton(
                              hint:  text(context,"Select Ans.:",Colors.black,width*0.05,FontWeight.normal),
                              isExpanded: true,
                              items: ['A','B','C','D'].map((item){
                                return new DropdownMenuItem(
                                  child:new Text(item),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (newVal){
                                setState(() {
                                  selectedans=newVal;
                                });
                              },
                              value:  selectedans,
                            ),
                            SizedBox(height: height*0.03),
                            Row(
                              children: [
                                Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.30,insertque)),
                              ],
                            ),
                          ],
                        ),
                    ):Container(),
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
