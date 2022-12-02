import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegInfoScreen extends StatefulWidget {
  var regID;
  RegInfoScreen({Key? key, @required this.regID}) : super(key: key);

  @override
  _RegInfoScreenState createState() => _RegInfoScreenState(regID);
}

class _RegInfoScreenState extends State<RegInfoScreen> {
  final regID;
  _RegInfoScreenState(this.regID);
  var _reg = null;
  bool _error = false;
  bool _loading = true;
  int _stop_id = 0;
  int markerID = 0;
  List<Marker> _markers = [];

  loadReg() async {
    setState(() {
      _reg = null;
      _loading = true;
    });

    final params = '?reg_id=' + regID.toString();
    await http
        .get(Uri.parse(baseURL() + '/api/registration' + params.toString()))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          _reg = jsonData;
          _markers.add(Marker(
              markerId: MarkerId((markerID++).toString()),
              infoWindow:
                  InfoWindow(title: _reg['stop']['location'].toString()),
              position: LatLng(_reg['stop']['lat'], _reg['stop']['lng'])));
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
    if (_reg == null) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadReg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Chi tiết tuyến đăng ký',
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
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_reg['line']['line_name'],
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Bắt đầu: ' +
                                              _reg['line']['linetype']
                                                      ['time_start']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Kết thúc: ' +
                                              _reg['line']['linetype']
                                                      ['time_end']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Từ ' +
                                              dMY(_reg['line']['first_date']) +
                                              ' tới ' +
                                              dMY(_reg['line']['last_date']),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Bảo mẫu: ' +
                                              _reg['line']['carer']['name'] +
                                              ' - SĐT: ' +
                                              _reg['line']['carer']['phone']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Tài xế: ' +
                                              _reg['line']['driver']
                                                  ['driver_name'] +
                                              ' - SĐT: ' +
                                              _reg['line']['driver']
                                                      ['driver_phone']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Xe: ' +
                                              _reg['line']['vehicle']
                                                  ['vehicle_no'],
                                          style: TextStyle(fontSize: 19)),
                                      Text('Điểm dừng: ',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.bold)),
                                      Text(_reg['stop']['location'],
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                          width: double.infinity,
                                          height: 250,
                                          child: GoogleMap(
                                            markers: Set<Marker>.of(_markers),
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  10.0312357, 105.7708309),
                                              zoom: 12,
                                            ),
                                          ))
                                    ],
                                  ))))
            ],
          )),
    );
  }
}
