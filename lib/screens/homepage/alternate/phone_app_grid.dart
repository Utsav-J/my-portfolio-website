import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/screens/homepage/alternate/glow_tile.dart';
import 'package:portfolio/screens/homepage/alternate/welcome_screen.dart';
import 'package:portfolio/screens/homepage/alternate/education_screen.dart';
import 'package:portfolio/screens/homepage/alternate/projects_screen.dart';
import 'package:portfolio/screens/homepage/alternate/experience_screen.dart';
import 'package:portfolio/screens/homepage/alternate/contact_screen.dart';
import 'package:portfolio/utils/url_launcher_utils.dart';

class PhoneAppGrid extends StatelessWidget {
  const PhoneAppGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      color: Colors.transparent,
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: GlowTile(
              imageAsset: "assets/images/memoji-removebg.png",
              isApp: false,
              radius: 24.r,
              label: 'Say Hi!',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ContactScreen())),
            ),
          ),
          // four small squares on the right (top two)
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: 'Profile',
              imageAsset: "assets/icons/phone-profile.png",
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const WelcomeScreen())),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              imageAsset: "assets/icons/phone-education.png",
              label: 'Education',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EducationScreen()),
              ),
            ),
          ),
          // next two small squares under them
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: 'Projects',
              imageAsset: "assets/icons/phone-projects.png",
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProjectsScreen())),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              imageAsset: "assets/icons/phone-workexp.png",
              label: 'Experience',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExperienceScreen()),
              ),
            ),
          ),

          // Wide rounded rectangle (spans width) ~2 rows
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: GlowTile(
              radius: 28.r,
              imageAsset: "assets/images/wallpaper.jpg",
              isApp: false,
              label: 'Download Resume',
              onTap: () {},
            ),
          ),

          // Next cluster: four small on left (2x2)
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: "Gmail",
              imageAsset: "assets/icons/phone-gmail.png",
              onTap: () => UrlLauncherUtils.handleMailtoLink(
                'utsavjaiswal2004@gmail.com',
                subject: 'Hello Utsav',
                body: 'I just visited your website and ...',
              ),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: "Instagram",
              imageAsset: "assets/icons/phone-instagram.png",
              onTap: () => UrlLauncherUtils.handleOpenSocials(
                'https://www.instagram.com/acoolstick_/',
              ),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: "GitHub",
              imageAsset: "assets/icons/phone-github.png",
              onTap: () => UrlLauncherUtils.handleOpenSocials(
                'https://github.com/Utsav-J',
              ),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: 'LinkedIn',
              imageAsset: "assets/icons/phone-linkedin.png",
              onTap: () => UrlLauncherUtils.handleOpenSocials(
                'https://www.linkedin.com/in/iamutsavjaiswal/',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
