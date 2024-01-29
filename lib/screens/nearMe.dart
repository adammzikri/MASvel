// ignore_for_file: unused_import, duplicate_import, unused_field

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:masvel/services/map_services.dart';

import '../services/map_services.dart';
import 'dart:ui' as ui;

class NearScreen extends StatelessWidget {
  NearScreen({super.key});

  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Center(
        child: CurrLocation(),
      ))),
    );
  }
}

class CurrLocation extends StatefulWidget {
  const CurrLocation({super.key});

  @override
  State<CurrLocation> createState() => CurrLocationState();
}

class CurrLocationState extends State<CurrLocation> {
  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController googleMapController;
  final key = 'Your_API_Key';

  Timer? _debounce;

  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;

  Set<Marker> markers = Set<Marker>();
  Set<Marker> _markersDupe = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  int markerIdCounter = 1;
  var radiusValue = 5000.0;
  var tappedPoint;
  List allFavouritePlaces = [];
  String tokenKey = '';

  static final CameraPosition initialPosition = CameraPosition(
    target: LatLng(1.8696575, 103.1163852),
    zoom: 14.4746,
  );

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
  }

  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        markers: markers,
        circles: _circles,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        onTap: (point) {
          _setCircle(point);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 12)));
          setState(() {
            _circles.add(Circle(
                circleId: CircleId('adam'),
                center: LatLng(position.latitude, position.longitude),
                fillColor: Colors.blue.withOpacity(0.1),
                radius: radiusValue,
                strokeColor: Colors.blue,
                strokeWidth: 1));
            getDirections = false;
            searchToggle = false;
            radiusSlider = true;
          });

          markers.clear();

          markers.add(Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude)));

          setState(() {});

          _setNearMarker(
              LatLng point, String label, List types, String status) async {
            var counter = markerIdCounter++;

            final Uint8List markerIcon;

            if (types.contains('restaurants')) {
              markerIcon =
                  await getBytesFromAsset('assets/restaurants.png', 75);
            } else if (types.contains('food')) {
              markerIcon = await getBytesFromAsset('assets/food.png', 75);
            } else if (types.contains('lodging')) {
              markerIcon = await getBytesFromAsset('assets/hotels.png', 75);
            } else {
              markerIcon = await getBytesFromAsset('assets/places.png', 75);
            }

            final Marker marker = Marker(
                markerId: MarkerId('marker_$counter'),
                position: point,
                onTap: () {},
                icon: BitmapDescriptor.fromBytes(markerIcon));

            setState(() {
              markers.add(marker);
            });
          }

          var placesResult = await MapServices().getPlaceDetails(
              LatLng(position.latitude, position.longitude),
              radiusValue.toInt());
          List<dynamic> placesWithin = placesResult['results'] as List;

          allFavouritePlaces = placesWithin;

          tokenKey = placesResult['next_page_token'] ?? 'none';
          markers = {};
          placesWithin.forEach((element) {
            _setNearMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['business_status'] ?? 'not available',
            );
          });
          _markersDupe = markers;
          true;
        },
        backgroundColor: Colors.blueAccent,
        label: const Text('Current Location'),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;

    /*final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));*/
  }
}
