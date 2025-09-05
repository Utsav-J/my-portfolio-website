import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/utils/firebase_utils.dart';
import 'package:portfolio/utils/url_launcher_utils.dart';

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
  String? _aboutMeSummary;
  bool _isLoadingSummary = true;

  final List<String> _titles = [
    'COMPUTER SCIENCE STUDENT',
    'FULL STACK APP DEVELOPER',
    'GENAI ENTHUSIAST',
    'MUSICIAN',
  ];

  Future<String> _getProfileImageUrl() async {
    return await FirebaseUtils.getProfileImageUrl();
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

  Future<void> _loadAboutMeSummary() async {
    try {
      final summary = await FirebaseUtils.getAboutMeSummary();
      if (mounted) {
        setState(() {
          _aboutMeSummary = summary;
          _isLoadingSummary = false;
        });
      }
    } catch (e) {
      print('Error loading about me summary: $e');
      if (mounted) {
        setState(() {
          _aboutMeSummary =
              "I'm a passionate software developer with expertise in Flutter development, and creating elegant digital experiences. I love turning complex problems into simple, beautiful solutions.";
          _isLoadingSummary = false;
        });
      }
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
    _loadAboutMeSummary();
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
                          : CachedNetworkImageProvider(_profileImageUrl!),
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
                        fontSize: 48,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sub-headline
                    Text(
                      "Thanks for visiting my portfolio",
                      style: AppDesign.title1.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Call-to-action buttons
                    Row(
                      children: [
                        _buildButton(
                          'Resume',
                          Brand(Brands.google_drive, size: 20),
                          UrlLauncherUtils.handleDownloadCV,
                          const Color.fromARGB(255, 93, 171, 255),
                          Colors.white,
                          AppDesign.systemBlue,
                        ),
                        const SizedBox(width: 20),
                        _buildButton(
                          'GitHub',
                          Brand(Brands.github, size: 20),
                          () => UrlLauncherUtils.handleOpenSocials(
                            'https://github.com/Utsav-J',
                          ),
                          Colors.white,
                          Colors.black,
                          Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    if (_isLoadingSummary)
                      const Center(child: CircularProgressIndicator())
                    else
                      Text(
                        _aboutMeSummary!,
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontSize: 15,
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

  Widget _buildButton(
    String text,
    Brand brandIcon,
    VoidCallback onTap,
    Color backgroundColor,
    Color textColor,
    Color borderColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                brandIcon,
                SizedBox(width: 5),
                Text(
                  text,
                  style: AppDesign.buttonText(color: textColor).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
