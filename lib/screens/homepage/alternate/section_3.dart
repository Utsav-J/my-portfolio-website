
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';

class Section3 extends StatelessWidget {
  const Section3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Icon(Icons.school, size: 80.sp, color: Colors.white),
          SizedBox(height: 24.h),
          Text(
            'Education',
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
                _buildEducationItem(
                  'Bachelor of Computer Science',
                  'University of Technology',
                  '2015 - 2019',
                  'GPA: 3.8/4.0\nRelevant Coursework: Data Structures, Algorithms, Software Engineering, Database Systems, Mobile Development',
                ),
                SizedBox(height: 16.h),
                _buildEducationItem(
                  'High School Diploma',
                  'Tech High School',
                  '2013 - 2015',
                  'Graduated with honors\nFocus: Mathematics, Physics, Computer Science',
                ),
                SizedBox(height: 20.h),
                _buildEducationItem(
                  'Online Certifications',
                  'Various Platforms',
                  '2019 - Present',
                  'Flutter Development, Firebase, UI/UX Design, Project Management, Agile Methodologies',
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Text(
              'Swipe up to continue',
              style: TextStyle(
                color: Colors.green,
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

  Widget _buildEducationItem(
    String degree,
    String institution,
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
            degree,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            institution,
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
