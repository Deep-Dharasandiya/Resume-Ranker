

import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ExperienceInfo extends StatefulWidget {
  @override
  _ExperienceInfo createState() => new _ExperienceInfo();
}
class  _ExperienceInfo extends State<ExperienceInfo > {
  void initState() {
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  String Email='';
  List company=[];
  List post=[];
  List experiencedata=[];
  String selectedpost,selectedcompany;
  bool iscompleted =false,isintern=false;
  String selectedstartmonth="yyyy-mm",selectedendmonth="yyyy-mm";
  String duaration="00:00";


  TextEditingController des =TextEditingController();
  String get des2 => des.text;

  void fetchdata()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_post.php", {});
    var res1 = await api(context, "get_company.php", {});
    setState(() {
      company=res1;
      post=res;
    });
    fetchexperiencedata();
  }
  void fetchexperiencedata()async{
    var res = await api(context, "get_resume_experiences_info.php", {"A":Email});
    setState(() {
      experiencedata=res;
      if(res.length==0){
        additem();
      }
    });
    duarationcalculator();
    setState(() {
      loading=false;
    });
  }
  void insertexperiencedata()async {
    var enddate='';
    if(iscompleted==true){
      enddate=selectedendmonth;
    }
    else{
      enddate='Present';
    }
   if(selectedcompany ==null || selectedpost == null || des2==null || selectedstartmonth=="mm-yyyy" || base64Image==null ||imagevalid==false){
     aleartdetailsrequired(context);
   }else{
     if(monthvalidator(selectedstartmonth,selectedendmonth,iscompleted)==true){
       setState(() {
         loading=true;
       });
       var body={
         "A":Email ,
         "B": iscompleted.toString(),
         "C": isintern.toString(),
         "D": selectedpost,
         "E": selectedcompany,
         "F": selectedstartmonth,
         "G": enddate,
         "H": des2,
         "I":base64Image,
       };
       var res = await api(context, "insert_resume_experiences.php", body);
       if(res==1){
         fetchexperiencedata();
         setState(() {
           screenflag=false;
         });
       }else{
         aleart(context,'Server Did Not Rsponce Try again Later');
       }
     }else{
       aleart(context,'Enter valid Month');
     }

   }

  }
  void ondelete(var company,var post)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B":company,
      "C":post,
    };
    var res = await api(context, "delete_resume_experience.php", body);
    if(res==1){
      fetchexperiencedata();
    }else{
      aleart(context,'Server Did not Responce Try again later');
    }
  }
  void additem(){
    setState(() {
      selectedcompany=null;
      selectedpost=null;
      iscompleted=false;
      isintern=false;
      selectedstartmonth='yyyy-mm';
      selectedendmonth='yyyy-mm';
      des =TextEditingController(text:null);
      screenflag=true;
      imagevalid=false;
      base64Image='';
    });
  }
  void duarationcalculator(){
    int month=0;
    for(int i=0;i<experiencedata.length;i++){
      var end;
      var start =experiencedata[i]['startmonth'].split("-");
      if(experiencedata[i]['endmonth']!="Present"){
         end =experiencedata[i]['endmonth'].split("-");
      }else{
        end =(DateFormat('yyyy-MM').format(DateTime.now())).split("-");
      }
       month=month+((int.parse(end[0])-int.parse(start[0])).abs()*12)+(int.parse(start[1])-int.parse(end[1])).abs();
    }
    print(month);
   setState(() {
     duaration="Total:"+((month/12).toStringAsFixed(0)).toString()+"Year & "+(month%12).toString()+"Month";
   });
  }
  void month(var a)async{
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDatePickerMode: DatePickerMode.day,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    setState(() {
      if(a=='start'){
        selectedstartmonth= DateFormat('yyyy-MM').format(newDateTime);
      }else{
        selectedendmonth=DateFormat('yyyy-MM').format(newDateTime);
      }
    });
  }
  Future<dynamic> file;
  String base64Image = '';
  String path = '';
  bool imagevalid = false;

  void setimage(String p, String base64, bool flag, String msg) {
    if (flag == true) {
      print(path);
      setState(() {
        path = p;
        base64Image = base64;
        imagevalid = true;
      });
    } else {
      aleart(context, msg);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(screenflag==false || (screenflag==true && experiencedata.length==0)){
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
          title: Text('Experiences Details'),
        ),
        body:loading==false?Center(
          child:screenflag==false?Container(
              child:Padding(
                padding: EdgeInsets.only(top:width*0.05),
                child: Column(
                   children: [
                     text(context, duaration, Colors.black, width * 0.05, FontWeight.w500),
                     ListView.builder(
                         primary: false,
                         shrinkWrap: true,
                         padding: EdgeInsets.all(width*0.05),
                         itemCount: experiencedata.length,
                         itemBuilder: (BuildContext context, int index) {
                           return InkWell(
                             onTap:(){
                               setState(() {
                                 selectedcompany=experiencedata[index]['company'];
                                 selectedpost=experiencedata[index]['post'];
                                 iscompleted=experiencedata[index]['completed']=='true';
                                 isintern=experiencedata[index]['intern']=='true';
                                 selectedstartmonth =experiencedata[index]['startmonth'];
                                 selectedendmonth =experiencedata[index]['endmonth'];
                                 des =TextEditingController(text:experiencedata[index]['description']);
                                 base64Image= experiencedata[index]['joblatter'];
                                 imagevalid=true;
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
                                 padding: EdgeInsets.all(width * 0.05),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Align(
                                       alignment: Alignment.topRight,
                                       child: InkWell(
                                         onTap: () {
                                           ondelete(experiencedata[index]['company'],experiencedata[index]['post']);
                                         },
                                         child: Icon(Icons.close,
                                             color: Colors.white),
                                       ),
                                     ),
                                     Row(
                                       children: [
                                         text(context, "Job Title : ", Colors.white, width * 0.05, FontWeight.w500),
                                         Expanded(child: text(context, experiencedata[index]['post'],Colors.white, width * 0.05, FontWeight.normal)),
                                       ],
                                     ),
                                     Row(
                                       children: [
                                         text(context, "Company Name : ", Colors.white, width * 0.05, FontWeight.w500),
                                         Expanded(child: text(context, experiencedata[index]['company'],Colors.white, width * 0.05, FontWeight.normal)),
                                       ],
                                     ),
                                     Row(
                                       children: [
                                         text(context, "Description : ", Colors.white, width * 0.05, FontWeight.w500),
                                         Expanded(child: text(context,  experiencedata[index]['description'],Colors.white, width * 0.05, FontWeight.normal)),
                                       ],
                                     ),
                                     experiencedata[index]['intern']=='true' ?Row(
                                       children: [
                                         text(context, "Job Type : ", Colors.white, width * 0.05, FontWeight.w500),
                                         text(context, "InternShip",Colors.white, width * 0.05, FontWeight.normal),
                                       ],
                                     ):Container(),
                                     Row(
                                       children: [
                                         text(context, "Duration : ", Colors.white, width * 0.05, FontWeight.w500),
                                         Expanded(
                                             child: text(context, experiencedata[index]['startmonth'] + " to " + experiencedata[index]['endmonth'],
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
                   ],
                ),
              ),
          ):Container(
            child:Padding(
              padding:  EdgeInsets.all(width*0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    new DropdownButton(
                      hint:  text(context,"Select Your Company:",Colors.black,width*0.05,FontWeight.normal),
                      isExpanded: true,
                      items: company.map((item){
                        return new DropdownMenuItem(
                          child:new Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (newVal){
                        setState(() {
                          selectedcompany=newVal;
                        });
                      },
                      value: selectedcompany,
                    ),
                    new DropdownButton(
                      hint: text(context,"Select Your Post:",Colors.black,width*0.05,FontWeight.normal),
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
                    textField(context,'Description:',TextInputType.multiline,false,des),
                    Row(
                      children: [
                        Checkbox(
                          value: isintern,
                          onChanged: (bool value) {
                            setState(() {
                              isintern = value;
                            });
                          },
                        ),
                        Expanded(child: text(context,"As a Intern",Colors.black,width*0.05,FontWeight.normal)),
                      ],
                    ),
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
                        Expanded(child: text(context,"Completed",Colors.black,width*0.05,FontWeight.normal)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){month('start');},
                            child:Column(
                              children: [
                                Align(alignment:Alignment.topLeft,child: text(context,"Start Month:",Colors.black,width*0.05,FontWeight.normal)),
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
                                      text(context,selectedstartmonth,Colors.black,width*0.05,FontWeight.normal),
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
                            onTap: (){month('end');},
                            child:Column(
                              children: [
                                Align(alignment:Alignment.topLeft,child: text(context,"End Month:",Colors.black,width*0.05,FontWeight.normal)),
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
                                      text(context,selectedendmonth,Colors.black,width*0.05,FontWeight.normal),
                                      new Icon(Icons.calendar_today),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ):Expanded(child: Container()),

                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      children: [
                        iscompleted==true?text(context, "Experience Latter", Colors.black, width * 0.05, FontWeight.normal):
                        text(context, "Joining Latter:", Colors.black, width * 0.05, FontWeight.normal),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: takeimage(context, setimage)),
                        SizedBox(width: width * 0.05),
                        Expanded(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: imagevalid == false
                                ? Icon(
                              Icons.image,
                              color: Colors.black,
                              size: width * 0.10,
                            )
                                : Image.memory(
                                base64.decode(base64Image),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),

                    SizedBox(height: height*0.03),
                    Row(
                      children: [
                        Expanded(child: btn(context,"Save",width*0.06,height*0.07,width*0.60,insertexperiencedata)),
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