import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PortfolioApp {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  PortfolioApp({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class DockApp {
  final IconData icon;
  final String title;

  DockApp({required this.icon, required this.title});
}

class MenuItemData {
  final String title;
  final IconData icon;

  MenuItemData(this.title, this.icon);
}
