import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/screens/homescreen/mac_menu_item.dart';

class MacDropdownMenu extends StatelessWidget {
  final Function(String) onItemSelected;
  final List<MenuItemData>? menuItems;

  const MacDropdownMenu({
    super.key,
    required this.onItemSelected,
    this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    final items =
        menuItems ??
        [
          MenuItemData('Download Resume', CupertinoIcons.cloud_download),
          MenuItemData('Print Portfolio', CupertinoIcons.printer),
          MenuItemData('Share Portfolio', CupertinoIcons.share),
          MenuItemData('Export as PDF', CupertinoIcons.doc),
          MenuItemData('Settings', CupertinoIcons.gear),
        ];

    return Material(
      color: Colors.transparent,
      child: AppDesign.glassmorphicContainer(
        width: 180,
        borderRadius: 8.0,
        blurStrength: 15.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              MacMenuItem(
                item: items[i],
                onTap: () => onItemSelected(items[i].title),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
