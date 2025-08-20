import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/config/app_design.dart';

class MacAppIcon extends StatefulWidget {
  final PortfolioApp app;

  const MacAppIcon({super.key, required this.app});

  @override
  State<MacAppIcon> createState() => _MacAppIconState();
}

class _MacAppIconState extends State<MacAppIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.app.onTap,
        child: AnimatedScale(
          scale: isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.app.color,
                      widget.app.color.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(widget.app.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 6),
              Text(
                widget.app.title,
                style: AppDesign.appTitle().copyWith(
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
