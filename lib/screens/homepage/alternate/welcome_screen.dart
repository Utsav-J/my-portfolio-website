import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                              fontSize: 24.sp,
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
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'musician',
                  style: AppDesign.title2.copyWith(
                    color: Colors.white60,
                    fontSize: 20.sp,
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
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
