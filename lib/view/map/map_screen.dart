import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lalaco/model/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static CameraPosition _kLake = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  LatLng latLng = LatLng(37.43296265331129, -122.08832357078792);

  static Marker _kGooglePlexMarker = const Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: 'Angels Burger'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(37.43296265331129, -122.08832357078792));

  static Marker _kLakeMarker = Marker(
      markerId: MarkerId('_kLakeMarker'),
      infoWindow: const InfoWindow(title: 'Fishball G'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: LatLng(37.4350, -122.088321));

  Set<Marker> markers = Set();

  // getLocation() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.requestPermission();
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   double lat = position.latitude;
  //   double long = position.longitude;
  //
  //   LatLng location = LatLng(lat, long);
  //
  //   setState(() {
  //     _currentPosition = location;
  //     _isLoading = false;
  //   });
  // }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    var position = await Geolocator.getCurrentPosition();

    setState(() {
      _kGooglePlexMarker = Marker(
          markerId: MarkerId('_kGooglePlex'),
          infoWindow: const InfoWindow(title: 'Angels Burger'),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(position.latitude, position.longitude));
    });

    _kLake = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);

    return position;
  }

  @override
  void initState() {
    handleFetchStores();
    addCustomIcon();
    _goToTheLake();
    super.initState();
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void addCustomIcon() {
    // BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(), "assets/shop.png")
    //     .then(
    //       (icon) {
    //     setState(() {
    //       markerIcon = icon;
    //     });
    //   },
    // );

    getBytesFromAsset('assets/stall.png', 64).then((onValue) {
      setState(() {
        markerIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });
  }

  void handleFetchStores() async {
    List<Store> stores = await fetchStores();

    for (var store in stores) {
      final bitmapIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)), 'assets/shop1.png');
      markers.add(Marker(
        markerId: MarkerId(store.store_name),
        infoWindow: InfoWindow(
            title: store.store_name,
            snippet: store.store_description,
            onTap: () {
              debugPrint(store.store_name);
            }),
        icon: markerIcon,
        position:
            LatLng(double.parse(store.latitude), double.parse(store.longitude)),
      ));
    }
  }

  Future<List<Store>> fetchStores() async {
    var response =
        await http.get(Uri.parse('http://192.168.1.2:8000/api/stores'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['stores'];

    List<Store> stores = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        stores.add(Store.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }

    return stores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (point) {
          setState(() {
            _kLakeMarker = Marker(
                markerId: MarkerId('_kLakeMarker'),
                infoWindow: const InfoWindow(title: 'Fishball G'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange),
                position: point);
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text(
          'My Location',
        ),
        icon: const Icon(Icons.my_location),
        backgroundColor: const Color(0xffff8900),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    await getUserCurrentLocation();

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
