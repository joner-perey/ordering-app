import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => SelectLocationPageState();
}

class SelectLocationPageState extends State<SelectLocationPage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();


  static Marker selectedPositionMarker = Marker(
      markerId: const MarkerId('selectedPositionMarker'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
  );

  static CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(14.259053930524896, 121.13337276380922),
    zoom: 16,
  );

  @override
  void initState() {
    displayCurrentLocation();
    super.initState();
  }


  Future<void> displayCurrentLocation() async {
    await getUserCurrentLocation();

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    var position = await Geolocator.getCurrentPosition();

    setState(() {
      selectedPositionMarker = Marker(
          markerId: const MarkerId('selectedPositionMarker'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: LatLng(position.latitude, position.longitude)
      );
    });



    currentCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16);


    return position;
  }



  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          selectedPositionMarker
        },
        initialCameraPosition: currentCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (point) {
          setState(() {
            selectedPositionMarker = Marker(
                markerId: const MarkerId('selectedPositionMarker'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                position: point
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, selectedPositionMarker.position);
        },
        label: const Text('Confirm Location'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.orange,
      ),
    );
  }


}