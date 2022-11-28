import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/rounded_button.dart';

class NewLineScreen extends StatefulWidget {
  const NewLineScreen({Key? key}) : super(key: key);

  @override
  _NewLineScreenState createState() => _NewLineScreenState();
}

class _NewLineScreenState extends State<NewLineScreen> {
  String _line_name = '';
  int _slot = 10;
  String _first_date = '';
  String _last_date = '';
  String _reg_deadline = '';
  int _linetype_id = 0;
  int _vehicle_id = 0;
  int _driver_id = 0;
  int _carer_id = 0;
  int _schedule_id = 0;
  List<dynamic> _linetypes = [];
  List<dynamic> _vehicles = [];
  List<dynamic> _drivers = [];
  List<dynamic> _carers = [];
  List<dynamic> _schedules = [];

  newLine() async {
    final params = {
      'line_name': _line_name,
      'slot': _slot.toString(),
      'first_date': _first_date,
      'last_date': _last_date,
      'reg_deadline': _reg_deadline,
      'linetype_id': _linetype_id.toString(),
      'vehicle_id': _vehicle_id.toString(),
      'driver_id': _driver_id.toString(),
      'carer_id': _carer_id.toString(),
      'schedule_id': _schedule_id.toString(),
    };
    await http
        .post(Uri.http(baseURL(), "/api/newLine", params))
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

  loadLineTypeforNewLine() async {
    setState(() {
      _linetypes = [
        {'linetype_id': 0, 'linetype_name': 'Không có'}
      ];
      _linetype_id = _linetypes[0]['linetype_id'];
    });
    await http.get(Uri.http(baseURL(), "/api/linetypes")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _linetypes = jsonData;
            _linetype_id = _linetypes[0]['linetype_id'];
          });
        }
      }
    });
  }

  loadScheduleforNewLine() async {
    setState(() {
      _schedules = [
        {'schedule_id': 0, 'schedule_name': 'Không có'}
      ];
      _schedule_id = _schedules[0]['schedule_id'];
    });
    await http.get(Uri.http(baseURL(), "/api/schedules")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _schedules = jsonData;
            _schedule_id = _schedules[0]['schedule_id'];
          });
        }
      }
    });
  }

  loadCarerforNewLine() async {
    setState(() {
      _carers = [
        {'id': 0, 'name': 'Không có'}
      ];
      _carer_id = _carers[0]['id'];
    });
    final params = {'type': '2'};
    await http
        .get(Uri.http(baseURL(), "/api/users/type", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _carers = jsonData;
            _carer_id = _carers[0]['id'];
          });
        }
      }
    });
  }

  loadDriverforNewLine() async {
    setState(() {
      _drivers = [
        {'driver_id': 0, 'driver_name': 'Không có'}
      ];
      _driver_id = _drivers[0]['driver_id'];
    });
    await http.get(Uri.http(baseURL(), "/api/drivers")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _drivers = jsonData;
            _driver_id = _drivers[0]['driver_id'];
          });
        }
      }
    });
  }

  loadVehicleforNewLine() async {
    setState(() {
      _vehicles = [
        {'vehicle_id': 0, 'vehicle_no': 'Không có'}
      ];
      _vehicle_id = _vehicles[0]['vehicle_id'];
    });
    await http.get(Uri.http(baseURL(), "/api/vehicles")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _vehicles = jsonData;
            _vehicle_id = _vehicles[0]['vehicle_id'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadLineTypeforNewLine();
    loadScheduleforNewLine();
    loadCarerforNewLine();
    loadDriverforNewLine();
    loadVehicleforNewLine();
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
            'Thêm tuyến',
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
              Wrap(children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên*',
                  ),
                  onChanged: (value) {
                    _line_name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập số lượng*',
                  ),
                  onChanged: (value) {
                    _slot = int.tryParse(value)!;
                  },
                ),
                Row(children: [
                  Text('Loại tuyến:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: _linetypes.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['linetype_id'],
                            child: Text(valueItem['linetype_name'].toString()));
                      }).toList(),
                      value: _linetype_id,
                      onChanged: (newValue) {
                        setState(() {
                          _linetype_id = int.tryParse(newValue.toString())!;
                        });
                      })
                ]),
                Row(children: [
                  Text('Lộ trình:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: _schedules.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['schedule_id'],
                            child: Text(valueItem['schedule_name'].toString()));
                      }).toList(),
                      value: _schedule_id,
                      onChanged: (newValue) {
                        setState(() {
                          _schedule_id = int.tryParse(newValue.toString())!;
                        });
                      })
                ]),
                Row(children: [
                  Text('Bảo mẫu:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: _carers.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['id'],
                            child: Text(valueItem['name'].toString()));
                      }).toList(),
                      value: _carer_id,
                      onChanged: (newValue) {
                        setState(() {
                          _carer_id = int.tryParse(newValue.toString())!;
                        });
                      })
                ]),
                Row(children: [
                  Text('Tài xế:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: _drivers.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['driver_id'],
                            child: Text(valueItem['driver_name'].toString()));
                      }).toList(),
                      value: _driver_id,
                      onChanged: (newValue) {
                        setState(() {
                          _driver_id = int.tryParse(newValue.toString())!;
                        });
                      })
                ]),
                Row(children: [
                  Text('Xe:',
                      style:
                          TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                  DropdownButton(
                      items: _vehicles.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem['vehicle_id'],
                            child: Text(valueItem['vehicle_no'] +
                                ' ' +
                                valueItem['capacity'].toString() +
                                ' chỗ'));
                      }).toList(),
                      value: _vehicle_id,
                      onChanged: (newValue) {
                        setState(() {
                          _vehicle_id = int.tryParse(newValue.toString())!;
                        });
                      })
                ]),
                Row(children: [
                  TextButton(
                    child: Text('Chọn ngày đầu tiên'),
                    onPressed: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          _first_date = yMD(chosenDate.toString());
                        });
                    },
                  ),
                  Text(_first_date)
                ]),
                Row(children: [
                  TextButton(
                    child: Text('Chọn ngày cuối'),
                    onPressed: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          _last_date = yMD(chosenDate.toString());
                        });
                    },
                  ),
                  Text(_last_date)
                ]),
                Row(children: [
                  TextButton(
                    child: Text('Chọn hạn đăng ký'),
                    onPressed: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          _reg_deadline = yMD(chosenDate.toString());
                        });
                    },
                  ),
                  Text(_reg_deadline)
                ]),
                TextButton(
                    onPressed: () {
                      newLine();
                    },
                    child: Text('Thêm mới')),
              ]),
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
