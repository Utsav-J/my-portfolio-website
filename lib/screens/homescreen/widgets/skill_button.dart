import 'package:flutter/material.dart';

class SkillButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isHighlighted;
  final List<Color>? gradient;

  const SkillButton(
    this.label,
    this.iconPath,
    this.isHighlighted, {
    this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isHighlighted && gradient != null
            ? LinearGradient(
                colors: gradient!,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isHighlighted ? null : const Color(0xFF1F2937),
        border: isHighlighted
            ? null
            : Border.all(color: const Color(0xFF374151), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox(width: 20, height: 20),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isHighlighted
                  ? Colors.white
                  : Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}