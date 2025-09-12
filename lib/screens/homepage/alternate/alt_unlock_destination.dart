import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/screens/homepage/alternate/phone_app_grid.dart';
import 'package:portfolio/screens/homepage/alternate/snap_scroll_controller.dart';
import 'package:portfolio/screens/homepage/alternate/status_bar.dart';
import 'package:portfolio/utils/url_launcher_utils.dart';

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
    return Material(
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X/11/12 baseline
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (_, __) {
          return Container(
            width: 1.sw,
            height: 1.sh,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/phonehomescreen.jpg"),
              ),
            ),
            child: Stack(
              children: [
                const StatusBar(),

                // Desktop Apps Grid
                Positioned.fill(top: 30.h, child: PhoneAppGrid()),

                //bottom bar
                Positioned(
                  bottom: 10.w,
                  left: 10.w,
                  right: 10.w,
                  child: InkWell(
                    onTap: () => UrlLauncherUtils.handleDownloadCV(),
                    child: GlassContainer(
                      height: 64.w,
                      border: Border(
                        top: BorderSide(color: Colors.white30, width: 0.5.sp),
                        left: BorderSide(color: Colors.white30, width: 0.5.sp),
                      ),
                      // color: const Color.fromARGB(13, 186, 186, 186),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.download_circle_fill,
                            color: Colors.white,
                          ),
                          Text(
                            "Download My CV",
                            style: AppDesign.largeTitle.copyWith(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
