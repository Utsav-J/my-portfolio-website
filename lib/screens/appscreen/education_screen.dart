import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final Set<int> _showDescriptions = <int>{};

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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Education', style: AppDesign.largeTitle),
                      const SizedBox(height: 2),
                      Text(
                        'Click on the list icon to learn more',
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Refresh button
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildCompactRefreshButton(),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Container(
              width: 40.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: AppDesign.systemBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            SizedBox(height: 6.h),

            Expanded(child: _buildEducationContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.systemBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: _loadEducation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Refresh',
                  style: AppDesign.buttonText(
                    color: Colors.white,
                  ).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 1,
            ),
            SizedBox(height: 12),
            Text(
              'Loading education...',
              style: TextStyle(color: Colors.black87, fontSize: 14),
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
            Icon(Icons.error_outline, color: Colors.red[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'Error loading education',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _error!,
              style: AppDesign.body.copyWith(
                color: Colors.black54,
                fontSize: 12,
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
            Icon(Icons.school_outlined, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'No education data found',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Horizontal scrolling list
    return ListView.builder(
      itemCount: _educationList.length,
      itemBuilder: (context, index) =>
          _buildEducationCard(_educationList[index], index),
      // scrollDirection: Axis.vertical,
      // child: Column(
      //   children: _educationList.map((education) {
      //     return _buildEducationCard(education);
      //   }).toList(),
      // ),
    );
  }

  Widget _buildEducationCard(Education education, int index) {
    return Container(
      width: double.infinity,
      height: 240.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    education.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, color: Colors.grey[500]),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: _showDescriptions.contains(index)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What I did',
                          style: AppDesign.headline.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Expanded(
                          child: Scrollbar(
                            child: ListView.builder(
                              itemCount: education.description.length,
                              itemBuilder: (context, i) {
                                final line = education.description[i];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.h),
                                        child: Icon(
                                          Icons.circle,
                                          size: 6.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          line,
                                          style: AppDesign.body.copyWith(
                                            color: Colors.black87,
                                            fontSize: 15.sp,
                                            height: 1.4.h,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showDescriptions.remove(index);
                                });
                              },
                              child: Icon(
                                Icons.close_fullscreen_rounded,
                                color: Colors.grey[600],
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          education.name,
                          style: AppDesign.title2.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          education.course,
                          style: AppDesign.headline.copyWith(
                            color: AppDesign.systemBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                education.location,
                                style: AppDesign.body.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppDesign.systemGreen.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppDesign.systemGreen.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                education.grades,
                                style: AppDesign.body.copyWith(
                                  color: AppDesign.systemGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showDescriptions.add(index);
                                  });
                                },
                                child: Icon(
                                  Icons.list_alt_rounded,
                                  color: Colors.grey[600],
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
