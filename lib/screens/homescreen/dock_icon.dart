import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/models/models.dart';

class DockIcon extends StatefulWidget {
  final DockApp app;

  const DockIcon({Key? key, required this.app}) : super(key: key);

  @override
  State<DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<DockIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedScale(
          scale: isHovered ? 1.3 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(widget.app.icon, color: Colors.black87, size: 24),
          ),
        ),
      ),
    );
  }
}
