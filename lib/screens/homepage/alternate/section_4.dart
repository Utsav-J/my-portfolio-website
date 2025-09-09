import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';

class Section4 extends StatelessWidget {
  const Section4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Icon(Icons.code, size: 80.sp, color: Colors.white),
          SizedBox(height: 24.h),
          Text(
            'Projects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                _buildProjectItem(
                  'Portfolio App',
                  'Flutter, Firebase',
                  'A beautiful portfolio app with snap-scroll sections, Firebase integration, and responsive design. Features include dynamic content loading, smooth animations, and mobile-optimized UI.',
                ),
                SizedBox(height: 16.h),
                _buildProjectItem(
                  'E-commerce App',
                  'Flutter, Node.js, MongoDB',
                  'Full-stack shopping application with user authentication, product catalog, shopping cart, payment integration, and admin dashboard. Supports real-time updates and notifications.',
                ),
                SizedBox(height: 16.h),
                _buildProjectItem(
                  'Weather App',
                  'Flutter, OpenWeather API',
                  'Real-time weather application with location-based forecasts, interactive maps, weather alerts, and customizable widgets. Includes offline caching and background updates.',
                ),
                SizedBox(height: 16.h),
                _buildProjectItem(
                  'Task Management App',
                  'Flutter, SQLite, Provider',
                  'Productivity app with task organization, team collaboration features, deadline tracking, and progress analytics. Supports multiple project views and team management.',
                ),
                SizedBox(height: 16.h),
                _buildProjectItem(
                  'Social Media App',
                  'Flutter, Firebase, Cloud Functions',
                  'Social platform with real-time messaging, photo sharing, story features, and community building tools. Includes advanced privacy controls and content moderation.',
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: Text(
              'Swipe up to continue',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildProjectItem(String title, String tech, String description) {
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
          SizedBox(height: 4.h),
          Text(
            tech,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
