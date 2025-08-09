import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/mac_desktop_apps.dart';
import 'package:portfolio/screens/homescreen/mac_dock.dart';
import 'package:portfolio/screens/homescreen/mac_menu_bar.dart';

class DummyScreen extends StatelessWidget {
  const DummyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // macOS-like blue
              Color(0xFF357ABD),
              Color(0xFF2C5F92),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Desktop background pattern (subtle)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMSIgZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIwLjAzIi8+Cjwvc3ZnPgo=',
                  ),
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),

            // Menu Bar
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
