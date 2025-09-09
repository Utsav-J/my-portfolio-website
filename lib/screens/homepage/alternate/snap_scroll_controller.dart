import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnapScrollController {
  final PageController _pageController = PageController();
  int _currentSection = 0;
  final int totalSections = 5;

  PageController get pageController => _pageController;
  int get currentSection => _currentSection;

  void nextSection() {
    if (_currentSection < totalSections - 1) {
      _currentSection++;
      _pageController.animateToPage(
        _currentSection,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousSection() {
    if (_currentSection > 0) {
      _currentSection--;
      _pageController.animateToPage(
        _currentSection,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToSection(int section) {
    if (section >= 0 && section < totalSections) {
      _currentSection = section;
      _pageController.animateToPage(
        section,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void dispose() {
    _pageController.dispose();
  }
}

class SnapScrollSection extends StatefulWidget {
  final Widget child;
  final SnapScrollController controller;
  final int sectionIndex;

  const SnapScrollSection({
    super.key,
    required this.child,
    required this.controller,
    required this.sectionIndex,
  });

  @override
  State<SnapScrollSection> createState() => _SnapScrollSectionState();
}

class _SnapScrollSectionState extends State<SnapScrollSection> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;
  bool _isAtTop = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final isAtBottom = position.pixels >= position.maxScrollExtent - 50;
    final isAtTop = position.pixels <= 50;

    print(
      'Scroll: ${position.pixels}/${position.maxScrollExtent}, isAtBottom: $isAtBottom, isAtTop: $isAtTop',
    );

    if (isAtBottom != _isAtBottom) {
      setState(() {
        _isAtBottom = isAtBottom;
      });
      print('Updated _isAtBottom to: $_isAtBottom');
    }

    if (isAtTop != _isAtTop) {
      setState(() {
        _isAtTop = isAtTop;
      });
      print('Updated _isAtTop to: $_isAtTop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        Container(
          width: 1.sw,
          height: 1.sh,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: widget.child,
          ),
        ),

        // Invisible gesture detector overlay
        Positioned.fill(
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                print(
                  'Drag velocity: ${details.primaryVelocity}, isAtBottom: $_isAtBottom, isAtTop: $_isAtTop',
                );
                if (details.primaryVelocity! > 0 && _isAtBottom) {
                  print('Swipe up at bottom - going to next section');
                  widget.controller.nextSection();
                } else if (details.primaryVelocity! < 0 && _isAtTop) {
                  print('Swipe down at top - going to previous section');
                  widget.controller.previousSection();
                }
              }
            },
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
