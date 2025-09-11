import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneAppGrid extends StatelessWidget {
  const PhoneAppGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        children: [
          // Row group 1 - big square (2x2) on left
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: GlowTile(radius: 24.r),
          ),
          // four small squares on the right (top two)
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),
          // next two small squares under them
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),

          // Wide rounded rectangle (spans width) ~2 rows
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: GlowTile(radius: 28.r),
          ),

          // Next cluster: four small on left (2x2)
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),
          const StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: GlowTile(),
          ),

          // Big square on right (2x2)
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: GlowTile(radius: 24.r),
          ),
        ],
      ),
    );
  }
}

class GlowTile extends StatelessWidget {
  final double? radius;
  const GlowTile({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius ?? 16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.12),
            blurRadius: 24.r,
            spreadRadius: 2.r,
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 0.5,
        ),
      ),
    );
  }
}
