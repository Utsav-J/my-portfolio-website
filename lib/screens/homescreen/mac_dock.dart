import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/dock_icon.dart';
import 'package:portfolio/models/models.dart';

class MacDock extends StatelessWidget {
  const MacDock({super.key});

  void _handleDownloadCV(){
    
  }

  @override
  Widget build(BuildContext context) {
    final dockApps = [
      DockApp(
        icon: CupertinoIcons.map,
        title: 'Maps',
        description:
            'Navigate and explore locations with detailed maps and directions',
      ),
      DockApp(
        icon: CupertinoIcons.music_note,
        title: 'Music',
        description: 'Listen to your favorite songs and discover new music',
      ),
      DockApp(
        icon: CupertinoIcons.download_circle,
        title: 'Download CV',
        description: 'Download my resume',
        onTap: ()=>_handleDownloadCV()
      ),
      DockApp(
        icon: CupertinoIcons.photo,
        title: 'Photos',
        description: 'Organize and edit your memories and images',
      ),
      DockApp(
        icon: CupertinoIcons.cloud_sun,
        title: 'Weather',
        description: 'Check current conditions and forecast for your location',
      ),
    ];

    return Center(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.withOpacity(0.3),
              Colors.grey.withOpacity(0.2),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: dockApps.map((app) => DockIcon(app: app)).toList(),
        ),
      ),
    );
  }
}
