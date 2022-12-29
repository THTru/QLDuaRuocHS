import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScheduleScreen extends StatefulWidget {
  var scheduleID;
  ScheduleScreen({Key? key, @required this.scheduleID}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(scheduleID);
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final scheduleID;
  _ScheduleScreenState(this.scheduleID);

  List<Marker> _markers = [];
  var markerID = 0;

  loadSchedule() async {
    final params = {'schedule_id': scheduleID.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/schedule", params))
        .then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            jsonData['stopschedule'].forEach((element) => {
                  _markers.add(Marker(
                      markerId: MarkerId((markerID++).toString()),
                      infoWindow: InfoWindow(
                          title: element['stop']['location'].toString() +
                              ' ' +
                              element['time_take'].toString()),
                      position: LatLng(
                          element['stop']['lat'], element['stop']['lng'])))
                });
          });
        }
      }
    }).catchError((error) {
      setState(() {});
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
            'Xem lộ trình',
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
                      Container(
                          width: double.infinity,
                          height: 600,
                          child: GoogleMap(
                            markers: Set<Marker>.of(_markers),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(10.0312357, 105.7708309),
                              zoom: 12,
                            ),
                          ))
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
