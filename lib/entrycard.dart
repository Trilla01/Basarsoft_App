import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/db_service.dart';
import 'package:flutter_application/pages/activity_details.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application/entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';


  class Entrycard extends StatefulWidget {
  const Entrycard({super.key});

  @override
  State<Entrycard> createState() => _EntrycardState();
}

class _EntrycardState extends State<Entrycard> {
  final DbService _dbService = DbService(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: _buildUI(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Past activities",
        style: TextStyle(
          color: Colors.white,
        ),
      )
    );
  }

  Widget _buildUI(){
    return SafeArea(child: Column(children: [
      _tasksListView(),
    ],));
  }

  Widget _tasksListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _dbService.getEntries(),
        builder: (context, snapshot){
          List entries = snapshot.data?.docs ?? [];
          if (entries.isEmpty) {
            return const Center(
              child: Text("There are no activities to display!"),
            );
          }
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) 
        {
          Entry entry = entries[index].data();
          String entryId = entries[index].id;
          return Padding
          (
            padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
          ),
          child: 
            ListTile
            (
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(DateFormat("dd-MM-yyyy h:m a").format(
              entry.date.toDate(),
            )),
            subtitle: Text((entry.distance / 1000).toStringAsFixed(2) + " km"),
            trailing: ElevatedButton
            (
              child: const Text("View Details"),
              onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetails(routee: entry.routee,
      averageSpeed: entry.speed, // Update with actual value
      totalDistance: entry.distance, // Update with actual value
      duration: entry.duration))
              ,);},
          )
          ,)
          );
        },);
      })
    );
  }
}

