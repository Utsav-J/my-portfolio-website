import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/screens/homepage/alternate/section_1.dart';
import 'package:portfolio/screens/homepage/alternate/section_2.dart';
import 'package:portfolio/screens/homepage/alternate/section_3.dart';
import 'package:portfolio/screens/homepage/alternate/section_4.dart';
import 'package:portfolio/screens/homepage/alternate/snap_scroll_controller.dart';
import 'package:portfolio/screens/homepage/alternate/section_5.dart';
import 'package:snapping_page_scroll/snapping_page_scroll.dart';

class AltUnlockDestination extends StatefulWidget {
  const AltUnlockDestination({super.key});

  @override
  State<AltUnlockDestination> createState() => _AltUnlockDestinationState();
}

class _AltUnlockDestinationState extends State<AltUnlockDestination> {
  late SnapScrollController _snapController;

  @override
  void initState() {
    super.initState();
    _snapController = SnapScrollController();
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  final controller = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X/11/12 baseline
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: SnappingPageScroll(
                controller: controller,
                scrollDirection: Axis.vertical,
                children: [
                  Section1(),
                  Section2(),
                  Section3(),
                  Section4(),
                  Section5(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
