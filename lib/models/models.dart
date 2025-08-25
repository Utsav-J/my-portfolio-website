import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Export About Me screen components
export '../screens/appscreen/about_me_screen.dart';
export '../screens/appscreen/experience_screen.dart';
export '../screens/appscreen/certifications_screen.dart';
export '../screens/appscreen/education_screen.dart';
export '../screens/appscreen/projects_screen.dart';

class Education {
  final String course;
  final String grades;
  final String image;
  final String location;
  final String name;
  final List<String> description;

  Education({
    required this.course,
    required this.grades,
    required this.image,
    required this.location,
    required this.name,
    required this.description,
  });

  factory Education.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<String> parsedDescription = [];
    final dynamic rawDescription = data['description'];
    if (rawDescription is List) {
      parsedDescription = rawDescription.whereType<String>().toList();
    } else if (rawDescription is String) {
      final String trimmed = rawDescription.trim();
      if (trimmed.isNotEmpty) {
        parsedDescription = [trimmed];
      }
    }

    return Education(
      course: data['course'] ?? '',
      grades: data['grades'] ?? '',
      image: data['image'] ?? '',
      location: data['location'] ?? '',
      name: data['name'] ?? '',
      description: parsedDescription,
    );
  }
}

class Project {
  final List<String> description;
  final String githubUrl;
  final String imageUrl;
  final String name;
  final int rank;

  Project({
    required this.description,
    required this.githubUrl,
    required this.imageUrl,
    required this.name,
    required this.rank,
  });

  factory Project.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<String> parsedDescription = [];
    final dynamic rawDescription = data['description'];
    if (rawDescription is List) {
      parsedDescription = rawDescription.whereType<String>().toList();
    } else if (rawDescription is String) {
      final String trimmed = rawDescription.trim();
      if (trimmed.isNotEmpty) {
        parsedDescription = [trimmed];
      }
    }

    return Project(
      description: parsedDescription,
      githubUrl: data['githubUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      rank: data['rank'] ?? 0,
    );
  }
}

class Experience {
  final String companyName;
  final List<String> description;
  final String duration;
  final String endDate;
  final String role;
  final String startDate;

  Experience({
    required this.companyName,
    required this.description,
    required this.duration,
    required this.endDate,
    required this.role,
    required this.startDate,
  });

  factory Experience.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final dynamic rawDescription = data['description'];
    List<String> parsedDescription = [];
    if (rawDescription is List) {
      parsedDescription = rawDescription.whereType<String>().toList();
    } else if (rawDescription is String) {
      final String trimmed = rawDescription.trim();
      if (trimmed.isNotEmpty) {
        parsedDescription = [trimmed];
      }
    }
    return Experience(
      companyName: data['companyName'] ?? '',
      description: parsedDescription,
      duration: data['duration'] ?? '',
      endDate: data['endDate'] ?? '',
      role: data['role'] ?? '',
      startDate: data['startDate'] ?? '',
    );
  }

  DateTime? get startDateTime {
    try {
      // Parse dates like "June, 2025" to DateTime
      final months = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      final parts = startDate.split(', ');
      if (parts.length == 2) {
        final month = months[parts[0]];
        final year = int.tryParse(parts[1]);
        if (month != null && year != null) {
          return DateTime(year, month);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

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
