import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/Screens/reglist.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:parent_app/Screens/linereg.dart';
import 'package:parent_app/Screens/reglist.dart';

class LineListScreen extends StatefulWidget {
  const LineListScreen({Key? key}) : super(key: key);

  @override
  _LineListScreenState createState() => _LineListScreenState();
}

class _LineListScreenState extends State<LineListScreen> {
  List<dynamic> _linelist = [];
  bool _error = false;
  bool _loading = true;

  loadLineList() async {
    setState(() {
      _linelist = [];
      _loading = true;
    });

    final params =
        '?date=-1&carer_id=-1&driver_id=-1&vehicle_id=-1&linetype_id=-1&line_status=1';
    await http
        .get(Uri.parse(baseURL() + '/api/lines/filter' + params.toString()))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          _linelist = jsonData;
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
  }

  // loginPressed() async {
  //   final storage = new FlutterSecureStorage();
  //   if (_email.isNotEmpty && _password.isNotEmpty) {
  //     final params = {'password': _password, 'email': _email, 'type': _type};
  //     await http
  //         .post(Uri.parse(baseURL() + '/api/login2'), body: params)
  //         .then((response) async {
  //       var jsonData = jsonDecode(response.body);
  //       if (response.statusCode == 200) {
  //         await storage.write(key: 'token', value: jsonData['token']);
  //         successSnackBar(context, 'Xin chào');
  //         goToMapPage();
  //       } else {
  //         errorSnackBar(context, response.statusCode.toString());
  //       }
  //     }).catchError((error) {
  //       errorSnackBar(context, 'Lỗi Server');
  //     });
  //   } else {
  //     errorSnackBar(context, 'Xin điền email và password');
  //   }
  // }

  // goToMapPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => MapSample()),
  //   );
  //   print('Các chuyến xe đăng ký');
  // }

  @override
  void initState() {
    super.initState();
    loadLineList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Danh sách tuyến xe',
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
                          child: ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: _linelist.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_linelist[index]['line_name'],
                                                style: TextStyle(
                                                    color: Colors.deepOrange,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'Bắt đầu: ' +
                                                    _linelist[index]['linetype']
                                                            ['time_start']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Kết thúc: ' +
                                                    _linelist[index]['linetype']
                                                            ['time_end']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Từ ' +
                                                    dMY(_linelist[index]
                                                        ['first_date']) +
                                                    ' tới ' +
                                                    dMY(_linelist[index]
                                                        ['last_date']),
                                                style: TextStyle(fontSize: 19)),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LineRegScreen(
                                                              lineID: _linelist[
                                                                      index]
                                                                  ['line_id'])),
                                                );
                                              },
                                              textColor: Colors.white,
                                              child: Wrap(children: [
                                                Icon(Icons.info_outline),
                                                Text(' Chi tiết',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 19))
                                              ]),
                                              color: Colors.orangeAccent,
                                            )
                                          ],
                                        )));
                              }))

              // Center(
              //     child: Text(
              //     'Load xong dữ liệu',
              //     style: TextStyle(fontSize: 20, color: Colors.green),
              //   )),
              /*FractionallySizedBox(
                  widthFactor: 1,
                  child: Card(
                      margin: EdgeInsets.all(5.0),
                      color: Colors.orangeAccent,
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Wrap(
                            children: [
                              Icon(Icons.list, color: Colors.white),
                              Text(' Đăng ký tuyến xe cho con',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22))
                            ],
                          ))))*/
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegListScreen()),
          );
        },
        label: Text('Tuyến đã đăng ký'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
