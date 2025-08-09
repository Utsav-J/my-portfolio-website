import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/screens/homescreen/dock_icon.dart';
import 'package:portfolio/models/models.dart';

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
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
