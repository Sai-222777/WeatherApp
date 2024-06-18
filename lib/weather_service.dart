import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WeatherService extends ChangeNotifier {
  String apiKey = '9f64cd0720440d5259fd4a5db1a1372e';
  Map<String, dynamic> cityWeatherData = {};
  late String condition;
  String? icon;
  int? temp,pressure,humidity;
  bool isLoading = true;
  double? visibility,speed;

  Future<void> loadData(String location) async{
    isLoading = true;
    final response = await get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey'));
    if(response.statusCode == 200)
    {
    final data = jsonDecode(response.body);
    condition = data['weather'][0]['main'];
    icon = data['weather'][0]['icon'];
    temp = (data['main']['temp'] - 273).round();
    pressure = (data['main']['pressure']).round();
    humidity = (data['main']['humidity']).round();
    visibility = data['visibility']/1000;
    speed = data['wind']['speed'];
    }
    else
    {
      condition = 'Error';
      temp = null;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadCityWeatherData(List<String> cities) async {
    isLoading = true;
    cityWeatherData.clear();
    notifyListeners();

    for (var city in cities) {
      final response = await get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'));
      if (response.statusCode == 200) 
      {
        final data = jsonDecode(response.body);
        cityWeatherData[city] = {
          'condition': data['weather'][0]['main'],
          'temp': (data['main']['temp'] - 273).round(),
        };
      } 
      else 
      {
        cityWeatherData[city] = {
          'condition': 'Error',
          'temp': null,
        };
      }
    }

    isLoading = false;
    notifyListeners();
  }

}