import 'package:flutter/material.dart';
import 'package:portfolio/screens/bootup/bootup_screen.dart';
import 'package:portfolio/screens/homescreen/homescreen.dart';
import 'package:portfolio/screens/homepage/alt_landing_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showBootup = true;
  bool? _useAltLanding; // decided once at startup
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final Size size = MediaQuery.of(context).size;
    final double aspectPortrait = size.height / size.width;
    const double portraitAspectThreshold = 1.2; // treat > 1.2 as portrait-like

    bool useAlt = aspectPortrait > portraitAspectThreshold;
    // Optional backups:
    // final bool narrowWidth = size.width < 700;
    // useAlt = useAlt || narrowWidth;

    setState(() {
      _useAltLanding = useAlt;
      _showBootup = !useAlt; // skip bootup for alt landing (phones)
      _initialized = true;
    });
  }

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
            : (_useAltLanding == true
                  ? const AltLandingScreen(key: ValueKey('altLanding'))
                  : const HomeScreen()),
      ),
    );
  }
}
