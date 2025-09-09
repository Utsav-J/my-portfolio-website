import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';

class Section5 extends StatelessWidget {
  const Section5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Icon(Icons.contact_mail, size: 80.sp, color: Colors.white),
          SizedBox(height: 24.h),
          Text(
            'Contact',
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
                _buildContactItem(
                  Icons.email,
                  'utsav@example.com',
                  'Send me an email for any inquiries or collaboration opportunities.',
                ),
                SizedBox(height: 16.h),
                _buildContactItem(
                  Icons.phone,
                  '+1 (555) 123-4567',
                  'Available for calls Monday to Friday, 9 AM - 6 PM PST.',
                ),
                SizedBox(height: 16.h),
                _buildContactItem(
                  Icons.location_on,
                  'San Francisco, CA',
                  'Based in the heart of Silicon Valley, open to remote work and local meetups.',
                ),
                SizedBox(height: 16.h),
                _buildContactItem(
                  Icons.link,
                  'github.com/utsav',
                  'Check out my open source projects and contributions on GitHub.',
                ),
                SizedBox(height: 16.h),
                _buildContactItem(
                  Icons.work,
                  'LinkedIn Profile',
                  'Connect with me professionally and view my detailed work experience.',
                ),
                SizedBox(height: 16.h),
                _buildContactItem(
                  Icons.code,
                  'Portfolio Website',
                  'Visit my personal website for more detailed project showcases and blog posts.',
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.indigo, width: 1),
            ),
            child: Text(
              'End of Portfolio',
              style: TextStyle(
                color: Colors.indigo,
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

  Widget _buildContactItem(IconData icon, String text, String description) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
