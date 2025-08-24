import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkillButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isHighlighted;
  final List<Color>? gradient;

  const SkillButton(
    this.label,
    this.iconPath,
    this.isHighlighted, {
    this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isHighlighted && gradient != null
            ? LinearGradient(
                colors: gradient!,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isHighlighted ? null : const Color(0xFF1F2937),
        border: isHighlighted
            ? null
            : Border.all(color: const Color(0xFF374151), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 20.w,
            height: 20.h,
            errorBuilder: (context, error, stackTrace) =>
                SizedBox(width: 20.w, height: 20.h),
          ),
          SizedBox(width: 8.w),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isHighlighted
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
