import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/config/app_design.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 1.sw,
        height: 1.sh,
        color: AppDesign.amoled,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Lottie.asset(
                    "assets/lottie/scrolldown.json",
                    width: 48.w,
                  ),
                ),

                SizedBox(height: 40.h),

                // Greeting text
                Text(
                  'hi, i\'m',
                  style: AppDesign.largeTitle.copyWith(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'utsav',
                  style: AppDesign.largeTitle.copyWith(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Spacer(),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 0.5.sh),
                          child: Image.asset(
                            'assets/images/geminiUtsav.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Download resume button
                    Positioned(
                      bottom: 5.h,
                      child: GlassContainer(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.black12,
                        width: 0.8.sw,
                        height: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 8.h,
                        ),
                        child: Center(
                          child: Text(
                            "Download my Resume",
                            style: AppDesign.largeTitle.copyWith(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Exit button
            Positioned(
              top: 40.h,
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
