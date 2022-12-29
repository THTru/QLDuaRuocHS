import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class EditTripScreen extends StatefulWidget {
  var tripID;
  EditTripScreen({Key? key, @required this.tripID}) : super(key: key);

  @override
  _EditTripScreenState createState() => _EditTripScreenState(tripID);
}

class _EditTripScreenState extends State<EditTripScreen> {
  final tripID;
  _EditTripScreenState(this.tripID);
  bool _error = false;
  bool _loading = true;
  var trip = null;

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

  editTrip() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'trip_id': tripID.toString(),
      'vehicle_id': _vehicle_id.toString(),
      'driver_id': _driver_id.toString(),
      'carer_id': _carer_id.toString(),
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editTrip", params),
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

  loadTripdata() async {
    setState(() {
      _loading = true;
    });
    final params = {'trip_id': tripID.toString()};
    await http.get(Uri.http(baseURL(), "/api/trip", params)).then((response) {
      if (response.statusCode == 200) {
        print(response.statusCode);
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            trip = jsonData;
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

  loadCarerforEditTrip() async {
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

  loadDriverforEditTrip() async {
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

  loadVehicleforEditTrip() async {
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
    loadCarerforEditTrip();
    loadDriverforEditTrip();
    loadVehicleforEditTrip();
    loadTripdata();
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
            'Sửa thông tin chuyến xe',
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
                        : trip == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Wrap(children: [
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
                                      MaterialButton(
                                          onPressed: () {
                                            editTrip();
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
