import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/screens/appscreen/app_screen.dart';
import 'package:portfolio/screens/homescreen/mac_app_icon.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/screens/appscreen/projects_screen.dart';
import 'package:portfolio/screens/snake/snake_game.dart';

class MacDesktopApps extends StatefulWidget {
  const MacDesktopApps({super.key});

  @override
  State<MacDesktopApps> createState() => _MacDesktopAppsState();
}

class _MacDesktopAppsState extends State<MacDesktopApps> {
  List<PortfolioApp> openWindows = [];
  Map<String, Offset> windowPositions = {};
  Size? _lastScreenSize;

  @override
  void initState() {
    super.initState();
    // Initialize with a default screen size
    _lastScreenSize = const Size(1920, 1080);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for screen size changes
    final currentSize = MediaQuery.of(context).size;
    if (_lastScreenSize != null &&
        (_lastScreenSize!.width != currentSize.width ||
            _lastScreenSize!.height != currentSize.height)) {
      _lastScreenSize = currentSize;
      // Handle screen size change if needed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _handleScreenSizeChange(currentSize);
        }
      });
    }
  }

  // Calculate smart initial position that avoids overlapping with existing windows
  Offset _calculateSmartInitialPosition(PortfolioApp app) {
    // never change this offset position
    if (app.title == 'About Me') {
      return const Offset(50, 60);
    }
    // never change this offset position
    if (app.title == "Experience") {
      return const Offset(850, 50);
    }
    // never change this offset position
    if (app.title == "Education") {
      return const Offset(500, 120);
    }
    // never change this offset position
    if (app.title == "Projects") {
      return const Offset(200, 200);
    }
    // const menuBarHeight = 30.0;
    const baseX = 80.0;
    const baseY = 80.0; // Below menu bar
    const spacingX = 40.0;
    const spacingY = 30.0;

    // Start with base position
    double x = baseX + (openWindows.length * spacingX);
    double y = baseY + (openWindows.length * spacingY);

    // Check for overlaps with existing windows
    for (String title in windowPositions.keys) {
      if (!openWindows.any((w) => w.title == title)) {
        continue; // Skip if window no longer exists
      }

      final existingPos = windowPositions[title]!;
      final existingApp = openWindows.firstWhere((w) => w.title == title);
      final existingWidth = existingApp.width ?? 400;
      final existingHeight = existingApp.height ?? 300;
      final appWidth = app.width ?? 400;
      final appHeight = app.height ?? 300;

      // Check if windows overlap
      if (x < existingPos.dx + existingWidth &&
          x + appWidth > existingPos.dx &&
          y < existingPos.dy + existingHeight &&
          y + appHeight > existingPos.dy) {
        // Move this window to avoid overlap
        x += spacingX * 2;
        y += spacingY * 2;
      }
    }

    // Ensure position is within screen bounds (basic check)
    final screenWidth = _lastScreenSize?.width ?? 1920.0;
    final screenHeight = _lastScreenSize?.height ?? 1080.0;
    final dockHeight = 60.0;
    const dockBottomPadding = 20.0;

    if (x + (app.width ?? 400) > screenWidth) {
      x = baseX;
    }

    if (y + (app.height ?? 300) >
        screenHeight - dockHeight - dockBottomPadding) {
      y = baseY;
    }

    return Offset(x, y);
  }

  void _openApp(PortfolioApp app) {
    if (!mounted) return; // Don't proceed if widget is not mounted

    setState(() {
      if (!openWindows.any((window) => window.title == app.title)) {
        openWindows.add(app);
        // Use smart positioning to avoid overlaps and stay within bounds
        final initialPosition = _calculateSmartInitialPosition(app);
        windowPositions[app.title] = initialPosition;
      }
    });
  }

  void _closeApp(PortfolioApp app) {
    if (!mounted) return; // Don't proceed if widget is not mounted

    setState(() {
      openWindows.remove(app);
      windowPositions.remove(app.title);
    });
  }

  void _updateWindowPosition(String title, Offset newPosition) {
    if (!mounted) return; // Don't proceed if widget is not mounted

    setState(() {
      windowPositions[title] = newPosition;
    });
  }

  // Handle screen size changes and reposition windows if needed
  void _handleScreenSizeChange(Size newSize) {
    if (!mounted || openWindows.isEmpty || windowPositions.isEmpty) {
      return; // Don't proceed if widget is not mounted or no windows
    }

    setState(() {
      for (String title in windowPositions.keys) {
        if (!openWindows.any((w) => w.title == title)) {
          continue; // Skip if window no longer exists
        }

        final currentPos = windowPositions[title]!;
        final app = openWindows.firstWhere((w) => w.title == title);
        final appWidth = app.width ?? 400;
        final appHeight = app.height ?? 300;

        // Check if window is outside new screen bounds
        bool needsReposition = false;
        double newX = currentPos.dx;
        double newY = currentPos.dy;

        // Left boundary
        if (newX < 0) {
          newX = 0;
          needsReposition = true;
        }

        // Right boundary
        if (newX + appWidth > newSize.width) {
          newX = newSize.width - appWidth;
          needsReposition = true;
        }

        // Top boundary (menu bar)
        if (newY < 30) {
          newY = 30;
          needsReposition = true;
        }

        // Bottom boundary (dock area)
        final bottomBoundary = newSize.height - 60 - 20 - appHeight;
        if (newY > bottomBoundary) {
          newY = bottomBoundary;
          needsReposition = true;
        }

        if (needsReposition) {
          windowPositions[title] = Offset(newX, newY);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final portfolioApps = [
      PortfolioApp(
        title: 'About Me',
        icon: CupertinoIcons.person_circle,
        color: const Color(0xFF34C759),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'About Me',
            icon: CupertinoIcons.person_circle,
            color: const Color(0xFF34C759),
            onTap: () {},
            height: 560,
            width: 768,
          ),
        ),
      ),
      PortfolioApp(
        title: 'Experience',
        icon: CupertinoIcons.briefcase,
        color: const Color(0xFF007AFF),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Experience',
            icon: CupertinoIcons.briefcase,
            color: const Color(0xFF007AFF),
            onTap: () {},
            height: 400,
            width: 600,
          ),
        ),
      ),
      PortfolioApp(
        title: 'Certifications',
        icon: CupertinoIcons.checkmark_seal,
        color: const Color(0xFF0A84FF),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Certifications',
            icon: CupertinoIcons.checkmark_seal,
            color: const Color(0xFF0A84FF),
            onTap: () {},
            height: 400,
            width: 600,
          ),
        ),
      ),
      PortfolioApp(
        title: 'Projects',
        icon: CupertinoIcons.hammer,
        color: const Color(0xFFFF9500),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Projects',
            icon: CupertinoIcons.hammer,
            color: const Color(0xFFFF9500),
            onTap: () {},
            height: 500,
            width: 800,
          ),
        ),
      ),
      PortfolioApp(
        title: 'Skills',
        icon: CupertinoIcons.lightbulb,
        color: const Color(0xFF5856D6),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Skills',
            icon: CupertinoIcons.lightbulb,
            color: const Color(0xFF5856D6),
            onTap: () {},
          ),
        ),
      ),
      PortfolioApp(
        title: 'Education',
        icon: CupertinoIcons.book,
        color: const Color(0xFFAF52DE),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Education',
            icon: CupertinoIcons.book,
            color: const Color(0xFFAF52DE),
            onTap: () {},
            height: 350,
            width: 500,
          ),
        ),
      ),
      PortfolioApp(
        title: 'Achievements',
        icon: CupertinoIcons.star_circle,
        color: const Color(0xFFFFD60A),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Achievements',
            icon: CupertinoIcons.star_circle,
            color: const Color(0xFFFFD60A),
            onTap: () {},
          ),
        ),
      ),
      PortfolioApp(
        title: 'Blog',
        icon: CupertinoIcons.doc_text,
        color: const Color(0xFF32D74B),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Blog',
            icon: CupertinoIcons.doc_text,
            color: const Color(0xFF32D74B),
            onTap: () {},
          ),
        ),
      ),
      PortfolioApp(
        title: 'Contact',
        icon: CupertinoIcons.mail,
        color: const Color(0xFFFF3B30),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Contact',
            icon: CupertinoIcons.mail,
            color: const Color(0xFFFF3B30),
            onTap: () {},
          ),
        ),
      ),
      PortfolioApp(
        title: 'Resume',
        icon: CupertinoIcons.doc,
        color: const Color(0xFF8E8E93),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Resume',
            icon: CupertinoIcons.doc,
            color: const Color(0xFF8E8E93),
            onTap: () {},
          ),
        ),
      ),
      PortfolioApp(
        title: 'Snake Game',
        icon: CupertinoIcons.game_controller,
        color: const Color(0xFF48CAE4),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Snake Game',
            icon: CupertinoIcons.book,
            color: const Color(0xFFAF52DE),
            onTap: () {},
            height: 500,
            width: 500,
          ),
        ),
      ),
      PortfolioApp(
        title: 'Testimonials',
        icon: CupertinoIcons.chat_bubble_2,
        color: const Color(0xFFFF6B6B),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Testimonials',
            icon: CupertinoIcons.chat_bubble_2,
            color: const Color(0xFFFF6B6B),
            onTap: () {},
          ),
        ),
      ),
      PortfolioApp(
        title: 'Gallery',
        icon: CupertinoIcons.photo_on_rectangle,
        color: const Color(0xFF4ECDC4),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Gallery',
            icon: CupertinoIcons.photo_on_rectangle,
            color: const Color(0xFF4ECDC4),
            onTap: () {},
          ),
        ),
      ),
    ];

    return Stack(
      children: [
        // Desktop Apps Grid
        Padding(
          padding: const EdgeInsets.all(40),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: portfolioApps.length,
            itemBuilder: (context, index) {
              return MacAppIcon(app: portfolioApps[index]);
            },
          ),
        ),

        // Open Windows - Now using the draggable AppScreen
        ...openWindows.map((app) {
          final position = windowPositions[app.title] ?? const Offset(50, 60);
          return AppScreen(
            key: ValueKey(app.title), // Simple key for each window
            title: app.title,
            initialPosition: position, // Pass the actual position
            windowHeight: app.height,
            windowWidth: app.width,
            onPositionChanged: (newPosition) =>
                _updateWindowPosition(app.title, newPosition),
            onClose: () => _closeApp(app),
            child: _buildContent(app),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildContent(PortfolioApp app) {
    // Special case for About Me app
    if (app.title == 'About Me') {
      return const AboutMeScreen();
    }

    // Special case for Experience app
    if (app.title == 'Experience') {
      return const ExperienceScreen();
    }

    // Special case for Certifications app
    if (app.title == 'Certifications') {
      return const CertificationsScreen();
    }

    // Special case for Education app
    if (app.title == 'Education') {
      return const EducationScreen();
    }

    // Special case for Projects app
    if (app.title == 'Projects') {
      return const ProjectsScreen();
    }

    if (app.title == 'Snake Game') {
      return const SnakeGame();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(app.icon, color: app.color, size: 32),
              const SizedBox(width: 12),
              Text(
                app.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to ${app.title}!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This is a sample content area for the ${app.title} application. '
            'You can add your actual content here including text, images, '
            'forms, or any other widgets you need.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: app.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: app.color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(app.icon, color: app.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Sample ${app.title} Content',
                  style: TextStyle(
                    color: app.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
