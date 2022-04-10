import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CertificateInfo extends StatefulWidget {
  @override
  _CertificateInfo createState() => new _CertificateInfo();
}
class  _CertificateInfo extends State<CertificateInfo > {
  void initState(){
    super. initState();
    fetchdata();
  }
  bool loading = true;
  bool screenflag = false;
  String Email='';
  List certificatedata=[];
  bool iscompleted =false;
 String selectedstartdate="dd-mm-yy",selectedenddate="dd-mm-yyyy";
  TextEditingController name =TextEditingController();
  String get name2 => name.text;


  TextEditingController des =TextEditingController();
  String get des2 => des.text;
  void fetchdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    fetchcertificatedata();
  }
  void fetchcertificatedata()async{
    var res = await api(context, "get_resume_certificate_info.php", {"A":Email});
    setState(() {
      certificatedata=res;
      if(res.length==0){
        additem();
      }
      loading=false;
    });
  }
  void insertprojectdata()async {

    if(name2 ==null  || des2==null || selectedstartdate=="dd-mm-yyyy" || selectedenddate=="dd-mm-yyyy"|| imagevalid==false || base64Image==null){
      aleartdetailsrequired(context);
    }else{
      setState(() {
        loading=true;
      });
      var body={
        "A":Email ,
        "B": name2,
        "C": des2,
        "D": selectedstartdate,
        "E": selectedenddate,
        "F": base64Image,
      };
      var res = await api(context, "insert_resume_certificate.php", body);
      if(res==1){
       fetchcertificatedata();
        setState(() {
          screenflag=false;
        });
      }else{
        aleart(context,'Server Did Not Rsponce Try again Later');
      }
    }
  }
  Future<dynamic> file;
  String base64Image='';
  String path='';
  bool imagevalid=false;

  void setimage(String p,String base64,bool flag,String msg){
    if(flag==true){
      print(path);
      setState(() {
        path=p;
        base64Image=base64;
        imagevalid=true;
      });
    }
    else{
      aleart(context,msg);
    }
  }
  void ondelete(var name)async{
    setState(() {
      loading=true;
    });
    var body={
      "A":Email,
      "B":name,
    };
    var res = await api(context, "delete_resume_certificate.php", body);
    if(res==1){
      fetchcertificatedata();
    }else{
      aleart(context,'Server Did not Responce Try again later');
    }
  }
  void additem(){
    setState(() {
      name =TextEditingController(text: null);
      iscompleted=false;
      selectedstartdate ="dd-mm-yyyy";
      selectedenddate ="dd-mm-yyyy";
      des =TextEditingController(text:null);
      base64Image=null;
      imagevalid=false;
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
          if(screenflag==false || (screenflag==true && certificatedata.length==0)){
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
          title: Text('Certificate Details'),
        ),
        body:loading==false?Center(
          child:screenflag==false?Container(
              child:ListView.builder(
                  padding: EdgeInsets.all(width * 0.05),
                  itemCount: certificatedata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap:(){
                        setState(() {
                          name =TextEditingController(text: certificatedata[index]['name']);
                          iscompleted=certificatedata[index]['completed']=='true';
                          selectedstartdate =certificatedata[index]['startdate'];
                          selectedenddate =certificatedata[index]['enddate'];
                          des =TextEditingController(text:certificatedata[index]['aboutcourse']);
                          base64Image=certificatedata[index]['certificate'];
                          imagevalid=true;
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
                                    ondelete(certificatedata[index]['name']);
                                  },
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  text(context, "Certificate Course : ", Colors.white, width * 0.05, FontWeight.w500),
                                  Expanded(child: text(context, certificatedata[index]['name'],Colors.white, width * 0.05, FontWeight.normal)),
                                ],
                              ),
                              Row(
                                children: [
                                  text(context, "About Course : ", Colors.white, width * 0.05, FontWeight.w500),
                                  Expanded(child: text(context, certificatedata[index]['aboutcourse'],Colors.white, width * 0.05, FontWeight.normal)),
                                ],
                              ),
                              Row(
                                children: [
                                  text(context, "Duration : ", Colors.white, width * 0.05, FontWeight.w500),
                                  Expanded(
                                      child: text(context, certificatedata[index]['startdate'] + " to " + certificatedata[index]['enddate'],
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
                    SizedBox(
                      height:height*0.10,
                    ),
                    textField(context,'Certificate Course:',TextInputType.text,false,name),
                    textField(context,'About Course:',TextInputType.text,false,des),
                    SizedBox(height: height*0.03),
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
                        Expanded(
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
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.03),
                    Row(
                      children: [
                        text(context,"Certificate Image:",Colors.black,width*0.05,FontWeight.normal),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: takeimage(context,setimage)),
                        SizedBox(width: width*0.05),
                        Expanded(
                          child: Container(
                            height: 100,
                            width: 100,

                            child:imagevalid==false?Icon(Icons.image, color: Colors.black,size: width*0.10,):
                            Image.memory(base64.decode(base64Image), fit: BoxFit.cover),
                          ),
                        ),
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