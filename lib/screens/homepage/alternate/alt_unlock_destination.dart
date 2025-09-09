import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/screens/homepage/alternate/unlocked_content.dart';

class AltUnlockDestination extends StatelessWidget {
  const AltUnlockDestination({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: UnlockedContent()
        ),
      ),
    );
  }
}
