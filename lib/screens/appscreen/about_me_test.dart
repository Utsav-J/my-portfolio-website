import 'package:flutter/material.dart';
import 'package:portfolio/screens/appscreen/about_me_screen.dart';

void main() {
  runApp(const AboutMeTestApp());
}

class AboutMeTestApp extends StatelessWidget {
  const AboutMeTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'About Me Portfolio',
      theme: ThemeData(
        fontFamily: '.AppleSystemUIFont',
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const Scaffold(body: AboutMeScreen()),
    );
  }
}
