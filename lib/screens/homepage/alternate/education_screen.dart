import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<Education> _educationList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEducation();
  }

  Future<void> _loadEducation() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final List<Education> educationData = await FirebaseUtils.getEducation();

      if (mounted) {
        setState(() {
          _educationList = educationData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load education: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/phonehomescreen.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60.h),
                Text(
                  'Education',
                  style: AppDesign.largeTitle.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                Expanded(child: _buildEducationContent()),

                SizedBox(height: 36.h),
              ],
            ),
            // Exit button
            Positioned(
              top: 40.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: GlassContainer(
                  width: 40.w,
                  height: 40.w,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white30, width: 1.sp),
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 2,
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading education...',
              style: AppDesign.body.copyWith(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              'Error loading education',
              style: AppDesign.title1.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _error!,
              style: AppDesign.body.copyWith(
                color: Colors.white60,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final int total = _educationList.length;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: total,
      itemBuilder: (context, index) {
        final education = _educationList[index];
        final bool isFirst = index == 0;
        final bool isLast = index == total - 1;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 36.w,
                  child: Column(
                    children: [
                      // Top connector
                      Expanded(
                        child: Container(
                          width: 2.w,
                          color: isFirst ? Colors.transparent : Colors.white24,
                        ),
                      ),
                      // Dot
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Bottom connector
                      Expanded(
                        child: Container(
                          width: 2.w,
                          color: isLast ? Colors.transparent : Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(child: _buildEducationCard(education)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEducationCard(Education education) {
    return Container(
      width: 0.75.sw,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Institution icon and name
            Row(
              children: [
                Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  child: education.image.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            education.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.school, color: Colors.white60),
                          ),
                        )
                      : Icon(Icons.school, color: Colors.white60),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        education.name,
                        style: AppDesign.title1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        education.course,
                        style: AppDesign.body.copyWith(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white60,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      education.location,
                      style: AppDesign.body.copyWith(
                        color: Colors.white60,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(
                    education.grades,
                    style: AppDesign.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Description
            if (education.description.isNotEmpty) ...[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: education.description
                        .map(
                          (String item) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              '• $item',
                              style: AppDesign.body.copyWith(
                                color: Colors.white70,
                                fontSize: 13.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
