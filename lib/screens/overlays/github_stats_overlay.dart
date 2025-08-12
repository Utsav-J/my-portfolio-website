import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/screens/overlays/github_stats_html.dart';

class GithubStatsOverlay extends StatefulWidget {
  const GithubStatsOverlay({Key? key}) : super(key: key);

  @override
  State<GithubStatsOverlay> createState() => _GithubStatsOverlayState();
}

class _GithubStatsOverlayState extends State<GithubStatsOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Slide from right
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final overlayWidth = screenWidth * 0.25; // 25% of screen width

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: AppDesign.glassmorphicContainer(
            width: overlayWidth,
            padding: const EdgeInsets.all(20),
            borderRadius: 16.0,
            blurStrength: 20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.doc_text,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'GitHub Stats',
                      style: AppDesign.headline.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Note that these numbers could be from a few days back, due to browser caching. You can always check out my GitHub profile instead",
                  overflow: TextOverflow.clip,
                  style: AppDesign.headline.copyWith(
                    color: Colors.white.withAlpha(180),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),

                // GitHub Stats Images
                Column(
                  children: [
                    // Languages Chart
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GitHubStatsHtml(username: "Utsav-J"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
