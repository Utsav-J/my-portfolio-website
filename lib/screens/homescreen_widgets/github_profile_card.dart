import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubProfileCard extends StatelessWidget {
  const GithubProfileCard({super.key});

  void _showErrorSnackBar(String message) {
    // You can implement a proper error dialog or snackbar here
    print('Error: $message');
  }

  Future<void> _hanldeOpenGithub() async {
    String githubUrl = "https://github.com/Utsav-J";
    try {
      final Uri url = Uri.parse(githubUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open resume link');
      }
    } catch (e) {
      _showErrorSnackBar('An unknown error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _hanldeOpenGithub(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
            image: DecorationImage(
              image: AssetImage("assets/images/utsav_github.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(BoxIcons.bx_git_commit, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(
                        "545+",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(CupertinoIcons.tray, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(
                        "50+",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
