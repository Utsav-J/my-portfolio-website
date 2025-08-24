import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/utils/url_launcher_utils.dart';

class GithubProfileCard extends StatelessWidget {
  const GithubProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            UrlLauncherUtils.handleOpenSocials('https://github.com/Utsav-J'),
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
              padding: EdgeInsets.all(10.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        BoxIcons.bx_git_commit,
                        color: Colors.white54,
                        size: 20.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "545+",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.tray,
                        color: Colors.white54,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "50+",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16.sp,
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
