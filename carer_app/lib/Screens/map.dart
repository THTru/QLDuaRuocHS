import 'dart:convert';
// import 'dart:io';

import 'package:carer_app/Screens/studentstriplist.dart';
import 'package:flutter/material.dart';
import 'package:carer_app/rounded_button.dart';
import 'package:carer_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// import 'package:parent_app/Screens/map.dart';

class MapScreen extends StatefulWidget {
  var stop;
  MapScreen({Key? key, @required this.stop}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState(stop);
}

class _MapScreenState extends State<MapScreen> {
  final stop;
  _MapScreenState(this.stop);

  List<Marker> _markers = [];

  loadStop() async {
    final stopdata = jsonDecode(stop);
    if (stop != null) {
      _markers.add(Marker(
          markerId: MarkerId('ID'),
          infoWindow: InfoWindow(title: stopdata['location'].toString()),
          position: LatLng(stopdata['lat'], stopdata['lng'])));
    }
  }

  @override
  void initState() {
    super.initState();
    loadStop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Điểm đón học sinh',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers),
              initialCameraPosition: CameraPosition(
                target: LatLng(10.0312357, 105.7708309),
                zoom: 13,
              ),
            )));
  }
}
