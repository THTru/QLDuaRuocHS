import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.0312357, 105.7708309),
    zoom: 10,
  );

  static final CameraPosition _kSchool = CameraPosition(
      target: LatLng(10.0312357, 105.7708309), tilt: 20, zoom: 15);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Bản đồ')),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToSchool,
        label: Text('Tới trường!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToSchool() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kSchool));
  }
}
