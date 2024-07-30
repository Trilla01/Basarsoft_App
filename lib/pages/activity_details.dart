import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityDetails extends StatefulWidget {
  final List<LatLng>? routee;
  final double averageSpeed;
  final double totalDistance;
  final String duration;

  const ActivityDetails({
    Key? key,
    required this.routee,
    required this.averageSpeed,
    required this.totalDistance,
    required this.duration,
  }) : super(key: key);

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  final Set<Polyline> polyline = {};
  LatLng center = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    if (widget.routee != null && widget.routee!.isNotEmpty) {
      center = widget.routee!.first;
      polyline.add(Polyline(
        polylineId: PolylineId(widget.routee.toString()),
        visible: true,
        points: widget.routee!,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        color: Colors.deepOrange,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text("Activity Details", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              polylines: polyline,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 16,
              ),
            ),
          ),
          Container(
            height: 250,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
              
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Average Speed:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                Text("${widget.averageSpeed.toStringAsFixed(2)} km/h",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                SizedBox(height: 15),
                Text("Total Distance:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                Text("${(widget.totalDistance / 1000).toStringAsFixed(2)} km",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                SizedBox(height: 15),
                Text("Duration:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                Text(widget.duration,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
