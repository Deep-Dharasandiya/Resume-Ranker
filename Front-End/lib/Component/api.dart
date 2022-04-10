import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils.dart';

var domain="http://192.168.190.189/";
Future<dynamic> api(BuildContext context,String name,Object body,) async {
  if(await networkcheck(context)==true) {
    final response = await http.post(domain + name,
        body: body
    );
    return Future<dynamic>.value(json.decode(response.body));
  }else{
    return Future<dynamic>.value(false);
  }
}