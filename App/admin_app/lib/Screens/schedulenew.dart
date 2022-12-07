import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewScheduleScreen extends StatefulWidget {
  const NewScheduleScreen({Key? key}) : super(key: key);

  @override
  _NewScheduleScreenState createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  late GoogleMapController mapscontroller;
  List<Marker> _markers = [];
  String _schedule_name = '';
  String _schedule_des = '';
  List<dynamic> _stops = [];
  List<dynamic> _stops_name = [];
  List<dynamic> _time_take = [];
  int markerID = 0;

  int _type = 0;

  List<dynamic> stoplist = [];
  var _chosenStop;
  String _time = '00:10';
  TimeOfDay time = TimeOfDay(hour: 0, minute: 10);
  var picked;

  newSchedule() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'schedule_name': _schedule_name,
      'schedule_des': _schedule_des,
      'stops': json.encode(_stops),
      'time_take': json.encode(_time_take),
    };

    await http
        .post(Uri.http(baseURL(), "/api/newSchedule", params),
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

  loadStopforNewSchedule() async {
    setState(() {
      stoplist = [
        {'stop_id:': 0, 'location': 'Không có'}
      ];
      _chosenStop = stoplist[0];
    });
    await http.get(Uri.http(baseURL(), "/api/stops")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            stoplist = jsonData;
            _chosenStop = stoplist[0];
          });
        }
      }
    });
  }

  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: time);

    if (picked != null) {
      setState(() {
        time = picked;
        String tempHour = time.hour.toString();
        String tempMinute = time.minute.toString();
        if (time.hour < 10) tempHour = '0' + picked.hour.toString();
        if (time.minute < 10) tempMinute = '0' + picked.minute.toString();
        _time = tempHour + ':' + tempMinute;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadStopforNewSchedule();
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
            'Thêm lộ trình',
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
                      hintText: 'Nhập tên lộ trình*',
                    ),
                    onChanged: (value) {
                      _schedule_name = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập mô tả*',
                    ),
                    onChanged: (value) {
                      _schedule_des = value;
                    },
                  ),
                  Row(children: [
                    Text('Điểm: ',
                        style: TextStyle(
                            fontSize: 17, color: Colors.orangeAccent)),
                    DropdownButton(
                        items: stoplist.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem['location'].toString()));
                        }).toList(),
                        value: _chosenStop,
                        onChanged: (newValue) {
                          setState(() {
                            _chosenStop = newValue;
                          });
                        }),
                    Text('Mất khoảng: ',
                        style: TextStyle(
                            fontSize: 17, color: Colors.orangeAccent)),
                    TextButton(
                        onPressed: () {
                          selectTime(context);
                        },
                        child: Text(_time,
                            style:
                                TextStyle(fontSize: 17, color: Colors.black))),
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            _stops.add(_chosenStop['stop_id']);
                            _stops_name.add(_chosenStop['location']);
                            _time_take.add(_time);
                            _markers.add(Marker(
                                markerId: MarkerId(markerID.toString()),
                                infoWindow: InfoWindow(
                                    title: _chosenStop['location'].toString()),
                                position: LatLng(
                                    _chosenStop['lat'], _chosenStop['lng'])));
                            markerID++;
                          });
                        },
                        color: Colors.orangeAccent,
                        textColor: Colors.white,
                        child: Text('Thêm điểm')),
                  ]),
                  DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Điểm',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Mất khoảng',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(label: Text('')),
                      ],
                      rows: List<DataRow>.generate(
                          _stops.length,
                          (index) => DataRow(cells: [
                                DataCell(Text(_stops_name[index].toString())),
                                DataCell(Text(_time_take[index].toString())),
                                DataCell(TextButton(
                                    child: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _stops.removeAt(index);
                                        _stops_name.removeAt(index);
                                        _time_take.removeAt(index);
                                        _markers.removeAt(index);
                                      });
                                    }))
                              ]))),
                ]),
                Container(
                    height: 350,
                    width: 900,
                    child: GoogleMap(
                        markers: Set<Marker>.of(_markers),
                        onMapCreated: (controller) {
                          setState(() {
                            mapscontroller = controller;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(10.0324476, 105.7576498),
                            zoom: 13))),
                MaterialButton(
                    onPressed: () {
                      newSchedule();
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Thêm lộ trình mới')),
              ]),
        ),
      ),
      RoundedButton(
          btnText: '⬅',
          onBtnPressed: () {
            Navigator.pop(context, true);
          })
    ]);
  }
}
