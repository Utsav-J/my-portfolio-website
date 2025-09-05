import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/utils/firebase_utils.dart';

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
      final String? resumeUrl = await FirebaseUtils.getResumeUrl();

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
    } catch (e) {
      _showErrorSnackBar('Error downloading resume: $e');
    }
  }

  static Future<void> handleMailtoLink(
    String email, {
    String? subject,
    String? body,
  }) async {
    try {
      final Uri mailtoUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );

      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open email client');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred while opening email: $e');
    }
  }
}
