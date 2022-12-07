import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewLineTypeScreen extends StatefulWidget {
  const NewLineTypeScreen({Key? key}) : super(key: key);

  @override
  _NewLineTypeScreenState createState() => _NewLineTypeScreenState();
}

class _NewLineTypeScreenState extends State<NewLineTypeScreen> {
  String _linetype_name = '';
  int _is_back = 0;
  String _time_start = '';
  String _time_end = '';
  int _mon = 1;
  int _tue = 1;
  int _wed = 1;
  int _thu = 1;
  int _fri = 1;
  int _sat = 0;
  int _sun = 0;
  TimeOfDay time = TimeOfDay.now();
  var picked;

  List isback_list = [
    {'tag': 'Đi', 'value': 0},
    {'tag': 'Về', 'value': 1},
  ];

  List choose_list = [
    {'tag': 'Có', 'value': 1},
    {'tag': 'Không', 'value': 0},
  ];

  var _chosenDate = DateTime.now();

  newLineType() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'linetype_name': _linetype_name.toString(),
      'is_back': _is_back.toString(),
      'time_start': _time_start.toString(),
      'time_end': _time_end.toString(),
      'mon': _mon.toString(),
      'tue': _tue.toString(),
      'wed': _wed.toString(),
      'thu': _thu.toString(),
      'fri': _fri.toString(),
      'sat': _sat.toString(),
      'sun': _sun.toString(),
    };
    await http
        .post(Uri.http(baseURL(), "/api/newLineType", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Thêm mới thành công');
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        errorSnackBar(context, jsonDecode(response.body).values.first);
      } else {
        errorSnackBar(context, 'Thêm mới thất bại');
      }
    }).catchError((e) {
      setState(() {
        errorSnackBar(context, 'Thêm mới thất bại');
      });
    });
  }

  Future<Null> selectTime(BuildContext context, int startorend) async {
    picked = await showTimePicker(context: context, initialTime: time);

    if (picked != null) {
      setState(() {
        time = picked;
        String tempHour = time.hour.toString();
        String tempMinute = time.minute.toString();
        if (time.hour < 10) tempHour = '0' + picked.hour.toString();
        if (time.minute < 10) tempMinute = '0' + picked.minute.toString();
        if (startorend == 0) {
          _time_start = tempHour + ':' + tempMinute;
        } else
          _time_end = tempHour + ':' + tempMinute;
      });
    }
  }

  @override
  Widget build(BuildContext) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Thêm loại tuyến',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Column(children: [
                  Text('Loại:',
                      style: TextStyle(fontSize: 17, color: Colors.blueAccent)),
                  DropdownButton(
                      items: isback_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _is_back,
                      onChanged: (newValue) {
                        setState(() {
                          _is_back = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('T2:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _mon,
                      onChanged: (newValue) {
                        setState(() {
                          _mon = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('T3:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _tue,
                      onChanged: (newValue) {
                        setState(() {
                          _tue = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('T4:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _wed,
                      onChanged: (newValue) {
                        setState(() {
                          _wed = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('T5:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _thu,
                      onChanged: (newValue) {
                        setState(() {
                          _thu = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('T6:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _fri,
                      onChanged: (newValue) {
                        setState(() {
                          _fri = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('T7:',
                      style: TextStyle(fontSize: 17, color: Colors.redAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _sat,
                      onChanged: (newValue) {
                        setState(() {
                          _sat = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
                Column(children: [
                  Text('CN:',
                      style: TextStyle(fontSize: 17, color: Colors.redAccent)),
                  DropdownButton(
                      items: choose_list.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['value'],
                            child: Text(valueItem['tag'].toString()));
                      }).toList(),
                      value: _sun,
                      onChanged: (newValue) {
                        setState(() {
                          _sun = int.tryParse(newValue.toString())!;
                        });
                      }),
                ]),
              ]),
              Wrap(children: [
                MaterialButton(
                    onPressed: () {
                      selectTime(context, 0);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text('Giờ khởi hành')),
                Text(_time_start, style: TextStyle(fontSize: 19)),
              ]),
              Wrap(children: [
                MaterialButton(
                    onPressed: () {
                      selectTime(context, 1);
                    },
                    color: Colors.orangeAccent,
                    textColor: Colors.white,
                    child: Text('Giờ kết thúc')),
                Text(_time_end, style: TextStyle(fontSize: 19)),
              ]),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập tên loại tuyến*',
                ),
                onChanged: (value) {
                  _linetype_name = value;
                },
              ),
              MaterialButton(
                  onPressed: () {
                    newLineType();
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text('Thêm mới')),
            ])),
      ),
      RoundedButton(
          btnText: '⬅',
          onBtnPressed: () {
            Navigator.pop(context, true);
          })
    ]);
  }
}
