import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppScreen extends StatefulWidget {
  final String title;
  final VoidCallback? onClose;
  final Widget child;
  final Offset initialPosition;
  final double? windowWidth;
  final double? windowHeight;
  final Function(Offset)? onPositionChanged;

  const AppScreen({
    Key? key,
    required this.title,
    this.onClose,
    required this.child,
    this.initialPosition = const Offset(0, 0),
    this.onPositionChanged,
    this.windowHeight,
    this.windowWidth,
  }) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  Offset position = Offset.zero;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      position += details.delta;
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
      child: Container(
        width: widget.windowWidth ?? 400,
        height: widget.windowHeight ?? 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDragging ? 0.3 : 0.2),
              blurRadius: isDragging ? 25 : 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
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
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFF27C93F),
                                shape: BoxShape.circle,
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
                                        fontWeight: FontWeight.w400,
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
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            // Three Dots Menu
                            Icon(
                              CupertinoIcons.ellipsis,
                              color: Colors.white.withOpacity(0.8),
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
    );
  }
}
