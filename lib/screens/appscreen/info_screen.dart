import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                CupertinoIcons.info_circle_fill,
                size: 22.sp,
                color: const Color(0xFF4ECDC4),
              ),
              SizedBox(width: 12.w),
              Text(
                'How to Navigate the Website',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Instructions Grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInstructionCard(
                    icon: CupertinoIcons.xmark_circle,
                    title: 'Closing Windows',
                    description:
                        'Close windows using the red button in the top-left corner of each window.',
                    steps: [
                      '• Click the red circle (●) to close the current window',
                    ],
                  ),

                  SizedBox(height: 16.h),
                  _buildInstructionCard(
                    icon: CupertinoIcons.square_stack_3d_up,
                    title: 'Opening Windows',
                    description:
                        'Click on any app icon in the dock to open a new window. Each app represents a different section of my portfolio.',
                    steps: [
                      '• Click on "About Me" to learn more about me',
                      '• Click on "Experience" to see my work history',
                      '• Click on "Projects" to view my development work',
                      '• Click on "Education" to see my academic background',
                      '• Click on "Certifications" to view my credentials',
                    ],
                  ),

                  SizedBox(height: 16.h),
                  _buildInstructionCard(
                    icon: CupertinoIcons.hand_draw,
                    title: 'Moving Windows',
                    description:
                        'Drag windows around the screen to organize your workspace.',
                    steps: [
                      '• Click and drag the top bar of any window to move it',
                      '• Windows will stay within screen boundaries',
                      '• Click on a window to bring it to the front',
                    ],
                  ),

                  SizedBox(height: 16.h),

                  _buildInstructionCard(
                    icon: CupertinoIcons.game_controller,
                    title: 'Interactive Features',
                    description:
                        'Explore interactive elements throughout the portfolio.',
                    steps: [
                      '• Play the Snake game in the "Game" app',
                      '• View live GitHub statistics',
                      '• Check out the weather widget',
                      '• Browse through project details and links',
                    ],
                  ),

                  SizedBox(height: 16.h),

                  _buildInstructionCard(
                    icon: CupertinoIcons.globe,
                    title: 'External Links',
                    description:
                        'Many elements are clickable and will open external websites.',
                    steps: [
                      '• GitHub links open my repositories',
                      '• Project links show live repos',
                      '• Social media icons connect to my profiles',
                      '• Contact information opens email clients',
                    ],
                  ),

                  SizedBox(height: 16.h),

                  _buildInstructionCard(
                    icon: CupertinoIcons.phone,
                    title: 'Mobile Experience',
                    description:
                        'The portfolio is fully responsive and works on mobile devices.',
                    steps: [
                      '• Swipe to navigate between sections',
                      '• Tap to interact with elements',
                      '• Pinch to zoom on images',
                      '• Use the back button to return to previous screens',
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

  Widget _buildInstructionCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> steps,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE9ECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: const Color(0xFF4ECDC4), size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6C757D),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          ...steps.map(
            (step) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                step,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF495057),
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
