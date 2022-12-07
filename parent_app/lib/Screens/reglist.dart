import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:parent_app/Screens/reginfo.dart';

class RegListScreen extends StatefulWidget {
  const RegListScreen({Key? key}) : super(key: key);

  @override
  _RegListScreenState createState() => _RegListScreenState();
}

class _RegListScreenState extends State<RegListScreen> {
  List<dynamic> _reglist = [];
  bool _error = false;
  bool _loading = true;
  var student = null;

  loadRegList() async {
    final storage = new FlutterSecureStorage();
    var temp = await storage.read(key: 'student');
    setState(() {
      _reglist = [];
      _loading = true;
      student = temp;
    });

    if (student != null) {
      final params =
          '?student_id=' + jsonDecode(student)['student_id'].toString();
      await http
          .get(Uri.parse(baseURL() + '/api/registrations' + params.toString()))
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            final jsonData = jsonDecode(response.body);
            _reglist = jsonData;
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
  }

  cancelReg(regID) async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');
    var token = await storage.read(key: 'token');

    if (user != null && token != null) {
      final params = {
        'reg_id': regID.toString(),
        'parent_id': jsonDecode(user)['id'].toString(),
      };
      final headers = {'Authorization': 'Bearer ' + token.toString()};
      await http
          .delete(Uri.parse(baseURL() + '/api/cancelRegLine'),
              body: params, headers: headers)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Hủy thành công');
          loadRegList();
        } else if (response.statusCode == 430) {
          errorSnackBar(context, jsonDecode(response.body).values.first);
        } else {
          errorSnackBar(context, 'Lỗi Server');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Lỗi Server');
      });
    } else {
      errorSnackBar(context, 'Người dùng không thể hủy');
    }
  }

  @override
  void initState() {
    super.initState();
    loadRegList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Các tuyến đã đăng ký',
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
              student != null
                  ? Text(
                      'Bé: ' + jsonDecode(student)['student_name'].toString(),
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold))
                  : Text(''),
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
                              itemCount: _reglist.length,
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
                                            Text(
                                                _reglist[index]['line']
                                                    ['line_name'],
                                                style: TextStyle(
                                                    color: Colors.deepOrange,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'Bắt đầu: ' +
                                                    _reglist[index]['line']
                                                                ['linetype']
                                                            ['time_start']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Kết thúc: ' +
                                                    _reglist[index]['line']
                                                                ['linetype']
                                                            ['time_end']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Từ ' +
                                                    dMY(_reglist[index]['line']
                                                        ['first_date']) +
                                                    ' tới ' +
                                                    dMY(_reglist[index]['line']
                                                        ['last_date']),
                                                style: TextStyle(fontSize: 19)),
                                            Wrap(children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegInfoScreen(
                                                                regID: _reglist[
                                                                        index][
                                                                    'reg_id'])),
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
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  cancelReg(_reglist[index]
                                                      ['reg_id']);
                                                },
                                                textColor: Colors.white,
                                                child: Wrap(children: [
                                                  Icon(Icons.cancel_outlined),
                                                  Text(' Hủy đăng ký',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 19))
                                                ]),
                                                color: Colors.redAccent,
                                              )
                                            ])
                                          ],
                                        )));
                              }))
            ],
          )),
    );
  }
}
