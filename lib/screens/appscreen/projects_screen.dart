import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';
import 'package:portfolio/utils/url_launcher_utils.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> _projects = [];
  bool _isLoading = true;
  String? _error;
  final Set<String> _expandedProjects = {};

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

  void _toggleProjectExpansion(String projectName) {
    setState(() {
      if (_expandedProjects.contains(projectName)) {
        _expandedProjects.remove(projectName);
      } else {
        _expandedProjects.add(projectName);
      }
    });
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
                      Text(
                        'Projects',
                        style: AppDesign.largeTitle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'My development work',
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats in a compact row
                Row(children: [_buildCompactRefreshButton()]),
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

            SizedBox(height: 16.h),

            // Projects content
            Expanded(child: _buildProjectsContent()),
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
          onTap: _loadProjects,
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

  Widget _buildProjectsContent() {
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
              'Loading projects...',
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
              'Error loading projects',
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
            const SizedBox(height: 16),
            _buildCompactRefreshButton(),
          ],
        ),
      );
    }

    if (_projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code_outlined, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'No projects found',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add project data to your Firestore collection',
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

    // 2x2 Grid layout
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        return _buildProjectCard(_projects[index]);
      },
    );
  }

  Widget _buildProjectCard(Project project) {
    final bool isExpanded = _expandedProjects.contains(project.name);

    return GestureDetector(
      onTap: () => _toggleProjectExpansion(project.name),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        tween: Tween(begin: 0.0, end: isExpanded ? 1.0 : 0.0),
        builder: (context, value, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * 3.14159),
            child: value < 0.5
                ? _buildCardFront(project)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _buildCardBack(project),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardFront(Project project) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(project.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project name only
                    GestureDetector(
                      onTap: () => UrlLauncherUtils.launchGitHubProject(
                        project.githubUrl,
                      ),
                      child: Text(
                        project.name,
                        style: AppDesign.title2.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(Project project) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back indicator
              Row(
                children: [
                  Icon(
                    Icons.flip_to_back,
                    color: AppDesign.systemBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Project Details',
                    style: AppDesign.title2.copyWith(
                      color: AppDesign.systemBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description content
              if (project.description.isNotEmpty) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: project.description.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: AppDesign.body.copyWith(
                                color: AppDesign.systemBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                project.description[index],
                                style: AppDesign.body.copyWith(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Center(
                    child: Text(
                      'No description available',
                      style: AppDesign.body.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
