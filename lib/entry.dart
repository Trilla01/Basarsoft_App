import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Entry {
  Timestamp date;
  String duration;
  double speed;
  double distance;
  List<LatLng> routee;

  Entry({
    required this.date,
    required this.duration,
    required this.speed,
    required this.distance,
    required this.routee,
  });

  Entry.fromJson(Map<String, Object?> json)
      : this(
          date: json["date"]! as Timestamp,
          duration: json["duration"] as String,
          speed: json["speed"] as double,
          distance: json["distance"] as double,
          routee: (json["routee"] as List<dynamic>? ?? [])
              .map((item) {
                final geoPoint = item as GeoPoint;
                return LatLng(geoPoint.latitude, geoPoint.longitude);
              })
              .toList(),
        );

  Entry copyWith({
    Timestamp? date,
    String? duration,
    double? speed,
    double? distance,
    List<LatLng>? routee,
  }) {
    return Entry(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      distance: distance ?? this.distance,
      routee: routee ?? this.routee,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "date": date,
      "duration": duration,
      "speed": speed,
      "distance": distance,
      "routee": routee.map((latLng) => GeoPoint(latLng.latitude, latLng.longitude)).toList(),
    };
  }
}
