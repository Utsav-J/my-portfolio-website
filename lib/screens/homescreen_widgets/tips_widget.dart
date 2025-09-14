import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';

class TipsWidget extends StatelessWidget {
  const TipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradient: LinearGradient(
        colors: [Colors.black87, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(16.r),
      blur: 20,
      border: Border(
        top: BorderSide(color: Colors.white54, width: 0.5),
        left: BorderSide(color: Colors.white54, width: 1),
      ),

      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Tips',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // Tips
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // First Tip
                    _buildTipCard(
                      'Anything that looks clickable - is clickable, try it out',
                    ),

                    SizedBox(height: 16.h),

                    // Additional Tips
                    _buildTipCard(
                      'Enable `Hardware Acceleration` for a smoother experience',
                    ),
                    // Second Tip
                    SizedBox(height: 16.h),
                    _buildTipCard(
                      'There\'s a lot of clever easter eggs hidden, be on the watch 👀',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String tip) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.lightbulb_fill, color: Colors.amber, size: 14.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                // height: 1.4,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
