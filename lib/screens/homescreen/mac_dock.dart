import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/dock_icon.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/config/app_design.dart';

class MacDock extends StatelessWidget {
  const MacDock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dockApps = [
      DockApp(icon: CupertinoIcons.folder, title: 'Finder'),
      DockApp(icon: CupertinoIcons.globe, title: 'Safari'),
      DockApp(icon: CupertinoIcons.rectangle_on_rectangle, title: 'Terminal'),
      DockApp(
        icon: CupertinoIcons.chevron_left_slash_chevron_right,
        title: 'VS Code',
      ),
      DockApp(icon: CupertinoIcons.paintbrush, title: 'Design'),
      DockApp(icon: CupertinoIcons.music_note, title: 'Music'),
    ];

    return Center(
      child: AppDesign.glassmorphicContainer(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        borderRadius: 16.0,
        backgroundColor: Colors.white.withOpacity(0.15),
        borderColor: Colors.white.withOpacity(0.2),
        blurStrength: 12.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: dockApps.map((app) => DockIcon(app: app)).toList(),
        ),
      ),
    );
  }
}
