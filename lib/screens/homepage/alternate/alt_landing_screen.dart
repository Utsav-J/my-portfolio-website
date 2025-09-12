import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/screens/homepage/alternate/alt_unlock_destination.dart';
import 'package:intl/intl.dart';

class AltLandingScreen extends StatefulWidget {
  const AltLandingScreen({super.key});

  @override
  State<AltLandingScreen> createState() => _AltLandingScreenState();
}

class _AltLandingScreenState extends State<AltLandingScreen> {
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update time every second
    _updateTime();
  }

  void _updateTime() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
        _updateTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        390,
        844,
      ), // phone-friendly baseline (iPhone 12/13)
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/phonewallpaper.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 36.h),
                Center(child: DateTimeDisplay(currentTime: _currentTime)),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Notification(),
                    SizedBox(height: 40.h),
                    SlideToUnlock(),
                  ],
                ),

                SizedBox(height: 36.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SlideToUnlock extends StatefulWidget {
  const SlideToUnlock({super.key});

  @override
  State<SlideToUnlock> createState() => _SlideToUnlockState();
}

class _SlideToUnlockState extends State<SlideToUnlock> {
  double _dragX = 0.0;
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    Route slideRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    final double knobSize = 32.r;
    final double maxDrag =
        (0.85.sw - 32.w - knobSize); // Account for padding and knob size

    return GlassContainer(
      padding: EdgeInsets.all(16.w),
      width: 0.85.sw,
      borderRadius: BorderRadius.circular(48.r),
      border: Border(
        top: BorderSide(color: Colors.white30, width: 0.5.sp),
        left: BorderSide(color: Colors.white30, width: 1.sp),
      ),
      child: SizedBox(
        height: 48.h,
        child: Stack(
          children: [
            // Instructional text
            Positioned.fill(
              child: Center(
                child: Text(
                  'slide to unlock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            Positioned(
              left: _dragX,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (_unlocked) return;
                  final next = (_dragX + details.delta.dx).clamp(0.0, maxDrag);
                  setState(() {
                    _dragX = next;
                  });
                },
                onHorizontalDragEnd: (details) async {
                  if (_unlocked) return;
                  final progressed = _dragX / maxDrag;
                  if (progressed >= 0.9) {
                    setState(() {
                      _dragX = maxDrag;
                      _unlocked = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 120));
                    if (!mounted) return;
                    Navigator.of(
                      context,
                    ).pushReplacement(slideRoute(const AltUnlockDestination()));
                  } else {
                    setState(() {
                      _dragX = 0.0;
                    });
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30.r,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: Colors.black,
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

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.all(16.w),
      width: 0.85.sw,
      borderRadius: BorderRadius.circular(16.r),
      border: Border(
        top: BorderSide(color: Colors.white30, width: 0.5.sp),
        left: BorderSide(color: Colors.white30, width: 1.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with app icon, title, and timestamp
          Row(
            children: [
              // Reminders app icon
              Icon(CupertinoIcons.bell_fill, size: 24.w),
              SizedBox(width: 12.w),
              // App name
              Text(
                'Reminder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Timestamp
              Text(
                'Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Message content
          Text(
            "You're viewing a limited, mobile-optimized version of this website. For the full experience, visit on a larger screen :)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeDisplay extends StatelessWidget {
  final DateTime currentTime;

  const DateTimeDisplay({super.key, required this.currentTime});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('H:mm');

    final formattedDate = dateFormat.format(currentTime);
    final formattedTime = timeFormat.format(currentTime);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date
        Text(
          formattedDate,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        // Time
        Text(
          formattedTime,
          style: AppDesign.largeTitle.copyWith(
            color: Colors.white,
            fontSize: 96.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
