import 'package:flutter/material.dart';
import 'package:portfolio/screens/appscreen/app_screen.dart';
import 'package:portfolio/screens/appscreen/about_me_screen.dart';

class AboutMeDemo extends StatelessWidget {
  const AboutMeDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wallpaper.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AppScreen(
            title: "About Me",
            windowWidth: 800,
            windowHeight: 600,
            initialPosition: const Offset(100, 100),
            onClose: () {
              // Handle close action
            },
            child: const AboutMeScreen(),
          ),
        ),
      ),
    );
  }
}
