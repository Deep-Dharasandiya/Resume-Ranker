import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
class Chart extends StatefulWidget {
  Chart(this.email);
  String email;
  @override
  _Chart createState() => new _Chart(email);
}

class _Chart extends State<Chart> {
  _Chart(email);

 abc() {
  var data = [
    new ClicksPerYear('2016', 100, Colors.red),
    new ClicksPerYear('2017', 42, Colors.yellow),
    new ClicksPerYear('2018', 100, Colors.red),
    new ClicksPerYear('2019', 100, Colors.red),
    new ClicksPerYear('2020', 42, Colors.yellow),
    new ClicksPerYear('2021', 100, Colors.red),

  ];
  var series = [
    new charts.Series(
      id: 'Clicks',
      domainFn: (ClicksPerYear clickData, _) => clickData.year,
      measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
      colorFn: (ClicksPerYear clickData, _) => clickData.color,
      data: data,
    ),
  ];
  return series;
}

  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       child:new Padding(
         padding: new EdgeInsets.all(32.0),
         child: new SizedBox(
           height: 200.0,
           child: new charts.BarChart(abc(), animate: true,),
         ),
       ),
     ),
   );
  }
}
class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
     : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}