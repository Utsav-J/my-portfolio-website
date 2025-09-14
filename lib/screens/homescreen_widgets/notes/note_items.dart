import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/config/app_design.dart';

class NoteItem extends StatelessWidget {
  final String title;
  final String content;
  const NoteItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [const Color.fromARGB(8, 255, 255, 255), Colors.white24],
          center: Alignment.topLeft,
          radius: AppDesign.largeRadius,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: GoogleFonts.shantellSans(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              content,
              style: GoogleFonts.shantellSans(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThoughtNoteItem extends StatelessWidget {
  final String content;
  const ThoughtNoteItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [const Color.fromARGB(8, 255, 255, 255), Colors.white24],
          center: Alignment.topLeft,
          radius: AppDesign.largeRadius,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          content,
          style: GoogleFonts.shantellSans(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
