import 'dart:convert';
import 'dart:html';

import 'package:admin_app/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final storage = new FlutterSecureStorage();

  authCheck() async {
    var token = await storage.read(key: 'token');
    final headersinfo = {
      // "Content-Type": "application/json",
      // "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    print(token);
    await http
        .post(Uri.http(baseURL(), "/api/authcheck"), headers: headersinfo)
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Xin chào');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'Quản lý đưa đón học sinh')),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
      print(response.statusCode);
    }).catchError((e) {
      setState(() {
        errorSnackBar(context, 'Có lỗi');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Wrap(children: [
      Container(
          height: 80,
          width: double.infinity,
          child: MaterialButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              child: Wrap(children: [
                Text('Bắt đầu', style: TextStyle(fontSize: 22)),
                Icon(Icons.login)
              ]),
              onPressed: () {
                authCheck();
              })),
      Container(
          height: 250,
          width: double.infinity,
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
          width: double.infinity,
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
          width: double.infinity,
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
