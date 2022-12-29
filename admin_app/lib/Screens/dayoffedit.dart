import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditDayOffScreen extends StatefulWidget {
  var dayoffID;
  EditDayOffScreen({Key? key, @required this.dayoffID}) : super(key: key);

  @override
  _EditDayOffScreenState createState() => _EditDayOffScreenState(dayoffID);
}

class _EditDayOffScreenState extends State<EditDayOffScreen> {
  final dayoffID;
  _EditDayOffScreenState(this.dayoffID);
  String _date = '';
  String _name = '';
  String _dateDMY = '';
  var dayoff = null;

  bool _loading = false;
  bool _error = false;

  loadDayOff() async {
    setState(() {
      _loading = true;
    });
    final params = {'dayoff_id': dayoffID.toString()};
    await http.get(Uri.http(baseURL(), "/api/dayoff", params)).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          dayoff = jsonData;
          if (jsonData != null) {
            _date = jsonData['date'];
            _name = jsonData['name'];
            _dateDMY = jsonData['date'];
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

  editDayOff() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'id': dayoffID.toString(),
      'date': _date,
      'name': _name,
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editDayOff", params),
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

  @override
  void initState() {
    super.initState();
    loadDayOff();
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
            'Sửa ngày nghỉ',
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
                        : dayoff == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(children: [
                                      MaterialButton(
                                        color: Colors.orangeAccent,
                                        textColor: Colors.white,
                                        child: Text('Chọn ngày'),
                                        onPressed: () async {
                                          var chosenDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2015, 1, 1),
                                              lastDate: DateTime(2025, 12, 31));
                                          if (chosenDate != null)
                                            setState(() {
                                              _date =
                                                  yMD(chosenDate.toString());
                                              _dateDMY =
                                                  dMY(chosenDate.toString());
                                            });
                                        },
                                      ),
                                      Text(_dateDMY,
                                          style: TextStyle(fontSize: 18))
                                    ]),
                                    Wrap(children: [
                                      TextField(
                                        controller:
                                            TextEditingController(text: _name),
                                        onChanged: (value) {
                                          _name = value;
                                        },
                                      ),
                                      MaterialButton(
                                          onPressed: () {
                                            editDayOff();
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
