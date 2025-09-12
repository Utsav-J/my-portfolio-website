import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';
import 'package:portfolio/screens/homepage/alternate/alt_unlock_destination.dart';

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
        color: AppDesign.amoled,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60.h),
                Icon(Icons.school, size: 80.sp, color: Colors.white),
                SizedBox(height: 24.h),
                Text(
                  'Education',
                  style: AppDesign.largeTitle.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
      
                // Horizontal scrolling education carousel
                Expanded(child: _buildEducationContent()),
      
                SizedBox(height: 40.h),
              ],
            ),
            // Exit button
            Positioned(
              top: 40.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AltUnlockDestination()),
                ),
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

    if (_educationList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, color: Colors.grey[400], size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              'No education data found',
              style: AppDesign.title1.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _educationList.length,
      itemBuilder: (context, index) {
        return _buildEducationCard(_educationList[index]);
      },
    );
  }

  Widget _buildEducationCard(Education education) {
    return Container(
      width: 380.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 64.w,
                    height: 64.w,
                    color: Colors.grey[800],
                    child: education.image.isNotEmpty
                        ? Image.network(
                            education.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.school, color: Colors.white60),
                          )
                        : Icon(Icons.school, color: Colors.white60),
                  ),
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
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.white60,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              education.location,
                              style: AppDesign.body.copyWith(
                                color: Colors.white60,
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.star_border_rounded,
                            color: Colors.white70,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            education.grades,
                            style: AppDesign.body.copyWith(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Text(
              education.course,
              style: AppDesign.body.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 14.h),
            Divider(color: Colors.white.withValues(alpha: 0.12), height: 1.h),
            SizedBox(height: 14.h),

            if (education.description.isNotEmpty) ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Highlights',
                      style: AppDesign.headline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ...education.description.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Colors.green[300],
                                size: 14.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                item,
                                style: AppDesign.body.copyWith(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
