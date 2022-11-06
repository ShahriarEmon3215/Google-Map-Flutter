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
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=AIzaSyA9SK0o7YcS5srrhOGKdSpCy64XnNAa1nI';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  } 
}