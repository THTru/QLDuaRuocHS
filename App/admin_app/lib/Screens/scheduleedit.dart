import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditScheduleScreen extends StatefulWidget {
  var scheduleID;
  EditScheduleScreen({Key? key, @required this.scheduleID}) : super(key: key);

  @override
  _EditScheduleScreenState createState() =>
      _EditScheduleScreenState(scheduleID);
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final scheduleID;
  _EditScheduleScreenState(this.scheduleID);
  String _schedule_name = '';
  String _schedule_des = '';
  var schedule = null;

  bool _loading = false;
  bool _error = false;

  loadSchedule() async {
    setState(() {
      _loading = true;
    });
    final params = {'schedule_id': scheduleID.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/schedule", params))
        .then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            schedule = jsonData;
            _schedule_name = jsonData['schedule_name'];
            _schedule_des = jsonData['schedule_des'];
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

  editDriver() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'schedule_id': scheduleID.toString(),
      'schedule_name': _schedule_name,
      'schedule_des': _schedule_des,
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editSchedule", params),
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

  @override
  void initState() {
    super.initState();
    loadSchedule();
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
            'Sửa thông tin lộ trình',
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
                        : schedule == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập tên lộ trình*',
                                      ),
                                      controller: TextEditingController(
                                          text: _schedule_name),
                                      onChanged: (value) {
                                        _schedule_name = value;
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập mô tả*',
                                      ),
                                      controller: TextEditingController(
                                          text: _schedule_des),
                                      onChanged: (value) {
                                        _schedule_des = value;
                                      },
                                    ),
                                    MaterialButton(
                                        onPressed: () {
                                          editDriver();
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
