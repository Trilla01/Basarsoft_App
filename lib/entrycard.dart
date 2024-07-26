import 'package:flutter/material.dart';
import 'package:flutter_application/db_service.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application/entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


  class Entrycard extends StatefulWidget {
  const Entrycard({super.key});

  @override
  State<Entrycard> createState() => _EntrycardState();
}

class _EntrycardState extends State<Entrycard> {
  final DbService _dbService = DbService();

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())
              ,);},
          )
          ,)
          );
        },);
      })
    );
  }
}







   /*@override
 Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.date, style: GoogleFonts.montserrat(fontSize: 18)),
                  Text((entry.distance / 1000).toStringAsFixed(2) + " km",
                      style: GoogleFonts.montserrat(fontSize: 18)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.duration,
                      style: GoogleFonts.montserrat(fontSize: 14)),
                  Text(entry.speed.toStringAsFixed(2) + " km/h",
                      style: GoogleFonts.montserrat(fontSize: 14)),
                ],
              )
            ],
          )),
    );
  }*/