import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Export About Me screen components
export '../screens/appscreen/about_me_screen.dart';
export '../screens/appscreen/experience_screen.dart';
export '../screens/appscreen/certifications_screen.dart';
export '../screens/appscreen/education_screen.dart';

class PortfolioApp {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  PortfolioApp({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.height,
    this.width,
  });
}

class DockApp {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  DockApp({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });
}

class MenuItemData {
  final String title;
  final IconData icon;

  MenuItemData(this.title, this.icon);
}

class Certification {
  final String name;
  final String date;
  final String company;

  Certification({
    required this.name,
    required this.date,
    required this.company,
  });

  factory Certification.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return Certification(
      name: (data['name'] ?? '').toString(),
      date: (data['date'] ?? '').toString(),
      company: (data['company'] ?? '').toString(),
    );
  }
}
