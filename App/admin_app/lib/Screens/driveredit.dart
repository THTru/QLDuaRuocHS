import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditDriverScreen extends StatefulWidget {
  var driverID;
  EditDriverScreen({Key? key, @required this.driverID}) : super(key: key);

  @override
  _EditDriverScreenState createState() => _EditDriverScreenState(driverID);
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  final driverID;
  _EditDriverScreenState(this.driverID);
  String _driver_name = '';
  String _driver_phone = '';
  String _driver_address = '';
  var driver = null;

  bool _loading = false;
  bool _error = false;

  loadDriver() async {
    setState(() {
      _loading = true;
    });
    final params = {'driver_id': driverID.toString()};
    await http.get(Uri.http(baseURL(), "/api/driver", params)).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          driver = jsonData;
          if (jsonData != null) {
            _driver_name = jsonData['driver_name'];
            _driver_phone = jsonData['driver_phone'];
            _driver_address = jsonData['driver_address'];
          }
        });
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
      'driver_id': driverID.toString(),
      'driver_name': _driver_name,
      'driver_phone': _driver_phone,
      'driver_address': _driver_address,
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editDriver", params),
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
    loadDriver();
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
            'Sửa thông tin tài xế',
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
                        : driver == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập tên tài xế*',
                                      ),
                                      controller: TextEditingController(
                                          text: _driver_name),
                                      onChanged: (value) {
                                        _driver_name = value;
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập SĐT tài xế*',
                                      ),
                                      controller: TextEditingController(
                                          text: _driver_phone),
                                      onChanged: (value) {
                                        _driver_phone = value;
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập địa chỉ tài xế*',
                                      ),
                                      controller: TextEditingController(
                                          text: _driver_address),
                                      onChanged: (value) {
                                        _driver_address = value;
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
