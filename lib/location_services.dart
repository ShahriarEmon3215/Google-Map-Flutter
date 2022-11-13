import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationServices{
  final String key = "AIzaSyA9SK0o7YcS5srrhOGKdSpCy64XnNAa1nI";

  Future<String> getPlaceID(String input)async{
     String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
     var response = await http.get(Uri.parse(url));
     var json = convert.jsonDecode(response.body);
     var placeID = json['candidates'][0]['place_id'] as String;
    print('----------  $placeID');
      return placeID;
  } 

  Future<Map<String, dynamic>> getPlace(String input)async{
    final placeID = await getPlaceID(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  } 

  Future<Map<String, dynamic>> getDestination(String onePlace, String destination) async {
     final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$onePlace&destination=$destination&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    print(json);
    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
       'polyline_decoded': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),

    };
    return results;
  }
}