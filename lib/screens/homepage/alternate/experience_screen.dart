import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';
import 'package:portfolio/screens/homepage/alternate/alt_unlock_destination.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  List<Experience> _experiences = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  Future<void> _loadExperiences() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final List<Experience> experiences = await FirebaseUtils.getExperiences();

      if (mounted) {
        setState(() {
          _experiences = experiences;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load experiences: $e';
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
                Text(
                  'Experience',
                  style: AppDesign.largeTitle.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
      
                // Horizontal scrolling experience carousel
                Expanded(child: _buildExperienceContent()),
      
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

  Widget _buildExperienceContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              strokeWidth: 2,
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading experiences...',
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
              'Error loading experiences',
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

    if (_experiences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, color: Colors.grey[400], size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              'No experiences found',
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
      itemCount: _experiences.length,
      itemBuilder: (context, index) {
        return _buildExperienceCard(_experiences[index]);
      },
    );
  }

  Widget _getCompanyIcon(String companyName) {
    if (companyName == "Wells Fargo") {
      return Brand(Brands.wellsfargo);
    } else if (companyName == "Samsung PRISM") {
      return Brand(Brands.samsung);
    }
    return Icon(Icons.business_rounded, color: Colors.white70);
  }

  Widget _buildExperienceCard(Experience experience) {
    return Container(
      width: 300.w,
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
            // Company icon and name
            Row(
              children: [
                Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  child: _getCompanyIcon(experience.companyName),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.companyName,
                        style: AppDesign.title1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        experience.role,
                        style: AppDesign.body.copyWith(
                          color: Colors.purple[300],
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white60,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${experience.startDate} - ${experience.endDate}',
                      style: AppDesign.body.copyWith(
                        color: Colors.white60,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Duration badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(
                    experience.duration,
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
            if (experience.description.isNotEmpty) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: experience.description
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
