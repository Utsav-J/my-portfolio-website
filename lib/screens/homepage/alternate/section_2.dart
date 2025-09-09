
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';

class Section2 extends StatelessWidget {
  const Section2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Icon(Icons.work, size: 80.sp, color: Colors.white),
          SizedBox(height: 24.h),
          Text(
            'Experience',
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
                _buildExperienceItem(
                  'Senior Flutter Developer',
                  'Tech Corp',
                  '2022 - Present',
                  'Led mobile app development team, implemented complex UI components and optimized app performance.',
                ),
                SizedBox(height: 16.h),
                _buildExperienceItem(
                  'Mobile Developer',
                  'StartupXYZ',
                  '2020 - 2022',
                  'Developed cross-platform mobile applications using Flutter, integrated third-party APIs and services.',
                ),
                SizedBox(height: 16.h),
                _buildExperienceItem(
                  'Junior Developer',
                  'WebSolutions',
                  '2019 - 2020',
                  'Assisted in web and mobile development projects, learned modern development practices and tools.',
                ),
                SizedBox(height: 20.h),
                _buildExperienceItem(
                  'Freelance Developer',
                  'Various Clients',
                  '2018 - 2019',
                  'Worked on small-scale projects, built custom solutions for local businesses and startups.',
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.purple, width: 1),
            ),
            child: Text(
              'Swipe up to continue',
              style: TextStyle(
                color: Colors.purple,
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

  Widget _buildExperienceItem(
    String title,
    String company,
    String period,
    String description,
  ) {
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
            company,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            period,
            style: TextStyle(color: Colors.white60, fontSize: 12.sp),
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
