import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:parent_app/Screens/map.dart';

class LineRegScreen extends StatefulWidget {
  var lineID;
  LineRegScreen({Key? key, @required this.lineID}) : super(key: key);

  @override
  _LineRegScreenState createState() => _LineRegScreenState(lineID);
}

class _LineRegScreenState extends State<LineRegScreen> {
  final lineID;
  _LineRegScreenState(this.lineID);

  var _line = null;
  List<dynamic> _stoplist = [];
  bool _error = false;
  bool _loading = true;
  int _stop_id = 0;
  int markerID = 0;
  List<Marker> _markers = [];

  loadLine() async {
    setState(() {
      _line = null;
      _stoplist = [];
      _loading = true;
    });

    final params = '?line_id=' + lineID.toString();
    await http
        .get(Uri.parse(baseURL() + '/api/line' + params.toString()))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          _line = jsonData;
          _stoplist = jsonData['schedule']['stopschedule'];
          _stop_id = _stoplist[0]['stop']['stop_id'];
          _stoplist.forEach((element) => {
                _markers.add(Marker(
                    markerId: MarkerId((markerID++).toString()),
                    infoWindow: InfoWindow(
                        title: element['stop']['location'].toString()),
                    position:
                        LatLng(element['stop']['lat'], element['stop']['lng'])))
              });
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
    if (_line == null) {
      setState(() {
        _error = true;
      });
    }
  }

  registerLine() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var user = await storage.read(key: 'user');
    var student = await storage.read(key: 'student');

    if (user != null && student != null) {
      final params = {
        'student_id': jsonDecode(student)['student_id'].toString(),
        'parent_id': jsonDecode(user)['id'].toString(),
        'line_id': lineID.toString(),
        'stop_id': _stop_id.toString(),
      };
      final headers = {'Authorization': 'Bearer ' + token.toString()};
      await http
          .post(Uri.parse(baseURL() + '/api/regLine'),
              body: params, headers: headers)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Đăng ký thành công');
        } else if (response.statusCode == 430) {
          errorSnackBar(context, jsonDecode(response.body).values.first);
        } else {
          errorSnackBar(context, 'Lỗi Server');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Lỗi Server');
      });
    } else {
      errorSnackBar(context, 'Người dùng không thể đăng ký');
    }
  }

  @override
  void initState() {
    super.initState();
    loadLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Chi tiết tuyến',
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
                                      Text(_line['line_name'],
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Số lượng: ' +
                                              _line['slot'].toString() +
                                              ' - Đã ĐK: ' +
                                              _line['registration']
                                                  .length
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Bắt đầu: ' +
                                              _line['linetype']['time_start']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Kết thúc: ' +
                                              _line['linetype']['time_end']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Từ ' +
                                              dMY(_line['first_date']) +
                                              ' tới ' +
                                              dMY(_line['last_date']),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Bảo mẫu: ' +
                                              _line['carer']['name'] +
                                              ' - SĐT: ' +
                                              _line['carer']['phone']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Tài xế: ' +
                                              _line['driver']['driver_name'] +
                                              ' - SĐT: ' +
                                              _line['driver']['driver_phone']
                                                  .toString(),
                                          style: TextStyle(fontSize: 19)),
                                      Text(
                                          'Xe: ' +
                                              _line['vehicle']['vehicle_no'],
                                          style: TextStyle(fontSize: 19)),
                                      Text('Chọn điểm dừng: ',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.bold)),
                                      DropdownButton(
                                          items: _stoplist.map((valueItem) {
                                            return DropdownMenuItem(
                                                value: valueItem['stop']
                                                    ['stop_id'],
                                                child: Text(valueItem['stop']
                                                    ['location']));
                                          }).toList(),
                                          value: _stop_id,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _stop_id = int.tryParse(
                                                  newValue.toString())!;
                                            });
                                          }),
                                      MaterialButton(
                                        onPressed: () {
                                          registerLine();
                                        },
                                        textColor: Colors.white,
                                        child: Wrap(children: [
                                          Icon(Icons.app_registration),
                                          Text('Đăng ký',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19))
                                        ]),
                                        color: Colors.orangeAccent,
                                      ),
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
