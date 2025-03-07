import 'dart:convert';

import 'package:flutter_application/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL= "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String city) async {
    final response = await http.get(Uri.parse(
      "$BASE_URL?q=$city&appid=$apiKey&units=metric"
    ));
     

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Can't load weather data!");
    }
  }

  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].subAdministrativeArea;

    return city ?? "";
  }



}