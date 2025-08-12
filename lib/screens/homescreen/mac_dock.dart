import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/dock_icon.dart';
import 'package:portfolio/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MacDock extends StatelessWidget {
  const MacDock({super.key});

  Future<void> _handleDownloadCV() async {
    try {
      // Show loading indicator
      // You can add a loading dialog here if needed

      // Get the resume URL from Firestore
      final DocumentSnapshot resumeDoc = await FirebaseFirestore.instance
          .collection('data')
          .doc('resume')
          .get();

      if (resumeDoc.exists && resumeDoc.data() != null) {
        final Map<String, dynamic> data =
            resumeDoc.data() as Map<String, dynamic>;
        final String? resumeUrl = data['url'] as String?;

        if (resumeUrl != null && resumeUrl.isNotEmpty) {
          // Launch the URL to download the resume
          final Uri url = Uri.parse(resumeUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            // Show error if URL can't be launched
            _showErrorSnackBar('Could not open resume link');
          }
        } else {
          _showErrorSnackBar('Resume URL not found');
        }
      } else {
        _showErrorSnackBar('Resume document not found');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading resume: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    // You can implement a proper error dialog or snackbar here
    print('Error: $message');
  }

  @override
  Widget build(BuildContext context) {
    final dockApps = [
      DockApp(
        icon: CupertinoIcons.map,
        title: 'Maps',
        description:
            'Navigate and explore locations with detailed maps and directions',
        onTap: () {},
      ),
      DockApp(
        icon: CupertinoIcons.music_note,
        title: 'Music',
        description: 'Listen to your favorite songs and discover new music',
        onTap: () {},
      ),
      DockApp(
        icon: CupertinoIcons.down_arrow,
        title: 'Download CV',
        description: 'Download my resume',
        onTap: () => _handleDownloadCV(),
      ),
      DockApp(
        icon: CupertinoIcons.photo,
        title: 'Photos',
        description: 'Organize and edit your memories and images',
        onTap: () {},
      ),
      DockApp(
        icon: CupertinoIcons.cloud_sun,
        title: 'Weather',
        description: 'Check current conditions and forecast for your location',
        onTap: () {},
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
              Colors.grey.withValues(alpha: 0.3),
              Colors.grey.withValues(alpha: 0.2),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
