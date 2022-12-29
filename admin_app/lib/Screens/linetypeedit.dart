import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class EditLineTypeScreen extends StatefulWidget {
  var linetypeID;
  EditLineTypeScreen({Key? key, @required this.linetypeID}) : super(key: key);

  @override
  _EditLineTypeScreenState createState() =>
      _EditLineTypeScreenState(linetypeID);
}

class _EditLineTypeScreenState extends State<EditLineTypeScreen> {
  final linetypeID;
  _EditLineTypeScreenState(this.linetypeID);
  bool _loading = true;
  bool _error = false;
  var linetype = null;

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

  loadLineType() async {
    setState(() {
      _loading = true;
    });
    final params = {'linetype_id': linetypeID.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/linetype", params))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          linetype = jsonData;
          if (jsonData != null) {
            _linetype_name = jsonData['linetype_name'];
            _is_back = jsonData['is_back'];
            _time_start = jsonData['time_start'].toString();
            _time_end = jsonData['time_end'].toString();
            _mon = jsonData['mon'];
            _tue = jsonData['tue'];
            _wed = jsonData['wed'];
            _thu = jsonData['thu'];
            _fri = jsonData['fri'];
            _sat = jsonData['sat'];
            _sun = jsonData['sun'];
          }
        });
      } else
        setState(() {
          _error = true;
        });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  editLineType() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'linetype_id': linetypeID.toString(),
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
        .patch(Uri.http(baseURL(), "/api/editLineType", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Chỉnh sửa thành công');
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        errorSnackBar(context, jsonDecode(response.body).values.first);
      } else {
        errorSnackBar(context, 'Lỗi server');
      }
    }).catchError((e) {
      setState(() {
        errorSnackBar(context, 'Lỗi server');
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
  void initState() {
    super.initState();
    loadLineType();
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
            'Sửa loại tuyến',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: _error
                    ? const Text('Có lỗi dữ liệu')
                    : _loading
                        ? Center(child: CircularProgressIndicator())
                        : linetype == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(children: [
                                      Column(children: [
                                        Text('Loại:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.blueAccent)),
                                        DropdownButton(
                                            items: isback_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _is_back,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _is_back = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('T2:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _mon,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _mon = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('T3:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _tue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _tue = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('T4:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _wed,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _wed = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('T5:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _thu,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _thu = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('T6:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _fri,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _fri = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('T7:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.redAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _sat,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _sat = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            }),
                                      ]),
                                      Column(children: [
                                        Text('CN:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.redAccent)),
                                        DropdownButton(
                                            items: choose_list.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['value'],
                                                  child: Text(valueItem['tag']
                                                      .toString()));
                                            }).toList(),
                                            value: _sun,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _sun = int.tryParse(
                                                    newValue.toString())!;
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
                                      Text(_time_start,
                                          style: TextStyle(fontSize: 19)),
                                    ]),
                                    Wrap(children: [
                                      MaterialButton(
                                          onPressed: () {
                                            selectTime(context, 1);
                                          },
                                          color: Colors.orangeAccent,
                                          textColor: Colors.white,
                                          child: Text('Giờ kết thúc')),
                                      Text(_time_end,
                                          style: TextStyle(fontSize: 19)),
                                    ]),
                                    TextField(
                                      controller: TextEditingController(
                                          text: _linetype_name),
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập tên loại tuyến*',
                                      ),
                                      onChanged: (value) {
                                        _linetype_name = value;
                                      },
                                    ),
                                    MaterialButton(
                                        onPressed: () {
                                          editLineType();
                                        },
                                        color: Colors.blueAccent,
                                        textColor: Colors.white,
                                        child: Text('Chỉnh sửa')),
                                  ]))),
      ),
      RoundedButton(
          btnText: '⬅',
          onBtnPressed: () {
            Navigator.pop(context, true);
          })
    ]);
  }
}
