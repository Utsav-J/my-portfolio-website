import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/screens/overlays/send_message_overlay.dart';

class UtsavMemoji extends StatelessWidget {
  const UtsavMemoji({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.transparent,
            builder: (context) => SendMessageOverlay(title: "Send a Message!"),
          );
        },
        child: Stack(
          children: [
            GlassContainer(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            Image.asset("assets/images/memoji-removebg.png"),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'say hi',
                  style: AppDesign.caption1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 16.sp,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1), // slight right & down
                        blurRadius: 4, // soft blur
                        color: Colors.black87, // semi-transparent black
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
