import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/weather.dart';
import 'package:flutter_application/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application/db_service.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_application/entry.dart';

Location _location = Location();
LatLng loc = LatLng(0, 0);
bool firstPress = false;
StreamSubscription<LocationData>? locationSubscription;
StreamSubscription<LocationData>? locationSubscription2;

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final _weatherService = WeatherService("49e4e6d626e51e19c365861dc750971e");
  Weather? _weather;
  final DbService _dbService = DbService(FirebaseAuth.instance.currentUser!.uid);
  late AnimationController acontroller;
  final Set<Polyline> polyline = {};
  late GoogleMapController _mapController;
  LatLng _center = const LatLng(0, 0);
  List<LatLng> route = [];

  double _dist = 0;
  late String _displayTime;
  late int _time;
  late int _lastTime;
  double _speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  bool _isLoading = true;
  bool _isRunning = false; // Track if the timer is running

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  

  @override
  void initState() {
    super.initState();
    firstPress = false;
    _fetchWeather();
    acontroller = AnimationController(
        duration: Duration(milliseconds: 200), vsync: this);

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
    _stopWatchTimer.onStopTimer();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
    acontroller.dispose();
    locationSubscription!.cancel();
    locationSubscription2!.cancel();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;
    locationSubscription2 = _location.onLocationChanged.listen((event) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 15)));

      if (firstPress == true) {
        if (route.length > 0) {
          appendDist = Geolocator.distanceBetween(route.last.latitude,
              route.last.longitude, loc.latitude, loc.longitude);
          _dist = _dist + appendDist;
          int timeDuration = (_time - _lastTime);

          if (_lastTime != null && timeDuration != 0) {
            _speed = (appendDist / (timeDuration / 100)) * 3.6;
            if (_speed != 0) {
              _avgSpeed = _avgSpeed + _speed;
              _speedCounter++;
            }
          }
        }
        _lastTime = _time;
        route.add(loc);

        polyline.add(Polyline(
            polylineId: PolylineId(event.toString()),
            visible: true,
            points: route,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            color: Colors.deepOrange));
      }
      setState(() {});
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "New Activity",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(children: [
          GoogleMap(
            polylines: polyline,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 70,
            left: MediaQuery.of(context).size.width / 20,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: (Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_weather?.cityName ?? "Loading city...",
                      style: GoogleFonts.montserrat(
                          fontSize: 13, fontWeight: FontWeight.w400)),
                  Text("${_weather?.temperature.round()}°C",
                      style: GoogleFonts.montserrat(
                          fontSize: 13, fontWeight: FontWeight.w400)),
                          Text(_weather!.condition,
                      style: GoogleFonts.montserrat(
                          fontSize: 13, fontWeight: FontWeight.w400))
                ],
              )),
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 40),
                    height: 150,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("SPEED (KM/H)",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300)),
                                Text(_speed.toStringAsFixed(2),
                                    style: GoogleFonts.montserrat(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                            Column(
                              children: [
                                Text("TIME",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300)),
                                StreamBuilder<int>(
                                  stream: _stopWatchTimer.rawTime,
                                  initialData: 0,
                                  builder: (context, snap) {
                                    _time = snap.data!;
                                    _displayTime =
                                        StopWatchTimer.getDisplayTimeHours(
                                                _time) +
                                            ":" +
                                            StopWatchTimer.getDisplayTimeMinute(
                                                _time) +
                                            ":" +
                                            StopWatchTimer.getDisplayTimeSecond(
                                                _time);
                                    return Text(_displayTime,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300));
                                  },
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text("DISTANCE (KM)",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300)),
                                Text((_dist / 1000).toStringAsFixed(2),
                                    style: GoogleFonts.montserrat(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w300))
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        FloatingActionButton(
                          child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                          onPressed: () async {
                            if (_isRunning) {
                              acontroller.stop();
                              _stopWatchTimer.onStopTimer();
                              _isRunning = false;
                            } else {
                              acontroller.forward(from: 0.0);
                              _stopWatchTimer.onStartTimer();
                              _isRunning = true;
                            }
                            setState(() {});

                            if (firstPress == false) {
                              firstPress = true;
                            } else {
                              Entry en = Entry(
                                  routee: route,
                                  date: Timestamp.fromDate(DateTime.now()),
                                  duration: _displayTime,
                                  speed: _speedCounter == 0
                                      ? 0
                                      : _avgSpeed / _speedCounter,
                                  distance: _dist);
                              _dbService.addEntry(en);
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                                locationSubscription!.cancel();
                                locationSubscription2!.cancel();
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
        ]));
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription =
        _location.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          loc = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }
}
