import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScreen extends StatefulWidget {
  final String title;
  final VoidCallback? onClose;
  final Widget child;
  final Offset initialPosition;
  final double? windowWidth;
  final double? windowHeight;
  final Function(Offset)? onPositionChanged;
  final VoidCallback? onBringToFront;

  const AppScreen({
    super.key,
    required this.title,
    this.onClose,
    required this.child,
    this.initialPosition = const Offset(0, 0),
    this.onPositionChanged,
    this.windowHeight,
    this.windowWidth,
    this.onBringToFront,
  });

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  Offset position = Offset.zero;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    position = widget
        .initialPosition; // Don't constrain position here, wait for context
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure position is still within bounds when dependencies change (e.g., screen size)
    // Only constrain if we have a valid context
    if (mounted) {
      final constrainedPosition = _getConstrainedPosition(position);
      if (constrainedPosition != position) {
        setState(() {
          position = constrainedPosition;
        });
      }
    }
  }

  // Helper method to get constrained position within screen boundaries
  Offset _getConstrainedPosition(Offset position) {
    // Get screen dimensions safely
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return position; // Return original position if MediaQuery is not available
    }

    final screenSize = mediaQuery.size;
    final windowWidth = (widget.windowWidth ?? 400).w;
    final windowHeight = (widget.windowHeight ?? 300).h;

    // Define boundaries
    final menuBarHeight = 30.0.h; // Menu bar height
    final dockHeight = 60.0.h; // Dock height
    final dockBottomPadding = 20.0.h; // Bottom padding for dock

    // Apply constraints
    double constrainedX = position.dx;
    double constrainedY = position.dy;

    // Left boundary: can't go beyond left edge
    if (constrainedX < 0) {
      constrainedX = 0;
    }

    // Right boundary: can't go beyond right edge
    if (constrainedX + windowWidth > screenSize.width) {
      constrainedX = screenSize.width - windowWidth;
    }

    // Top boundary: can't go above menu bar
    if (constrainedY < menuBarHeight) {
      constrainedY = menuBarHeight;
    }

    // Bottom boundary: can't go below dock area
    final bottomBoundary =
        screenSize.height - dockHeight - dockBottomPadding - windowHeight;
    if (constrainedY > bottomBoundary) {
      constrainedY = bottomBoundary;
    }

    return Offset(constrainedX, constrainedY);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Get screen dimensions safely
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return; // Don't proceed if MediaQuery is not available
    }

    final screenSize = mediaQuery.size;
    final windowWidth = (widget.windowWidth ?? 400).w;
    final windowHeight = (widget.windowHeight ?? 300).h;

    // Define boundaries
    final menuBarHeight = 30.0.h; // Menu bar height
    final dockHeight = 60.0.h; // Dock height
    final dockBottomPadding = 20.0.h; // Bottom padding for dock

    // Calculate new position
    Offset newPosition = position + details.delta;

    // Apply constraints
    // Left boundary: can't go beyond left edge
    if (newPosition.dx < 0) {
      newPosition = Offset(0, newPosition.dy);
    }

    // Right boundary: can't go beyond right edge
    if (newPosition.dx + windowWidth > screenSize.width) {
      newPosition = Offset(screenSize.width - windowWidth, newPosition.dy);
    }

    // Top boundary: can't go above menu bar
    if (newPosition.dy < menuBarHeight) {
      newPosition = Offset(newPosition.dx, menuBarHeight);
    }

    // Bottom boundary: can't go below dock area
    final bottomBoundary =
        screenSize.height - dockHeight - dockBottomPadding - windowHeight;
    if (newPosition.dy > bottomBoundary) {
      newPosition = Offset(newPosition.dx, bottomBoundary);
    }

    setState(() {
      position = newPosition;
    });
    widget.onPositionChanged?.call(position);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: widget.onBringToFront, // Bring window to front when tapped
        child: Container(
          width: (widget.windowWidth ?? 600).w,
          height: (widget.windowHeight ?? 400).h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDragging ? 0.3 : 0.2),
                blurRadius: isDragging ? 25 : 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Column(
              children: [
                // App Bar (Dark Grey Header) - Draggable Area
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left Side - Window Controls
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              // Red Close Button
                              GestureDetector(
                                onTap: widget.onClose ?? () {},
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF5F56),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Yellow Minimize Button
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFBD2E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Green Maximize Button
                              GestureDetector(
                                onTap: widget.onClose ?? () {},
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF27C93F),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Middle Section - Address/Search Bar
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        widget.title,
                                        style: const TextStyle(
                                          color: Color(0xFF2C2C2C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  // Search Icon
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      CupertinoIcons.search,
                                      color: const Color(0xFF2C2C2C),
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Right Side - Menu Options
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            children: [
                              // Plus Icon
                              Icon(
                                CupertinoIcons.add,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 12),
                              // Three Dots Menu
                              Icon(
                                CupertinoIcons.ellipsis,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content Area (White Section)
                Expanded(
                  child: Container(color: Colors.white, child: widget.child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
