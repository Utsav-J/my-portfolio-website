import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/config/app_design.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);

    return SizedBox(
      height: 30.h,
      width: double.infinity,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Text(formattedTime, style: AppDesign.menuBarTime()),

            const Spacer(),
            Row(
              children: [
                Icon(CupertinoIcons.wifi, size: 20.sp),
                SizedBox(width: 8.w),
                Icon(CupertinoIcons.battery_charging, size: 20.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
