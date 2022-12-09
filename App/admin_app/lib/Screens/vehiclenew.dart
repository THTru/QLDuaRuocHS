import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewVehicleScreen extends StatefulWidget {
  const NewVehicleScreen({Key? key}) : super(key: key);

  @override
  _NewVehicleScreenState createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  String _vehicle_no = '';
  String _capacity = '';

  newVehicle() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'vehicle_no': _vehicle_no,
      'capacity': _capacity,
      'vehicle_status': '1'
    };
    await http
        .post(Uri.http(baseURL(), "/api/newVehicle", params),
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
            'Thêm xe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nhập biển số*',
                          ),
                          onChanged: (value) {
                            _vehicle_no = value;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nhập số chỗ*',
                          ),
                          onChanged: (value) {
                            _capacity = value;
                          },
                        ),
                        MaterialButton(
                            onPressed: () {
                              newVehicle();
                            },
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            child: Text('Thêm mới')),
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
