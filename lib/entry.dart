import 'package:cloud_firestore/cloud_firestore.dart';


class Entry {

  Timestamp date;
  String duration;
  double speed;
  double distance;

  Entry({required this.date,required this.duration,required this.speed,required this.distance});

  Entry.fromJson(Map<String, Object?> json):
    this (
      date: json["date"]! as Timestamp,
      duration: json["duration"] as String,
      speed: json["speed"] as double,
      distance: json["distance"] as double,
    );

  Entry copyWith({
    Timestamp? date,
    String? duration,
    double? speed,
    double? distance,
  }
  ){
    return Entry(date: date ?? this.date, duration: duration?? this.duration, speed: speed?? this.speed, distance: distance?? this.distance);
  }

  Map<String, Object?> toJson(){
    return{
      "date" : date,
      "duration" : duration,
      "speed" : speed, 
      "distance" : distance,
    };
  }
}