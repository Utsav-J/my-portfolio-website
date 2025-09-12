import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlowTile extends StatelessWidget {
  final bool? isApp;
  final double? radius;
  final String? imageAsset;
  final String? label;
  final VoidCallback? onTap;

  const GlowTile({
    super.key,
    this.radius,
    this.isApp,
    this.imageAsset,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isApp == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 58.w,
                  width: 58.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageAsset!),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(radius ?? 16.r),
                  ),
                ),
                SizedBox(height: 2.h),
                Flexible(
                  child: Text(
                    label ?? "Test",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageAsset!),
                  fit: BoxFit.cover,
                ),
                color: Colors.black38,
                borderRadius: BorderRadius.circular(radius ?? 16.r),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    label ?? "Test",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
