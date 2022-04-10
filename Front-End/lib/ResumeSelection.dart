import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResumeSelection extends StatefulWidget {
  ResumeSelection(this.email);
  String email;
  @override
  _ResumeSelection createState() => new _ResumeSelection(email);
}

class _ResumeSelection extends State<ResumeSelection> {
  _ResumeSelection(email);
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }
}