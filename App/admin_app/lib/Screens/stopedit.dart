import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class EditStopScreen extends StatefulWidget {
  var stopID;
  EditStopScreen({Key? key, @required this.stopID}) : super(key: key);

  @override
  _EditStopScreenState createState() => _EditStopScreenState(stopID);
}

class _EditStopScreenState extends State<EditStopScreen> {
  final stopID;
  _EditStopScreenState(this.stopID);
  bool _loading = true;
  bool _error = false;
  var stop = null;

  String _location = '';
  double _lat = 10.0324476;
  double _lng = 105.7576498;
  List<Marker> _markers = [];
  var setMarkers;
  int _markerID = 0;

  loadStop() async {
    setState(() {
      _loading = true;
    });
    final params = {'stop_id': stopID.toString()};
    await http.get(Uri.http(baseURL(), "/api/stop", params)).then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            stop = jsonData;
            _location = jsonData['location'];
            _lat = jsonData['lat'];
            _lng = jsonData['lng'];
            _markers.add(Marker(
                markerId: MarkerId(_markerID.toString()),
                infoWindow: InfoWindow(title: _location),
                position: LatLng(_lat, _lng)));
            setMarkers = Set<Marker>.of(_markers);
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

  editStop() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'stop_id': stopID.toString(),
      'location': _location,
      'lat': _lat.toString(),
      'lng': _lng.toString()
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editStop", params),
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
    loadStop();
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
            'Sửa điểm dừng',
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
                        : stop == null
                            ? Text('')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Wrap(children: [
                                      Text(
                                          'Nhấp trên bản đồ để chọn tọa độ: ',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.orangeAccent)),
                                      Text(
                                          _lat.toString() +
                                              ', ' +
                                              _lng.toString(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black)),
                                      TextField(
                                        controller: TextEditingController(
                                            text: _location),
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập tên điểm dừng*',
                                        ),
                                        onChanged: (value) {
                                          _location = value;
                                        },
                                      ),
                                      MaterialButton(
                                          onPressed: () {
                                            editStop();
                                          },
                                          color: Colors.blueAccent,
                                          textColor: Colors.white,
                                          child: Text('Chỉnh sửa')),
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
                                                    markerId: MarkerId(
                                                        _markerID.toString()),
                                                    infoWindow: InfoWindow(
                                                        title:
                                                            'Điểm dừng mới'),
                                                    position: latlng));
                                                setMarkers =
                                                    Set<Marker>.of(_markers);
                                              });
                                            },
                                            initialCameraPosition:
                                                CameraPosition(
                                                    target: LatLng(10.0324476,
                                                        105.7576498),
                                                    zoom: 13)))
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
