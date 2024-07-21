import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:flutter_application/widget_tree.dart';
import 'package:lottie/lottie.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Expanded(child:Center(
            child: LottieBuilder.asset("assets/splash1.json"),
          ) )
        ],
      ), 
      nextScreen: const WidgetTree(),
      splashIconSize: 200,
      backgroundColor: Colors.blueAccent,);

  }
}