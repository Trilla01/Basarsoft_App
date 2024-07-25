import 'dart:convert';

import 'package:flutter_application/weather.dart';
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

}