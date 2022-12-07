import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NewDayOffScreen extends StatefulWidget {
  const NewDayOffScreen({Key? key}) : super(key: key);

  @override
  _NewDayOffScreenState createState() => _NewDayOffScreenState();
}

class _NewDayOffScreenState extends State<NewDayOffScreen> {
  String _date = '';
  String _name = '';

  String _dateDMY = '';

  newDayOff() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'date': _date,
      'name': _name,
    };
    await http
        .post(Uri.http(baseURL(), "/api/newDayOff", params),
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
  Widget build(BuildContext) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Thêm ngày nghỉ',
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
                        _date = yMD(chosenDate.toString());
                        _dateDMY = dMY(chosenDate.toString());
                      });
                  },
                ),
                Text(_dateDMY, style: TextStyle(fontSize: 18))
              ]),
              Wrap(children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên ngày nghỉ*',
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                MaterialButton(
                    onPressed: () {
                      newDayOff();
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Thêm mới')),
              ]),
            ])),
      ),
      RoundedButton(
          btnText: '⬅',
          onBtnPressed: () {
            Navigator.pop(context, true);
          })
    ]);
  }
}
