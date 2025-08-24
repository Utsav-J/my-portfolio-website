import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  static Future<void> handleOpenSocials(String socialUrl) async {
    try {
      final Uri url = Uri.parse(socialUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open resume link');
      }
    } catch (e) {
      _showErrorSnackBar('An unknown error occurred: $e');
    }
  }

  static void _showErrorSnackBar(String message) {
    // You can implement a proper error dialog or snackbar here
    print('Error: $message');
  }

  static Future<void> launchGitHubProject(String url) async {
    if (url.isNotEmpty) {
      try {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        print('Error launching URL: $e');
      }
    }
  }

  static Future<void> handleDownloadCV() async {
    try {
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
}
