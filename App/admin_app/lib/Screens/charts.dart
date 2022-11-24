import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Wrap(children: [
      Container(
          height: 250,
          width: 600,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Transform.scale(
              scale: 1.5,
              child: PieChart(
                PieChartData(
                  sections: data,
                  centerSpaceRadius: 25,
                ), // Optional
                swapAnimationCurve: Curves.linear,
              ))),
      Container(
          height: 250,
          width: 600,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Transform.scale(
              scale: 1.5,
              child: PieChart(
                PieChartData(
                  sections: data,
                  centerSpaceRadius: 25,
                ), // Optional
                swapAnimationCurve: Curves.linear,
              ))),
      Container(
          height: 250,
          width: 600,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Transform.scale(
              scale: 1.5,
              child: PieChart(
                PieChartData(
                  sections: data,
                  centerSpaceRadius: 25,
                ), // Optional
                swapAnimationCurve: Curves.linear,
              ))),
    ])));
  }
}

List<PieChartSectionData> data = [
  PieChartSectionData(
      title: "Chưa: 10",
      color: Colors.orangeAccent,
      value: 10,
      titleStyle:
          TextStyle(backgroundColor: Colors.orangeAccent, color: Colors.white),
      titlePositionPercentageOffset: 1),
  PieChartSectionData(
      title: "Đang: 1",
      color: Colors.green,
      value: 1,
      titleStyle: TextStyle(backgroundColor: Colors.green, color: Colors.white),
      titlePositionPercentageOffset: 1),
  PieChartSectionData(
      title: "Kết thúc: 20",
      color: Colors.blueAccent,
      value: 20,
      titleStyle:
          TextStyle(backgroundColor: Colors.blueAccent, color: Colors.white),
      titlePositionPercentageOffset: 1),
];
