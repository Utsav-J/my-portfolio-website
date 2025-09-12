import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
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
                  'Projects',
                  style: AppDesign.largeTitle.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                Expanded(child: _buildProjectsContent()),

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

    final int total = _projects.length;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: total,
      itemBuilder: (context, index) {
        final project = _projects[index];
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
                Expanded(child: _buildProjectCard(project)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(Project project) {
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
            // Project icon and name
            Row(
              children: [
                Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  child: project.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            project.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.code, color: Colors.white60),
                          ),
                        )
                      : Icon(Icons.code, color: Colors.white60),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: AppDesign.title1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Description
            if (project.description.isNotEmpty) ...[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: project.description
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
