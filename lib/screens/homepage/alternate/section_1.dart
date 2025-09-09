import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/config/app_design.dart';

class Section1 extends StatelessWidget {
  const Section1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: Column(
        children: [
          Lottie.asset("assets/lottie/scrolldown.json", width: 48.w),
          SizedBox(height: 24.h),
          Text(
            'About Me',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'I am a passionate developer with expertise in Flutter, mobile development, and creating innovative solutions. I love building beautiful and functional applications that make a difference.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40.h),

          // Additional scrollable content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                _buildInfoCard('Skills', [
                  'Flutter',
                  'Dart',
                  'Firebase',
                  'UI/UX Design',
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          ...items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    '• $item',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
