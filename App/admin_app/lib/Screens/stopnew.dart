import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewStopScreen extends StatefulWidget {
  const NewStopScreen({Key? key}) : super(key: key);

  @override
  _NewStopScreenState createState() => _NewStopScreenState();
}

class _NewStopScreenState extends State<NewStopScreen> {
  String _location = '';
  double _lat = 10.0324476;
  double _lng = 105.7576498;
  List<Marker> _markers = [];
  var setMarkers;
  int _markerID = 0;

  newStop() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'location': _location,
      'lat': _lat.toString(),
      'lng': _lng.toString()
    };
    await http
        .post(Uri.http(baseURL(), "/api/newStop", params),
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
    _markers.add(Marker(
        markerId: MarkerId(_markerID.toString()),
        infoWindow: InfoWindow(title: 'Điểm dừng mới'),
        position: LatLng(10.0341851, 105.7225507)));
    setMarkers = Set<Marker>.of(_markers);
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
            'Thêm điểm dừng',
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
              Wrap(children: [
                Text('Nhấp trên bản đồ để chọn tọa độ: ',
                    style: TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                Text(_lat.toString() + ', ' + _lng.toString(),
                    style: TextStyle(fontSize: 17, color: Colors.black)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên điểm dừng*',
                  ),
                  onChanged: (value) {
                    _location = value;
                  },
                ),
                MaterialButton(
                    onPressed: () {
                      newStop();
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Thêm mới')),
              ]),
              Container(
                  height: 400,
                  width: 900,
                  child: GoogleMap(
                      markers: setMarkers,
                      onTap: (latlng) {
                        setState(() {
                          _lat = latlng.latitude;
                          _lng = latlng.longitude;
                          _markers = [];
                          _markerID++;
                          _markers.add(Marker(
                              markerId: MarkerId(_markerID.toString()),
                              infoWindow: InfoWindow(title: 'Điểm dừng mới'),
                              position: latlng));
                          setMarkers = Set<Marker>.of(_markers);
                        });
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(10.0324476, 105.7576498), zoom: 13)))
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
