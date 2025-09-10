import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';

class Section4 extends StatefulWidget {
  const Section4({super.key});

  @override
  State<Section4> createState() => _Section4State();
}

class _Section4State extends State<Section4> {
  List<Project> _projects = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final List<Project> projects = await FirebaseUtils.getProjects();

      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load projects: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Icon(Icons.code, size: 80.sp, color: Colors.white),
          SizedBox(height: 24.h),
          Text(
            'Projects',
            style: AppDesign.largeTitle.copyWith(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          Expanded(child: _buildProjectsContent()),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildProjectsContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              strokeWidth: 2,
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading projects...',
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
              'Error loading projects',
              style: AppDesign.title1.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      );
    }

    if (_projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code_outlined, color: Colors.grey[400], size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              'No projects found',
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
      itemCount: _projects.length,
      itemBuilder: (context, index) => _buildProjectCard(_projects[index]),
    );
  }

  Widget _buildProjectCard(Project project) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image header with title overlay (like the reference)
            Container(
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (project.imageUrl.isNotEmpty)
                    Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey[800]),
                    ),
                  // gradient fade bottom
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    bottom: 12.h,
                    right: 16.w,
                    child: Text(
                      project.name,
                      style: AppDesign.title2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Details panel
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (project.description.isNotEmpty)
                    ...project.description
                        .take(3)
                        .map(
                          (line) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 3.h),
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green[600],
                                    size: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    line,
                                    style: AppDesign.body.copyWith(
                                      color: Colors.white,
                                      fontSize: 13.sp,
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
        ),
      ),
    );
  }
}
