import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/mac_app_icon.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/screens/appscreen/app_screen.dart';

class MacDesktopApps extends StatefulWidget {
  const MacDesktopApps({Key? key}) : super(key: key);

  @override
  State<MacDesktopApps> createState() => _MacDesktopAppsState();
}

class _MacDesktopAppsState extends State<MacDesktopApps> {
  List<PortfolioApp> openWindows = [];

  void _openApp(PortfolioApp app) {
    setState(() {
      openWindows.add(app);
    });
  }

  void _closeApp(PortfolioApp app) {
    setState(() {
      openWindows.remove(app);
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
        title: 'Portfolio',
        icon: CupertinoIcons.folder,
        color: const Color(0xFF48CAE4),
        onTap: () => _openApp(
          PortfolioApp(
            title: 'Portfolio',
            icon: CupertinoIcons.folder,
            color: const Color(0xFF48CAE4),
            onTap: () {},
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

        // Open Windows
        ...openWindows.asMap().entries.map((entry) {
          final index = entry.key;
          final app = entry.value;
          return Positioned(
            top: 80 + (index * 40),
            left: 60 + (index * 30),
            child: SizedBox(
              width: 400,
              height: 300,
              child: AppScreen(
                title: app.title,
                onClose: () => _closeApp(app),
                child: _buildDummyContent(app),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDummyContent(PortfolioApp app) {
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
              color: app.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: app.color.withOpacity(0.3)),
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
