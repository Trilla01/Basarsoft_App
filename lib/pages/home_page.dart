import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/auth.dart';
import 'package:flutter_application/pages/live_map_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  
  final User? user = Auth().currentUser;

  Future<void> signOut() async{
    await Auth().signOut();
  }

  Future<void> nextPage() async{
    await Auth().signOut();
  }


  Widget _title(){
    return const Text("Test");
  }

  Widget _userId(){
    return Text(user?.email ?? "User email");
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut,
     child: const Text("Sign Out")
     );
  }

  Widget _nextPageButton(BuildContext context){
    return ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
          },
     child: const Text("Next Page")
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userId(),
            _signOutButton(),
            _nextPageButton(context),
          ],
        ),
      ),
    );
  }
}