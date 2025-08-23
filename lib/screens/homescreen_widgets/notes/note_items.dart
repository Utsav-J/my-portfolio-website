
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/config/app_design.dart';

class NoteItem extends StatelessWidget {
  final String title;
  final String content;
  const NoteItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [const Color.fromARGB(8, 255, 255, 255), Colors.white24],
          center: Alignment.topLeft,
          radius: AppDesign.largeRadius,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: GoogleFonts.shantellSans(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              content,
              style: GoogleFonts.shantellSans(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ThoughtNoteItem extends StatelessWidget {
  final String content;
  const ThoughtNoteItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [const Color.fromARGB(8, 255, 255, 255), Colors.white24],
          center: Alignment.topLeft,
          radius: AppDesign.largeRadius,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          content,
          style: GoogleFonts.shantellSans(color: Colors.white),
        ),
      ),
    );
  }
}
