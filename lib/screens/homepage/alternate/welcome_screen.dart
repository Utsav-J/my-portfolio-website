import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  int _currentTextIndex = 0;

  final List<String> _transitionTexts = [
    'i make user-centric apps',
    'i make cool designs',
    'i make good music (subjective)',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 seconds total per text
      vsync: this,
    );

    // Fade in animation (first 25% of duration)
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOut),
      ),
    );

    // Fade out animation (last 25% of duration)
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );

    _startTextTransition();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startTextTransition() {
    _animationController.forward().then((_) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _transitionTexts.length;
        });
        _animationController.reset();
        _startTextTransition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/utsav_aboutme.jpg"),
            fit: BoxFit.cover,
            // light black overlay color filter
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.2),
              BlendMode.darken,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 10.w),
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'hi, i\'m',
                            style: AppDesign.body.copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),
                        Center(
                          child: Text(
                            'Utsav Jaiswal',
                            style: AppDesign.largeTitle.copyWith(
                              color: Colors.white,
                              fontSize: 55.sp,
                              shadows: [
                                // light black shadow behind the text
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 16.r,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // Transitioning text component
                        Center(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              double opacity = 1.0;

                              // Determine which animation to use based on progress
                              if (_animationController.value <= 0.25) {
                                // Fade in phase
                                opacity = _fadeInAnimation.value;
                              } else if (_animationController.value >= 0.75) {
                                // Fade out phase
                                opacity = _fadeOutAnimation.value;
                              }
                              // Between 0.25 and 0.75, text is fully visible (opacity = 1.0)

                              return Opacity(
                                opacity: opacity,
                                child: Text(
                                  _transitionTexts[_currentTextIndex],
                                  style: AppDesign.body.copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    shadows: [
                                      // light black
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 16.r,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Text(
                        //   "I'm a passionate full-stack app developer. I specialize in crafting robust, AI-powered, user-centric applications using modern frameworks and industry best practices. Beyond tech, I'm a musician who enjoys creating and performing music. I also click one good picture and use it everywhere for the next 3 years.",
                        //   style: AppDesign.body.copyWith(
                        //     color: Colors.white70,
                        //     backgroundColor: Colors.black26,
                        //     fontSize: 14.sp,
                        //     fontWeight: FontWeight.w600,
                        //     letterSpacing: 0.2,
                        //     shadows: [
                        //       // light black shadow behind the text
                        //       Shadow(
                        //         color: Colors.black.withValues(alpha: 0.8),
                        //         blurRadius: 16.r,
                        //         offset: const Offset(0, 0),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // Main name
                Spacer(), // Large empty space
                // Role descriptions
                Text(
                  'app developer',
                  style: AppDesign.title2.copyWith(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),

                Text(
                  'gen-ai developer ',
                  style: AppDesign.title2.copyWith(
                    color: Colors.white70,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'musician',
                  style: AppDesign.title2.copyWith(
                    color: Colors.white60,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),

                SizedBox(height: 40.h),

                // Disclaimer
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '*not a ranked list, just looks cool',
                    style: AppDesign.caption1.copyWith(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),

            // Exit button
            Positioned(
              top: 0.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: GlassContainer(
                  width: 40.w,
                  height: 40.w,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white30, width: 1.sp),
                  child: Icon(Icons.close, color: Colors.white, size: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
