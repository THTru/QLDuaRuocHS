import 'dart:convert';
// import 'dart:io';

import 'package:carer_app/Screens/studentstriplist.dart';
import 'package:flutter/material.dart';
import 'package:carer_app/rounded_button.dart';
import 'package:carer_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// import 'package:parent_app/Screens/map.dart';

class TripScreen extends StatefulWidget {
  var tripID;
  TripScreen({Key? key, @required this.tripID}) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState(tripID);
}

class _TripScreenState extends State<TripScreen> {
  final tripID;
  _TripScreenState(this.tripID);
  var _trip = null;
  bool _error = false;
  bool _loading = true;

  loadTrip() async {
    setState(() {
      _trip = null;
      _loading = true;
    });

    final params = '?trip_id=' + tripID.toString();
    await http
        .get(Uri.parse(baseURL() + '/api/trip' + params.toString()))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          _trip = jsonData;
        });
      } else {
        setState(() {
          _error;
        });
      }
    }).catchError((onError) {
      setState(() {
        _error = true;
      });
    });
    setState(() {
      _loading = false;
    });
    if (_trip == null) {
      setState(() {
        _error = true;
      });
    }
  }

  startTrip() async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if (user != null) {
      final params = {
        'carer_id': jsonDecode(user)['id'].toString(),
        'trip_id': tripID.toString(),
      };
      await http
          .patch(Uri.parse(baseURL() + '/api/startTrip'), body: params)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Chuyến xe khởi hành');
          loadTrip();
        } else if (response.statusCode == 430) {
          errorSnackBar(context, jsonDecode(response.body).values.first);
        } else {
          errorSnackBar(context, 'Lỗi Server 1');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Lỗi Server 2');
      });
    } else {
      errorSnackBar(context, 'Không có quyền thao tác');
    }
  }

  endTrip() async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if (user != null) {
      final params = {
        'carer_id': jsonDecode(user)['id'].toString(),
        'trip_id': tripID.toString(),
      };
      await http
          .patch(Uri.parse(baseURL() + '/api/endTrip'), body: params)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Chuyến xe hoàn thành');
          loadTrip();
        } else if (response.statusCode == 430) {
          errorSnackBar(context, jsonDecode(response.body).values.first);
        } else {
          errorSnackBar(context, 'Lỗi Server');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Lỗi Server');
      });
    } else {
      errorSnackBar(context, 'Không có quyền thao tác');
    }
  }

  @override
  void initState() {
    super.initState();
    loadTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Chi tiết chuyến',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _error == true
                  ? Center(
                      child: Text(
                      'Có lỗi tải dữ liệu',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ))
                  : _loading == true
                      ? Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_trip['trip_name'],
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Giờ dự kiến: ' +
                                              _trip['line']['linetype']
                                                      ['time_start']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Bắt đầu: ' +
                                              _trip['start_at'].toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Kết thúc: ' +
                                              _trip['end_at'].toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Tài xế: ' +
                                              _trip['driver']['driver_name'] +
                                              ' - SĐT: ' +
                                              _trip['driver']['driver_phone']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Xe: ' +
                                              _trip['vehicle']['vehicle_no'],
                                          style: TextStyle(fontSize: 19)),
                                      Wrap(children: [
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentTripListScreen(
                                                            tripID:
                                                                tripID))).then(
                                                (value) => setState(() {
                                                      loadTrip();
                                                    }));
                                          },
                                          textColor: Colors.white,
                                          child: Wrap(children: [
                                            Icon(Icons.school_outlined),
                                            Text(' Danh sách',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19))
                                          ]),
                                          color: Colors.blueAccent,
                                        ),
                                        _trip['start_at'] == null
                                            ? MaterialButton(
                                                onPressed: () {
                                                  startTrip();
                                                },
                                                textColor: Colors.white,
                                                child: Wrap(children: [
                                                  Icon(Icons.start_outlined),
                                                  Text(' Khởi hành',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 19))
                                                ]),
                                                color: Colors.green,
                                              )
                                            : MaterialButton(
                                                onPressed: () {
                                                  endTrip();
                                                },
                                                textColor: Colors.white,
                                                child: Wrap(children: [
                                                  Icon(Icons.start_outlined),
                                                  Text(' Hoàn thành',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 19))
                                                ]),
                                                color: Colors.orangeAccent,
                                              )
                                      ])
                                    ],
                                  ))))
            ],
          )),
    );
  }
}
