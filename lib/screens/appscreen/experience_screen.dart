import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';

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

  String _calculateExperience() {
    int totalExperienceMonths = 0;
    for (var experience in _experiences) {
      final durationString = experience.duration;
      final duration = durationString.split(' ');
      final durationValue = int.parse(duration[0]);
      totalExperienceMonths += durationValue;
    }
    if (totalExperienceMonths >= 12) {
      return "${totalExperienceMonths ~/ 12} years ${totalExperienceMonths % 12} months";
    }
    return "$totalExperienceMonths months";
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      Text('Experience', style: AppDesign.largeTitle),
                      SizedBox(height: 4.h),
                      Text(
                        'My professional journey',
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats in a compact row
                Text(
                  _calculateExperience(),
                  style: AppDesign.title1.copyWith(
                    color: AppDesign.systemBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Blue separator line
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: AppDesign.systemBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 16),
            // Experience list
            Expanded(child: _buildExperienceContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppDesign.systemBlue),
              strokeWidth: 2,
            ),
            SizedBox(height: 12),
            Text(
              'Loading experiences...',
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
              'Error loading experiences',
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

    if (_experiences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'No experiences found',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add some experience data to your Firestore collection',
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

    return ListView.builder(
      itemCount: _experiences.length,
      itemBuilder: (context, index) {
        return _buildCompactExperienceCard(_experiences[index]);
      },
    );
  }

  Widget _getCompanyIcon(String companyName) {
    if (companyName == "Wells Fargo") {
      return Brand(Brands.wellsfargo);
    } else if (companyName == "Samsung PRISM") {
      return Brand(Brands.samsung);
    }
    return Icon(Icons.business_rounded);
  }

  Widget _buildCompactExperienceCard(Experience experience) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Company icon
                Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: _getCompanyIcon(experience.companyName),
                ),
                SizedBox(width: 8.w),

                // Company and role info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.companyName,
                        style: AppDesign.title1.copyWith(
                          color: Colors.black,
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
                          color: AppDesign.systemBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Duration badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppDesign.systemBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppDesign.systemBlue.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    experience.duration,
                    style: AppDesign.body.copyWith(
                      color: AppDesign.systemBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date range
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 12),
                const SizedBox(width: 4),
                Text(
                  '${experience.startDate} - ${experience.endDate}',
                  style: AppDesign.body.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Description paragraphs
            if (experience.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: experience.description
                    .map(
                      (String item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          item,
                          style: AppDesign.body.copyWith(
                            color: Colors.black87,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
