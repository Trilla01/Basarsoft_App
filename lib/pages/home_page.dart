import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/auth.dart';
import 'package:flutter_application/db_service.dart';
import 'package:flutter_application/pages/activity_details.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application/entrycard.dart';
import 'package:flutter_application/pages/live_map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DbService _dbService = DbService(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _dbService.getUserData(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found.'));
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final name = userData['name'] ?? 'No name';
            final surname = userData['surname'] ?? 'No surname';
            final email = FirebaseAuth.instance.currentUser?.email ?? "No email";

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _dbService.getEntries(),
                      builder: (context, snapshot) {
                        int activityCount = snapshot.hasData ? snapshot.data!.size : 0;

                        return Container(
                          width: double.infinity, // Make the container take up full width
                          constraints: BoxConstraints(
                            maxWidth: 600, // Maximum width for larger screens
                            minHeight: 250, // Minimum height to make it "fat"
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1), // Background color with transparency
                            border: Border.all(
                              color: theme.colorScheme.primary, // Border color
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          padding: const EdgeInsets.all(20.0), // Padding inside the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email:",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, fontWeight: FontWeight.w300)),
                              Text(email,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20, fontWeight: FontWeight.w400)),
                              SizedBox(height: 15), // Space between sections
                              Text("Name:",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, fontWeight: FontWeight.w300)),
                              Text(name,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30, fontWeight: FontWeight.w400)),
                              SizedBox(height: 15), // Space between sections
                              Text("Surname:",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, fontWeight: FontWeight.w300)),
                              Text(surname,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30, fontWeight: FontWeight.w400)),
                              SizedBox(height: 15), // Space between sections
                              Text("Activity Count",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, fontWeight: FontWeight.w300)),
                              Text(activityCount.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20), // Space between container and buttons
                    ElevatedButton(
                      onPressed: signOut,
                      child: const Text("Sign Out"),
                    ),
                    SizedBox(height: 20), // Space between buttons
                    ElevatedButton(
                      onPressed: () => nextPage(context),
                      child: const Text("Past Activities"),
                    ),
                    SizedBox(height: 10), // Space between buttons
                    ElevatedButton(
                      onPressed: () => nextPage2(context),
                      child: const Text("Start an Activity"),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> nextPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Entrycard()));
  }

  Future<void> nextPage2(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
  }
}
