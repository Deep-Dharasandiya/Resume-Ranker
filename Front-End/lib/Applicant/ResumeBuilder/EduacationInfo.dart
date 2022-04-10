import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Component/utils.dart';
import '../../Component/api.dart';
import '../../Component/SizeRatio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class EduacationInfo extends StatefulWidget {
  @override
  _EduacationInfo createState() => new _EduacationInfo();
}

class _EduacationInfo extends State<EduacationInfo> {
  bool loading = true;
  bool screenflag = false;
  String Email = '';
  List courses = [];
  List eduacationdata = [];
  List programdata = [];
  List coursedata = [];
  List collagedata = [];

  List yeardata = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000',
    '1999',
    '1998',
    '1997',
    '1996',
    '1995',
    '1994',
    '1993',
    '1992',
  ];
  TextEditingController per = TextEditingController();

  String get per2 => per.text;



  void initState() {
    super.initState();
    fetchdata();
  }

  String selectedprogram;
  String selectedcourse;
  String selectedcollage;
  String selectedmode, selectedstartyear=' ', selectedendyear=' ';

  void fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    setState(() {
      Email = email;
    });
    var res = await api(context, "get_courses.php", {});
    var res2 = await api(context, "get_collagename.php", {});
    fetcheduacationdata();
    //final result = ((res.map((item) => jsonEncode(item['program'])).toList()).toSet().toList()).map((item) => jsonDecode(item)).toList();
    setState(() {
      programdata = ((res.map((item) => jsonEncode(item['program'])).toList())
              .toSet()
              .toList())
          .map((item) => jsonDecode(item))
          .toList();
      collagedata = ((res2.map((item) => jsonEncode(item['name'])).toList())
              .toSet()
              .toList())
          .map((item) => jsonDecode(item))
          .toList();
      courses = res;
    });
  }

  void fetcheduacationdata() async {
    var res =
        await api(context, "get_resume_eduacation_info.php", {"A": Email});
    setState(() {
      eduacationdata = res;
      if (res.length == 0) {
        additem();
      }
      loading = false;
    });
  }

  void insertEduacationdata() async {
    var collagename;
    if (selectedprogram == 'HSC' ) {
      collagename = "No Collage";
    } else {
      collagename = selectedcollage;
    }
    if (selectedprogram == null ||
        selectedcourse == null ||
        collagename == null ||
        per2 == null ||
        selectedmode == null ||
        selectedstartyear == null ||
        selectedendyear == null ||
        imagevalid == false ||
        base64Image == null) {
      aleartdetailsrequired(context);
    } else {
      if(yearvalidator()==true){
        if(percentagevalidator(double.parse(per2),selectedmode)==true){
          setState(() {
            loading = true;
          });
          var body = {
            "A": Email,
            "B": selectedprogram,
            "C": selectedcourse,
            "D": collagename,
            "E": per2,
            "F": selectedmode,
            "G": selectedstartyear,
            "H": selectedendyear,
            "I": base64Image,
          };
          var res = await api(context, "insert_resume_eduacation.php", body);
          if (res == 1) {
            setState(() {
              screenflag = false;
            });
            fetcheduacationdata();
          }
        }else{
          aleart(context, 'Enter Valid Percentage');
        }

      }else{
        aleart(context, 'Enter Valid start & end year');
      }

    }
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

  void ondelete(var program, var course) async {
    setState(() {
      loading = true;
    });
    var body = {
      "A": Email,
      "B": program,
      "C": course,
    };
    var res = await api(context, "delete_resume_eduacation.php", body);
    if (res == 1) {
      fetcheduacationdata();
    } else {
      aleart(context, 'Server Did not Responce Try again later');
    }
  }

  void additem() {
    setState(() {
      selectedprogram = null;
      selectedcourse = null;
      selectedcollage = null;
      selectedstartyear = null;
      selectedendyear = null;
      selectedmode = null;
      per = TextEditingController(text: null);
      base64Image = null;
      imagevalid = false;
      screenflag = true;
    });
  }
 bool yearvalidator(){
   List coursedetails = courses.where((i){
     if(i['program']==selectedprogram){
       return true;
     }else{
       return false;
     }
   }).toList();
   var duration=int.parse(coursedetails[0]['duration']);
   if((int.parse(selectedendyear)-int.parse(selectedstartyear))>=duration){
     return true;
   }else{
     return false;
   }
 }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (screenflag == false ||
            (screenflag == true && eduacationdata.length == 0)) {
          return true;
        } else {
          setState(() {
            screenflag = false;
          });
          return false;
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Eduacation Details'),
          ),
          body: loading == false
              ? Center(
                  child: screenflag == false
                      ? Container(
                          child: ListView.builder(
                              padding: EdgeInsets.all(width * 0.05),
                              itemCount: eduacationdata.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedprogram =
                                          eduacationdata[index]['program'];
                                      coursedata = ((((courses.where((item) {
                                        return item['program'] ==
                                            eduacationdata[index]['program'];
                                      })).toList())
                                                  .map((item) =>
                                                      jsonEncode(item['name']))
                                                  .toList())
                                              .toSet()
                                              .toList())
                                          .map((item) => jsonDecode(item))
                                          .toList();
                                      selectedcourse =
                                          eduacationdata[index]['course'];
                                      selectedcollage =
                                          eduacationdata[index]['collage'];
                                      selectedstartyear =
                                          eduacationdata[index]['startyear'];
                                      selectedendyear =
                                          eduacationdata[index]['endyear'];
                                      selectedmode =
                                          eduacationdata[index]['mode'];
                                      per = TextEditingController(
                                          text: eduacationdata[index]
                                              ['percentage']);
                                      base64Image =
                                          eduacationdata[index]['result'];
                                      imagevalid = true;
                                      screenflag = true;
                                    });
                                  },
                                  child: Card(
                                    color: Colors.blue,
                                    margin: EdgeInsets.only(top: width*0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.all(width * 0.05),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                ondelete(
                                                    eduacationdata[index]['program'],
                                                    eduacationdata[index]['course']);
                                              },
                                              child: Icon(Icons.close,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              text(
                                                  context,
                                                  "Field : ",
                                                  Colors.white,
                                                  width * 0.05,
                                                  FontWeight.w500),
                                              text(
                                                  context,
                                                  eduacationdata[index]
                                                      ['program'],
                                                  Colors.white,
                                                  width * 0.05,
                                                  FontWeight.normal),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              text(
                                                  context,
                                                  "Course : ",
                                                  Colors.white,
                                                  width * 0.05,
                                                  FontWeight.w500),
                                              Expanded(
                                                  child: text(
                                                      context,
                                                      eduacationdata[index]
                                                          ['course'],
                                                      Colors.white,
                                                      width * 0.05,
                                                      FontWeight.normal)),
                                            ],
                                          ),
                                          eduacationdata[index]['program']!="HSC"?Row(
                                            children: [
                                              text(
                                                  context,
                                                  "College : ",
                                                  Colors.white,
                                                  width * 0.05,
                                                  FontWeight.w500),
                                              Expanded(
                                                  child: text(
                                                      context,
                                                      eduacationdata[index]
                                                          ['collage'],
                                                      Colors.white,
                                                      width * 0.05,
                                                      FontWeight.normal)),
                                            ],
                                          ):Container(),
                                          Row(
                                            children: [
                                              text(
                                                  context,
                                                  "Percentage : ",
                                                  Colors.white,
                                                  width * 0.05,
                                                  FontWeight.w500),
                                              Expanded(
                                                  child: text(
                                                      context,
                                                      eduacationdata[index]
                                                              ['percentage'] +
                                                          " / " +
                                                          eduacationdata[index]
                                                              ['mode'],
                                                      Colors.white,
                                                      width * 0.05,
                                                      FontWeight.normal)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              text(
                                                  context,
                                                  "Year : ",
                                                  Colors.white,
                                                  width * 0.05,
                                                  FontWeight.w500),
                                              Expanded(
                                                  child: text(
                                                      context,
                                                      eduacationdata[index]
                                                              ['startyear'] +
                                                          " - " +
                                                          eduacationdata[index]
                                                              ['endyear'],
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
                              }))
                      : Container(
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.05),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*Container(
                                    height: width*0.18,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(width*0.02),
                                    ),
                                    padding: EdgeInsets.all(width*0.02),
                                      child: DropdownButton(
                                        underline: SizedBox(),
                                        hint: text(
                                            context,
                                            "Select Your Feild:",
                                            Colors.black,
                                            width * 0.05,
                                            FontWeight.normal),
                                        isExpanded: true,
                                        items: programdata.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item),
                                            value: item,
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            selectedprogram = newVal;
                                            selectedcourse = null;
                                            coursedata = ((((courses.where((item) {
                                              return item['program'] == newVal;
                                            })).toList())
                                                .map((item) => jsonEncode(
                                                item['name']))
                                                .toList())
                                                .toSet()
                                                .toList())
                                                .map((item) => jsonDecode(item))
                                                .toList();
                                          });
                                        },
                                        value: selectedprogram,
                                      ),
                                  ),*/
                                  new DropdownButton(
                                    hint: text(
                                        context,
                                        "Select Your Feild:",
                                        Colors.black,
                                        width * 0.05,
                                        FontWeight.normal),
                                    isExpanded: true,
                                    items: programdata.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item),
                                        value: item,
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        selectedprogram = newVal;
                                        selectedcourse = null;
                                        coursedata = ((((courses.where((item) {
                                          return item['program'] == newVal;
                                        })).toList())
                                                    .map((item) => jsonEncode(
                                                        item['name']))
                                                    .toList())
                                                .toSet()
                                                .toList())
                                            .map((item) => jsonDecode(item))
                                            .toList();
                                      });
                                    },
                                    value: selectedprogram,
                                  ),

                                  new DropdownButton(
                                    hint: text(
                                        context,
                                        "Select Your Course:",
                                        Colors.black,
                                        width * 0.05,
                                        FontWeight.normal),
                                    isExpanded: true,
                                    items: coursedata.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item),
                                        value: item,
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        selectedcourse = newVal;
                                      });
                                    },
                                    value: selectedcourse,
                                  ),
                                  selectedprogram!='HSC' ? new DropdownButton(
                                    hint: text(
                                        context,
                                        "Select Your Collage:",
                                        Colors.black,
                                        width * 0.05,
                                        FontWeight.normal),
                                    isExpanded: true,
                                    items: collagedata.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item),
                                        value: item,
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        selectedcollage = newVal;
                                      });
                                    },
                                    value: selectedcollage,
                                  ):Container(),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButton(
                                          hint: text(
                                              context,
                                              "Start Year",
                                              Colors.black,
                                              width * 0.05,
                                              FontWeight.normal),
                                          isExpanded: true,
                                          items: yeardata.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            setState(() {
                                              selectedstartyear = newVal;
                                            });
                                          },
                                          value: selectedstartyear,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.05),
                                      Expanded(
                                        child: DropdownButton(
                                          hint: text(
                                              context,
                                              "End Year ",
                                              Colors.black,
                                              width * 0.05,
                                              FontWeight.normal),
                                          isExpanded: true,
                                          items: yeardata.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            setState(() {
                                              selectedendyear = newVal;
                                            });
                                          },
                                          value: selectedendyear,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: textField(context, 'Percentage:',
                                            TextInputType.number, false, per),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment:Alignment.bottomLeft,
                                          child: DropdownButton(
                                            hint: text(
                                                context,
                                                "   Out of ",
                                                Colors.black,
                                                width * 0.05,
                                                FontWeight.normal),
                                            items: ['10', '100'].map((item) {
                                              return new DropdownMenuItem(
                                                child: new Text(item),
                                                value: item,
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                selectedmode = newVal;
                                              });
                                            },
                                            value: selectedmode,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.03),
                                  Row(
                                    children: [
                                      text(
                                          context,
                                          "Result Copy:",
                                          Colors.black,
                                          width * 0.05,
                                          FontWeight.normal),
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
                                  Row(
                                    children: [
                                      Expanded(
                                          child: btn(
                                              context,
                                              "Save",
                                              width * 0.06,
                                              height * 0.07,
                                              width * 0.60,
                                              insertEduacationdata)),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),
                )
              : progressindicator(context),
          floatingActionButton: loading == false && screenflag == false
              ? FloatingActionButton(
                  onPressed: () {
                    additem();
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.blue,
                )
              : null,
        ),
      ),
    );
  }
}
