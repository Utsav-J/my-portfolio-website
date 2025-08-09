import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/mac_app_icon.dart';
import 'package:portfolio/models/models.dart';

class MacDesktopApps extends StatelessWidget {
  const MacDesktopApps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final portfolioApps = [
      PortfolioApp(
        title: 'About Me',
        icon: CupertinoIcons.person_circle,
        color: const Color(0xFF34C759),
        onTap: () {}, // TODO: Implement navigation
      ),
      PortfolioApp(
        title: 'Experience',
        icon: CupertinoIcons.briefcase,
        color: const Color(0xFF007AFF),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Projects',
        icon: CupertinoIcons.hammer,
        color: const Color(0xFFFF9500),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Skills',
        icon: CupertinoIcons.lightbulb,
        color: const Color(0xFF5856D6),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Education',
        icon: CupertinoIcons.book,
        color: const Color(0xFFAF52DE),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Achievements',
        icon: CupertinoIcons.star_circle,
        color: const Color(0xFFFFD60A),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Blog',
        icon: CupertinoIcons.doc_text,
        color: const Color(0xFF32D74B),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Contact',
        icon: CupertinoIcons.mail,
        color: const Color(0xFFFF3B30),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Resume',
        icon: CupertinoIcons.doc,
        color: const Color(0xFF8E8E93),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Portfolio',
        icon: CupertinoIcons.folder,
        color: const Color(0xFF48CAE4),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Testimonials',
        icon: CupertinoIcons.chat_bubble_2,
        color: const Color(0xFFFF6B6B),
        onTap: () {},
      ),
      PortfolioApp(
        title: 'Gallery',
        icon: CupertinoIcons.photo_on_rectangle,
        color: const Color(0xFF4ECDC4),
        onTap: () {},
      ),
    ];

    return Padding(
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
    );
  }
}
