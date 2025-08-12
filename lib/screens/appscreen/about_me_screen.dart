import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/config/app_design.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentTitleIndex = 0;
  String? _profileImageUrl;
  bool _isLoadingImage = true;

  final List<String> _titles = [
    'COMPUTER SCIENCE STUDENT',
    'FULL STACK APP DEVELOPER',
    'GENAI ENTHUSIAST',
    'MUSICIAN',
  ];

  Future<String> _getProfileImageUrl() async {
    try {
      final DocumentSnapshot profileImage = await FirebaseFirestore.instance
          .collection('images')
          .doc('aboutme')
          .get();
      if (profileImage.exists && profileImage.data() != null) {
        final Map<String, dynamic> data =
            profileImage.data() as Map<String, dynamic>;
        final String? imageUrl = data['url'] as String?;
        return imageUrl ?? "";
      }
      return "";
    } catch (e) {
      print('Error fetching profile image: $e');
      return "";
    }
  }

  Future<void> _loadProfileImage() async {
    final imageUrl = await _getProfileImageUrl();
    if (mounted) {
      setState(() {
        _profileImageUrl = imageUrl;
        _isLoadingImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startTitleAnimation();
    _loadProfileImage();
  }

  void _startTitleAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _animateTitleChange();
      }
    });
  }

  void _animateTitleChange() {
    _animationController.forward().then((_) {
      setState(() {
        _currentTitleIndex = (_currentTitleIndex + 1) % _titles.length;
      });
      _animationController.reverse().then((_) {
        if (mounted) {
          _startTitleAnimation();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          // Left side - Profile section (light beige background)
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFFF8F6F3), // Light beige background
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    // Profile picture placeholder
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[300],
                      foregroundImage:
                          _isLoadingImage ||
                              _profileImageUrl == null ||
                              _profileImageUrl!.isEmpty
                          ? null
                          : NetworkImage(_profileImageUrl!),
                      child: _isLoadingImage
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppDesign.systemBlue,
                                ),
                              ),
                            )
                          : (_profileImageUrl == null ||
                                _profileImageUrl!.isEmpty)
                          ? Icon(
                              CupertinoIcons.person_fill,
                              size: 60,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Name
                    Text(
                      'Utsav\nJaiswal',
                      textAlign: TextAlign.center,
                      style: AppDesign.largeTitle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Blue separator line
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppDesign.systemBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Animated job title
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Text(
                            _titles[_currentTitleIndex],
                            textAlign: TextAlign.center,
                            style: AppDesign.headline.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    // Social media icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(Icons.facebook, 'Facebook'),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.flutter_dash, 'Twitter'),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.work, 'LinkedIn'),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.camera_alt, 'Instagram'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side - Content section (white background)
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large greeting
                    Text(
                      'Hey there👋',
                      style: AppDesign.largeTitle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 58,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sub-headline
                    Text(
                      "Thanks for visiting my portfolio",
                      style: AppDesign.title1.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Call-to-action buttons
                    Row(
                      children: [
                        _buildButton(
                          'RESUME',
                          AppDesign.systemBlue,
                          Colors.white,
                          true,
                        ),
                        const SizedBox(width: 20),
                        _buildButton(
                          'PROJECTS',
                          Colors.white,
                          Colors.black,
                          false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Content paragraphs
                    Text(
                      "I'm a passionate software developer with expertise in Flutter, mobile development, and creating elegant digital experiences. I love turning complex problems into simple, beautiful solutions.",
                      style: AppDesign.body.copyWith(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Tooltip(
      message: label,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87, size: 24),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color backgroundColor,
    Color textColor,
    bool isFilled,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isFilled ? backgroundColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isFilled ? null : Border.all(color: Colors.black, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Add navigation or action here
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              text,
              style: AppDesign.buttonText(color: textColor).copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
