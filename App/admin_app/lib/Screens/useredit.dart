import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditUserScreen extends StatefulWidget {
  var userID;
  EditUserScreen({Key? key, @required this.userID}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState(userID);
}

class _EditUserScreenState extends State<EditUserScreen> {
  final userID;
  _EditUserScreenState(this.userID);
  String _name = '';
  String _phone = '';
  var user = null;

  bool _loading = false;
  bool _error = false;

  loadUser() async {
    setState(() {
      _loading = true;
    });
    final params = {'id': userID.toString()};
    await http.get(Uri.http(baseURL(), "/api/user", params)).then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            user = jsonData;
            _name = jsonData['name'];
            if (jsonData['phone'] != null) {
              _phone = jsonData['phone'].toString();
            }
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

  editUser() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'id': userID.toString(),
      'name': _name,
      'phone': _phone,
      'status': '1',
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editVehicle", params),
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
    loadUser();
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
            'Sửa thông tin người dùng',
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
                        : user == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập tên*',
                                      ),
                                      controller:
                                          TextEditingController(text: _name),
                                      onChanged: (value) {
                                        _name = value;
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập SĐT*',
                                      ),
                                      controller:
                                          TextEditingController(text: _phone),
                                      onChanged: (value) {
                                        _phone = value;
                                      },
                                    ),
                                    MaterialButton(
                                        onPressed: () {
                                          editUser();
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
