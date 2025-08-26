import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';

class DockIcon extends StatefulWidget {
  final DockApp app;

  const DockIcon({super.key, required this.app});

  @override
  State<DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<DockIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedScale(
          scale: isHovered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: widget.app.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: isHovered
                  ? EdgeInsets.symmetric(horizontal: 12.w)
                  : EdgeInsets.zero,
              padding: widget.app.title == 'Download CV'
                  ? EdgeInsets.all(12.w)
                  : EdgeInsets.zero,
              decoration: widget.app.title == 'Download CV'
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.transparent,

                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.transparent,
                    ),
              child: Row(
                children: [
                  if (widget.app.icon != null)
                    Icon(widget.app.icon, color: Colors.white, size: 32.w)
                  else
                    Brand(widget.app.brandName, size: 48.w),
                  if (widget.app.title == 'Download CV') SizedBox(width: 8.w),
                  if (widget.app.title == 'Download CV')
                    Text("Download my Resume", style: AppDesign.caption1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
