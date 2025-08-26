import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/screens/homescreen/dock_icon.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/url_launcher_utils.dart';

class MacDock extends StatelessWidget {
  const MacDock({super.key});

  @override
  Widget build(BuildContext context) {
    final dockApps = [
      DockApp(
        brandName: Brands.linkedin,
        title: 'LinkedIn',
        description:
            'Navigate and explore locations with detailed maps and directions',
        onTap: () {
          UrlLauncherUtils.handleOpenSocials(
            'https://www.linkedin.com/in/iamutsavjaiswal/',
          );
        },
      ),
      DockApp(
        brandName: Brands.github,
        title: 'GitHub',
        description: 'Listen to your favorite songs and discover new music',
        onTap: () {
          UrlLauncherUtils.handleOpenSocials('https://github.com/Utsav-J');
        },
      ),
      DockApp(
        icon: CupertinoIcons.down_arrow,
        title: 'Download CV',
        description: 'Download my resume',
        onTap: () => UrlLauncherUtils.handleDownloadCV(),
      ),
      DockApp(
        brandName: Brands.instagram,
        title: 'Instagram',
        description: 'Organize and edit your memories and images',
        onTap: () {
          UrlLauncherUtils.handleOpenSocials(
            'https://www.instagram.com/acoolstick_/',
          );
        },
      ),
      DockApp(
        brandName: Brands.gmail,
        title: 'GMail',
        description: 'Check current conditions and forecast for your location',
        onTap: () {
          UrlLauncherUtils.handleMailtoLink(
            'utsavjaiswal2004@gmail.com',
            subject: 'Hello Utsav',
            body: 'I just visited your website and ...',
          );
        },
      ),
    ];

    return Center(
      child: GlassContainer(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: dockApps.map((app) => DockIcon(app: app)).toList(),
        ),
      ),
    );
  }
}
