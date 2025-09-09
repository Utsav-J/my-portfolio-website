import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/screens/homepage/alternate/alt_unlock_destination.dart';

class AltLandingScreen extends StatefulWidget {
  const AltLandingScreen({super.key});

  @override
  State<AltLandingScreen> createState() => _AltLandingScreenState();
}

class _AltLandingScreenState extends State<AltLandingScreen> {
  double _dragX = 0.0;
  bool _unlocked = false;

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
        final double trackWidth = 0.80.sw;
        final double knobSize = 48.r;
        final double maxDrag = trackWidth - knobSize;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 36.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome to Utsav's portfolio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                // Slide to unlock control
                Container(
                  width: trackWidth,
                  height: 48.h,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.sp, color: Colors.white12),
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Instructional text
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'slide to unlock',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      // Draggable knob
                      Positioned(
                        left: _dragX,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (_unlocked) return;
                            final next = (_dragX + details.delta.dx).clamp(
                              0.0,
                              maxDrag,
                            );
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
                              await Future.delayed(
                                const Duration(milliseconds: 120),
                              );
                              if (!mounted) return;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const AltUnlockDestination(),
                                ),
                              );
                            } else {
                              setState(() {
                                _dragX = 0.0;
                              });
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,

                            radius: knobSize,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
