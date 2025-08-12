import 'package:flutter/material.dart';
import 'package:portfolio/screens/bootup/bootup_screen.dart';
import 'package:portfolio/screens/homescreen/homescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showBootup = true;

  void _onBootupComplete() {
    setState(() {
      _showBootup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        // child: AboutMeDemo(),
        child: _showBootup
            ? BootupScreen(
                key: const ValueKey('bootup'),
                onBootupComplete: _onBootupComplete,
              )
            : const DummyScreen(key: ValueKey('dummy')),
      ),
    );
  }
}
