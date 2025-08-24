import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/screens/homescreen_widgets/skill_carousel/skill_button.dart';

class SkillCarousel extends StatefulWidget {
  const SkillCarousel({super.key});

  @override
  State<SkillCarousel> createState() => _SkillCarouselState();
}

class _SkillCarouselState extends State<SkillCarousel>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;
  double _maxScrollExtent = 0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    // Start the animation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _animationController.addListener(() {
      if (_scrollController.hasClients && _maxScrollExtent > 0) {
        final offset = _animationController.value * _maxScrollExtent;
        _scrollController.jumpTo(offset);
      }
    });

    _animationController.repeat();
  }

  void _toggleAnimation() {
    setState(() {
      if (_isPlaying) {
        _animationController.stop();
        _isPlaying = false;
      } else {
        _animationController.repeat();
        _isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          _maxScrollExtent =
              constraints.maxWidth * 1.5; // Adjust multiplier as needed

          return Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.h),
                  decoration: BoxDecoration(
                    // color: Colors.black26,
                    gradient: LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // First set of skills
                      _SkillsGrid(),
                      SizedBox(width: 100.w), // Gap between sets
                      // Duplicate set for seamless looping
                      _SkillsGrid(),
                    ],
                  ),
                ),
              ),
              // Control button positioned at top-right
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: _toggleAnimation,
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1
        Row(
          children: [
            SkillButton('Python', 'assets/icons/python.png', false),
            SizedBox(width: 12.w),
            SkillButton(
              'Flutter',
              'assets/icons/flutter.png',
              true,
              gradient: [const Color(0xFF8B5CF6), const Color(0xFF06B6D4)],
            ),
            SizedBox(width: 12.w),
            SkillButton('JavaScript', 'assets/icons/javascript.png', false),
            SizedBox(width: 12.w),
            SkillButton('React', 'assets/icons/react.png', false),
            SizedBox(width: 12.w),
            SkillButton('Node.js', 'assets/icons/node.png', false),
            SizedBox(width: 12.w),
            SkillButton('Java', 'assets/icons/java.png', false),
            SizedBox(width: 12.w),
            SkillButton('C++', 'assets/icons/cpp.png', false),
            SizedBox(width: 12.w),
            SkillButton('AWS', 'assets/icons/aws.png', false),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 2
        Row(
          children: [
            SkillButton(
              'Dart',
              'assets/icons/dart.png',
              true,
              gradient: [const Color(0xFFEF4444), const Color(0xFFEC4899)],
            ),
            SizedBox(width: 12.w),
            SkillButton('Docker', 'assets/icons/docker.png', false),
            SizedBox(width: 12.w),
            SkillButton('Kubernetes', 'assets/icons/kubernetes.png', false),
            SizedBox(width: 12.w),
            SkillButton('MongoDB', 'assets/icons/mongodb.png', false),
            SizedBox(width: 12.w),
            SkillButton('SQL', 'assets/icons/sql.png', false),
            SizedBox(width: 12.w),
            SkillButton('Firebase', 'assets/icons/firebase.png', false),
            SizedBox(width: 12.w),
            SkillButton('Bash', 'assets/icons/bash.png', false),
            SizedBox(width: 12.w),
            SkillButton('Postman', 'assets/icons/postman.png', false),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 3
        Row(
          children: [
            SkillButton('C', 'assets/icons/c.png', false),
            SizedBox(width: 12.w),
            SkillButton(
              'Hugging Face',
              'assets/icons/huggingface.png',
              true,
              gradient: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
            ),
            SizedBox(width: 12.w),
            SkillButton('Angular', 'assets/icons/angular.png', false),
            SizedBox(width: 12.w),
            SkillButton('Python', 'assets/icons/python2.png', false),
            SizedBox(width: 12.w),
            SkillButton('Flutter', 'assets/icons/flutter.png', false),
            SizedBox(width: 12.w),
            SkillButton('React', 'assets/icons/react.png', false),
            SizedBox(width: 12.w),
            SkillButton('Node.js', 'assets/icons/node.png', false),
            SizedBox(width: 12.w),
            SkillButton('Java', 'assets/icons/java.png', false),
          ],
        ),
      ],
    );
  }
}
