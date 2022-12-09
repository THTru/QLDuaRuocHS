import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/Screens/lineedit.dart';
import 'package:admin_app/Screens/tripedit.dart';

class LineScreen extends StatefulWidget {
  var lineID;
  LineScreen({Key? key, @required this.lineID}) : super(key: key);

  @override
  _LineScreenState createState() => _LineScreenState(lineID);
}

class _LineScreenState extends State<LineScreen> {
  final lineID;
  _LineScreenState(this.lineID);
  bool _loading = true;
  bool _error = false;
  List<dynamic> _trips = [];
  var line = null;
  int _type = 0;

  loadLine() async {
    setState(() {
      _loading = true;
    });
    final params = {"line_id": lineID.toString()};
    await http.get(Uri.http(baseURL(), "/api/line", params)).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          line = jsonData;
          _trips = jsonData['trip'];
        });
      } else
        setState(() {
          _error = true;
        });
    }).catchError((e) {
      setState(() {
        _error = false;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  changeStatus(status) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'line_id': lineID.toString(),
      'line_status': status,
    };
    await http
        .patch(Uri.http(baseURL(), "/api/changeLineStatus", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Thành công');
        loadLine();
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

  createTrips() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'line_id': lineID.toString(),
    };
    await http
        .post(Uri.http(baseURL(), "/api/createTrips", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Thành công');
        loadLine();
      } else if (response.statusCode == 430) {
        errorSnackBar(context, jsonDecode(response.body).values.first);
      } else {
        errorSnackBar(context, 'Lỗi server 1');
      }
    }).catchError((e) {
      setState(() {
        errorSnackBar(context, 'Lỗi server 2');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadLine();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thông tin tuyến',
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
                  ? const Text('Có lỗi server')
                  : _loading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Wrap(children: [
                                Text('Tên: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(line['line_name'] + ' - ',
                                    style: TextStyle(fontSize: 18)),
                                Text('Số lượng: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(line['slot'].toString() + ' ',
                                    style: TextStyle(fontSize: 18)),
                                line['line_status'] != 2
                                    ? TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditLineScreen(
                                                        lineID:
                                                            line['line_id'])),
                                          ).then((value) {
                                            loadLine();
                                          });
                                        },
                                        child: Icon(Icons.edit))
                                    : Text('')
                              ]),
                              line['line_status'] == 0
                                  ? Wrap(children: [
                                      Text('Chưa công bố ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic)),
                                      MaterialButton(
                                          onPressed: () {
                                            changeStatus('1');
                                          },
                                          color: Colors.blueAccent,
                                          textColor: Colors.white,
                                          child: Text('Công bố')),
                                    ])
                                  : line['line_status'] == 2
                                      ? Text('Đã chốt',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                              fontStyle: FontStyle.italic))
                                      : line['line_status'] == 3
                                          ? Text('Đã hủy',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontStyle: FontStyle.italic))
                                          : Wrap(children: [
                                              Text('Đã công bố ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.blue,
                                                      fontStyle:
                                                          FontStyle.italic)),
                                              MaterialButton(
                                                  onPressed: () {
                                                    createTrips();
                                                  },
                                                  color: Colors.green,
                                                  textColor: Colors.white,
                                                  child:
                                                      Text('Chốt đăng ký')),
                                              MaterialButton(
                                                  onPressed: () {
                                                    changeStatus('3');
                                                  },
                                                  color: Colors.red,
                                                  textColor: Colors.white,
                                                  child: Text('Hủy')),
                                            ]),
                              Wrap(children: [
                                Text('Loại: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(
                                    line['linetype']['linetype_name']
                                            .toString() +
                                        ' - ',
                                    style: TextStyle(fontSize: 18)),
                                Text('Lộ trình: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(
                                    line['schedule']['schedule_name']
                                        .toString(),
                                    style: TextStyle(fontSize: 18)),
                              ]),
                              Wrap(children: [
                                Text('Từ ',
                                    style: TextStyle(
                                        fontSize: 19, color: Colors.orange)),
                                Text(dMY(line['first_date']),
                                    style: TextStyle(fontSize: 18)),
                                Text(' tới ',
                                    style: TextStyle(
                                        fontSize: 19, color: Colors.orange)),
                                Text(dMY(line['last_date']),
                                    style: TextStyle(fontSize: 18)),
                              ]),
                              Wrap(children: [
                                Text('Hạn đăng ký: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(dMY(line['reg_deadline']),
                                    style: TextStyle(fontSize: 19)),
                              ]),
                              Wrap(children: [
                                Text('Bảo mẫu: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(
                                    line['carer_id'].toString() +
                                        ' - ' +
                                        line['carer']['name'],
                                    style: TextStyle(fontSize: 18)),
                              ]),
                              Wrap(children: [
                                Text('Tài xế: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Text(
                                    line['driver_id'].toString() +
                                        ' - ' +
                                        line['driver']['driver_name'],
                                    style: TextStyle(fontSize: 18)),
                              ]),
                              Wrap(children: [
                                Text('Xe: ',
                                    style: TextStyle(
                                        fontSize: 19, color: Colors.orange)),
                                Text(line['vehicle']['vehicle_no'].toString(),
                                    style: TextStyle(fontSize: 18)),
                              ]),
                              DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Ngày',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Bảo mẫu',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Tài xế',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Xe',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Khởi hành',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Kết thúc',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: List<DataRow>.generate(
                                      _trips.length,
                                      (index) => DataRow(cells: [
                                            DataCell(Text(_trips[index]['date']
                                                .toString())),
                                            DataCell(Text(_trips[index]['carer']
                                                    ['name']
                                                .toString())),
                                            DataCell(Text(_trips[index]
                                                    ['driver']['driver_name']
                                                .toString())),
                                            DataCell(Text(_trips[index]
                                                    ['vehicle']['vehicle_no']
                                                .toString())),
                                            DataCell(Text(_trips[index]
                                                    ['start_at']
                                                .toString())),
                                            DataCell(Text(_trips[index]
                                                    ['end_at']
                                                .toString())),
                                            DataCell(TextButton(
                                                child: Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditTripScreen(
                                                                tripID: _trips[
                                                                        index][
                                                                    'trip_id'])),
                                                  ).then((value) {
                                                    loadLine();
                                                  });
                                                })),
                                          ])))
                            ]))),
    );
  }
}
