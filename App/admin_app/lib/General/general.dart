import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// const String baseURL = "http://localhost:8000/api/"; //emulator localhost
const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(milliseconds: 1400),
  ));
}

successSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(text),
    duration: const Duration(milliseconds: 1400),
  ));
}

baseURL() {
  return "localhost:8000";
}

dMY(String ymd) {
  var temp = DateFormat('y-M-d').parse(ymd);
  return DateFormat('d/M/y').format(temp);
}

yMD(String ymd) {
  DateTime temp = DateFormat('y-M-d').parse(ymd);
  // return DateFormat('y/M/d').format(temp);
  String day = temp.day.toString();
  String month = temp.month.toString();
  if (temp.day < 10) day = '0' + temp.day.toString();
  if (temp.month < 10) month = '0' + temp.month.toString();
  return temp.year.toString() + '/' + month + '/' + day;
}
