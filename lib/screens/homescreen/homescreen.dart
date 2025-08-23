import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/mac_desktop_apps.dart';
import 'package:portfolio/screens/homescreen/mac_dock.dart';
import 'package:portfolio/screens/homescreen/mac_menu_bar.dart';

class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wallpaper.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const MacMenuBar(),

            // Desktop Apps Grid
            const Positioned.fill(top: 30, child: MacDesktopApps()),

            // Dock
            const Positioned(bottom: 20, left: 0, right: 0, child: MacDock()),
          ],
        ),
      ),
    );
  }
}
