import 'package:flutter/material.dart';
import 'package:flutter_application/auth.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:flutter_application/pages/loginandregister_page.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

@override
  State<WidgetTree> createState() => _WidgetTreeState();

}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}