import 'package:flutter/material.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';

class MacMenuItem extends StatefulWidget {
  final MenuItemData item;
  final VoidCallback onTap;

  const MacMenuItem({super.key, required this.item, required this.onTap});

  @override
  State<MacMenuItem> createState() => _MacMenuItemState();
}

class _MacMenuItemState extends State<MacMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF007AFF).withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(widget.item.icon, color: Colors.white, size: 16),
              const SizedBox(width: 12),
              Text(widget.item.title, style: AppDesign.menuItem()),
            ],
          ),
        ),
      ),
    );
  }
}
