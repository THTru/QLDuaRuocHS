import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class EditLineScreen extends StatefulWidget {
  var lineID;
  EditLineScreen({Key? key, @required this.lineID}) : super(key: key);

  @override
  _EditLineScreenState createState() => _EditLineScreenState(lineID);
}

class _EditLineScreenState extends State<EditLineScreen> {
  final lineID;
  _EditLineScreenState(this.lineID);
  bool _error = false;
  bool _loading = true;
  var line = null;

  String _line_name = '';
  int _slot = 10;
  String _first_date = '';
  String _last_date = '';
  String _reg_deadline = '';
  int _vehicle_id = 0;
  int _driver_id = 0;
  int _carer_id = 0;
  List<dynamic> _vehicles = [
    {'vehicle_id': 0, 'vehicle_no': 'Không có'}
  ];
  List<dynamic> _drivers = [
    {'driver_id': 0, 'driver_name': 'Không có'}
  ];
  List<dynamic> _carers = [
    {'id': 0, 'name': 'Không có'}
  ];

  editLine() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'line_id': lineID.toString(),
      'line_name': _line_name,
      'slot': _slot.toString(),
      'first_date': _first_date,
      'last_date': _last_date,
      'reg_deadline': _reg_deadline,
      'vehicle_id': _vehicle_id.toString(),
      'driver_id': _driver_id.toString(),
      'carer_id': _carer_id.toString(),
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editLine", params),
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

  loadLinedata() async {
    setState(() {
      _loading = true;
    });
    final params = {'line_id': lineID.toString()};
    await http.get(Uri.http(baseURL(), "/api/line", params)).then((response) {
      if (response.statusCode == 200) {
        print(response.statusCode);
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            line = jsonData;
            _line_name = jsonData['line_name'];
            _slot = jsonData['slot'];
            _first_date = yMD(jsonData['first_date']);
            _last_date = yMD(jsonData['last_date']);
            _reg_deadline = yMD(jsonData['reg_deadline']);
            _vehicle_id = jsonData['vehicle_id'];
            _carer_id = jsonData['carer_id'];
            _driver_id = jsonData['driver_id'];
          });
        }
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

  loadCarerforEditLine() async {
    final params = {'type': '2'};
    await http
        .get(Uri.http(baseURL(), "/api/users/type", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _carers = jsonData;
          });
        }
      }
    });
  }

  loadDriverforEditLine() async {
    await http.get(Uri.http(baseURL(), "/api/drivers")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _drivers = jsonData;
          });
        }
      }
    });
  }

  loadVehicleforEditLine() async {
    await http.get(Uri.http(baseURL(), "/api/vehicles")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _vehicles = jsonData;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadCarerforEditLine();
    loadDriverforEditLine();
    loadVehicleforEditLine();
    loadLinedata();
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
            'Sửa thông tin tuyến',
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
                        : line == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Wrap(children: [
                                      TextField(
                                        controller: TextEditingController(
                                            text: _line_name),
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập tên*',
                                        ),
                                        onChanged: (value) {
                                          _line_name = value;
                                        },
                                      ),
                                      TextField(
                                        controller: TextEditingController(
                                            text: _slot.toString()),
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập số lượng*',
                                        ),
                                        onChanged: (value) {
                                          _slot = int.tryParse(value)!;
                                        },
                                      ),
                                      Row(children: [
                                        Text('Bảo mẫu:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: _carers.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['id'],
                                                  child: Text(valueItem['name']
                                                      .toString()));
                                            }).toList(),
                                            value: _carer_id,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _carer_id = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            })
                                      ]),
                                      Row(children: [
                                        Text('Tài xế:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: _drivers.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['driver_id'],
                                                  child: Text(
                                                      valueItem['driver_name']
                                                          .toString()));
                                            }).toList(),
                                            value: _driver_id,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _driver_id = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            })
                                      ]),
                                      Row(children: [
                                        Text('Xe:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: _vehicles.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value:
                                                      valueItem['vehicle_id'],
                                                  child: Text(
                                                      valueItem['vehicle_no'] +
                                                          ' ' +
                                                          valueItem['capacity']
                                                              .toString() +
                                                          ' chỗ'));
                                            }).toList(),
                                            value: _vehicle_id,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _vehicle_id = int.tryParse(
                                                    newValue.toString())!;
                                              });
                                            })
                                      ]),
                                      Row(children: [
                                        MaterialButton(
                                          color: Colors.green,
                                          textColor: Colors.white,
                                          child: Text('Chọn ngày đầu tiên'),
                                          onPressed: () async {
                                            var chosenDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate:
                                                        DateTime(2015, 1, 1),
                                                    lastDate:
                                                        DateTime(2025, 12, 31));
                                            if (chosenDate != null)
                                              setState(() {
                                                _first_date =
                                                    yMD(chosenDate.toString());
                                              });
                                          },
                                        ),
                                        Text(_first_date,
                                            style: TextStyle(fontSize: 18))
                                      ]),
                                      Row(children: [
                                        MaterialButton(
                                          child: Text('Chọn ngày cuối'),
                                          color: Colors.orangeAccent,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            var chosenDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate:
                                                        DateTime(2015, 1, 1),
                                                    lastDate:
                                                        DateTime(2025, 12, 31));
                                            if (chosenDate != null)
                                              setState(() {
                                                _last_date =
                                                    yMD(chosenDate.toString());
                                              });
                                          },
                                        ),
                                        Text(_last_date,
                                            style: TextStyle(fontSize: 18))
                                      ]),
                                      Row(children: [
                                        MaterialButton(
                                          child: Text('Chọn hạn đăng ký'),
                                          color: Colors.pinkAccent,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            var chosenDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate:
                                                        DateTime(2015, 1, 1),
                                                    lastDate:
                                                        DateTime(2025, 12, 31));
                                            if (chosenDate != null)
                                              setState(() {
                                                _reg_deadline =
                                                    yMD(chosenDate.toString());
                                              });
                                          },
                                        ),
                                        Text(_reg_deadline,
                                            style: TextStyle(fontSize: 18))
                                      ]),
                                      MaterialButton(
                                          onPressed: () {
                                            editLine();
                                          },
                                          color: Colors.blueAccent,
                                          textColor: Colors.white,
                                          child: Text('Chỉnh sửa')),
                                    ]),
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
