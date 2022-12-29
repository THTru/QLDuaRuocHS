import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditVehicleScreen extends StatefulWidget {
  var vehicleID;
  EditVehicleScreen({Key? key, @required this.vehicleID}) : super(key: key);

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState(vehicleID);
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final vehicleID;
  _EditVehicleScreenState(this.vehicleID);
  String _vehicle_no = '';
  String _capacity = '';
  var vehicle = null;

  bool _loading = false;
  bool _error = false;

  loadVehicle() async {
    setState(() {
      _loading = true;
    });
    final params = {'vehicle_id': vehicleID.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/vehicle", params))
        .then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            vehicle = jsonData;
            _vehicle_no = jsonData['vehicle_no'];
            _capacity = jsonData['capacity'].toString();
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
      'vehicle_id': vehicleID.toString(),
      'vehicle_no': _vehicle_no,
      'capacity': _capacity,
      'vehicle_status': '1',
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
    loadVehicle();
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
            'Sửa thông tin xe',
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
                        : vehicle == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập biển số xe*',
                                      ),
                                      controller: TextEditingController(
                                          text: _vehicle_no),
                                      onChanged: (value) {
                                        _vehicle_no = value;
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Nhập số chỗ*',
                                      ),
                                      controller: TextEditingController(
                                          text: _capacity),
                                      onChanged: (value) {
                                        _capacity = value;
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
