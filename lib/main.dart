import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_flutter/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId("_googlePlexMarker"),
    infoWindow: InfoWindow(title: 'Google Ples'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );

  var placeOneController = TextEditingController();
  var placeTwoController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> _polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 0;
  int _polylineIdCounter = 0;

  @override
  void initState() {
    super.initState();

    setMarker(LatLng(37.42796133580664, -122.085749655962));
  }

  void setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId("marker"), position: point),
      );
    });
  }

  void setPolyLine(List<PointLatLng> points) {
    final String polylineIdValue = "polyline $_polylineIdCounter";
    _polylineIdCounter++;

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdValue),
      width: 2,
      color: Colors.blue,
      points: points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: placeOneController,
                          decoration: InputDecoration(
                            hintText: "One place.",
                          ),
                        ),
                        TextFormField(
                          controller: placeTwoController,
                          decoration: InputDecoration(
                            hintText: "Destination.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      // var place = await LocationServices().getPlace(searchController.text);
                      // _goToPlace(place);

                      var directions = await LocationServices().getDestination(
                          placeOneController.text, placeTwoController.text);
                      _goToPlace(
                        directions['start_location']['lat'],
                        directions['start_location']['lng'],
                        directions['bounds_ne'],
                        directions['bounds_sw'],
                      );

                      setPolyLine(directions['polyline_decoded']);
                    },
                    icon: Icon(Icons.search)),
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place
    double lat,
    double lng,
    Map<String, dynamic> boundNe,
    Map<String, dynamic> boundSw,
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundSw['lat'], boundSw['lng']),
            northeast: LatLng(boundNe['lat'], boundNe['lng'])),
        25,
      ),
    );

    setMarker(LatLng(lat, lng));
  }
}
