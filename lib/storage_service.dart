import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService{

  static Future<void> storeUserlocation(String username, String location) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> locs = [location];
    final locations = jsonEncode(locs);
    await prefs.setString(username,locations);
  }

  static Future<String?> getUserlocation(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locs = await prefs.getString(username);
    if (locs == null){
      return null;
    }
    final locations = jsonDecode(locs);
    return locations[0];
  }

  static Future<List<String>?> getLocations(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locs = await prefs.getString(username);
    if(locs == null){
      return null;
    }
    final List<dynamic> locations = jsonDecode(locs);
    return locations.cast<String>();
  }

  static Future<void> addLocation(String username, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locs = await prefs.getString(username);
    if (locs == null){
      return ;
    }
    List<String> locations;
    locations = List<String>.from(jsonDecode(locs));
    locations.add(city);
    prefs.setString(username, jsonEncode(locations));
  }

  static Future<void> removeLocation(String username, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locs = await prefs.getString(username);
    if (locs == null){
      return ;
    }
    List<String> locations;
    locations = List<String>.from(jsonDecode(locs));
    locations.remove(city);
    prefs.setString(username, jsonEncode(locations));
  }

  static Future<bool> isFavoriteCity(String username, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locs = prefs.getString(username);
    if (locs == null) {
      return false;
    }
    final List<dynamic> locations = jsonDecode(locs);
    return locations.contains(city);
  }

}