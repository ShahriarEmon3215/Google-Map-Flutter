import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  var searchController = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final Marker _markerGooglePlex = Marker(
    markerId: MarkerId("_googlePlexMarker"),
    infoWindow: InfoWindow(title: "Google plex"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );

  static final Marker _markerLake = Marker(
    markerId: MarkerId("_googlePlexMarker"),
    infoWindow: InfoWindow(title: "Lake"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.43296265331129, -122.08832357078792),
  );

  // static final Polyline _polyline = Polyline(
  //   polylineId: PolylineId("polyLineID"),
  //   points: [
  //     LatLng(37.43296265331129, -122.08832357078792),
  //     LatLng(37.42796133580664, -122.085749655962),
  //   ],
  //   width: 5,
  // );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Column(
          children: [


            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: searchController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: "Search area.",
                    ),
                    onChanged: (value) {
                      print(value);
                    },
                  )),
                  IconButton(onPressed: () {
                    LocationServices().getPlaceID(searchController.text);
                  }, icon: Icon(Icons.search)),
                ],
              ),
            ),




            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: {
                  _markerGooglePlex,
                  _markerLake,
                },
                // polylines: {
                //   _polyline,
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
