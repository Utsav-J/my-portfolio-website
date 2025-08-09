import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class BootupScreen extends StatefulWidget {
  final VoidCallback? onBootupComplete;

  const BootupScreen({Key? key, this.onBootupComplete}) : super(key: key);

  @override
  State<BootupScreen> createState() => _BootupScreenState();
}

class _BootupScreenState extends State<BootupScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  bool _showProgress = false;

  @override
  void initState() {
    super.initState();

    // Animation controller for fade in effect
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animation controller for progress bar
    _progressController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _startBootupSequence();
  }

  void _startBootupSequence() async {
    // Start fade in animation and show progress bar instantly
    _fadeController.forward();

    setState(() {
      _showProgress = true;
    });

    // Start progress animation immediately after showing components
    _progressController.forward();

    // Wait for 4 seconds before completing bootup
    await Future.delayed(const Duration(seconds: 4));

    // Call the callback if provided
    if (mounted && widget.onBootupComplete != null) {
      widget.onBootupComplete!();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1A1A1A), // Darker edges
              Color(0xFF000000), // Black corners
            ],
            stops: [0.7, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main content area
            Expanded(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "hello" text
                      Lottie.asset("assets/lottie/welcome.json"),
                      const SizedBox(height: 60),

                      // Progress bar area
                      AnimatedOpacity(
                        opacity: _showProgress ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            Text(
                              'Booting Up...',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 200,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 200 * _progressAnimation.value,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom area - you can add a "Get Started" button here if needed
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: AnimatedOpacity(
                opacity: _showProgress ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
