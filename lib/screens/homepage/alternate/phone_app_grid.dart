import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/screens/homepage/alternate/glow_tile.dart';

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
              label: 'About Me',
              onTap: () => _showPlaceholderDialog(context, 'About Me'),
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
              onTap: () => _showPlaceholderDialog(context, 'Profile'),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              imageAsset: "assets/icons/phone-education.png",
              label: 'Education',
              onTap: () => _showPlaceholderDialog(context, 'Education'),
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
              onTap: () => _showPlaceholderDialog(context, 'Projects'),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              imageAsset: "assets/icons/phone-workexp.png",
              label: 'Experience',
              onTap: () => _showPlaceholderDialog(context, 'Certifications'),
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
              onTap: () => _showPlaceholderDialog(context, 'Download Resume'),
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
              onTap: () => _showPlaceholderDialog(context, 'Gmail'),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: "Instagram",
              imageAsset: "assets/icons/phone-instagram.png",
              onTap: () => _showPlaceholderDialog(context, 'Instagram'),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: "GitHub",
              imageAsset: "assets/icons/phone-github.png",
              onTap: () => _showPlaceholderDialog(context, 'GitHub'),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(
              isApp: true,
              label: 'LinkedIn',
              imageAsset: "assets/icons/phone-linkedin.png",
              onTap: () => _showPlaceholderDialog(context, 'LinkedIn'),
            ),
          ),

        ],
      ),
    );
  }

  void _showPlaceholderDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('This will open the $title section'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
