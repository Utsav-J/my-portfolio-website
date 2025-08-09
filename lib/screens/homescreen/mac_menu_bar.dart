import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/config/app_design.dart';

class MacMenuBar extends StatefulWidget {
  const MacMenuBar({Key? key}) : super(key: key);

  @override
  State<MacMenuBar> createState() => _MacMenuBarState();
}

class _MacMenuBarState extends State<MacMenuBar> {
  bool _isFileMenuOpen = false;
  bool _isWifiPopupOpen = false;
  bool _isPortfolioMenuOpen = false;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _wifiOverlayEntry;
  OverlayEntry? _portfolioOverlayEntry;

  void _toggleFileMenu() {
    if (_isFileMenuOpen) {
      _closeFileMenu();
    } else {
      _openFileMenu();
    }
  }

  void _openFileMenu() {
    setState(() => _isFileMenuOpen = true);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeFileMenu,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 76, // Approximate position of "File" text
                child: MacDropdownMenu(
                  onItemSelected: (action) {
                    _closeFileMenu();
                    _handleMenuAction(action);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeFileMenu() {
    setState(() => _isFileMenuOpen = false);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'Download Resume':
        // TODO: Implement resume download
        print('Downloading resume...');
        break;
      case 'Print Portfolio':
        // TODO: Implement print functionality
        print('Printing portfolio...');
        break;
      case 'Share Portfolio':
        // TODO: Implement share functionality
        print('Sharing portfolio...');
        break;
      case 'Export as PDF':
        // TODO: Implement PDF export
        print('Exporting as PDF...');
        break;
      case 'Settings':
        // TODO: Implement settings
        print('Opening settings...');
        break;
    }
  }

  void _toggleWifiPopup() {
    if (_isWifiPopupOpen) {
      _closeWifiPopup();
    } else {
      _openWifiPopup();
    }
  }

  void _openWifiPopup() {
    setState(() => _isWifiPopupOpen = true);

    _wifiOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeWifiPopup,
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: WifiConnectionPopup(
              onClose: _closeWifiPopup,
              onLinkedInConnect: () {
                _closeWifiPopup();
                _openLinkedIn();
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_wifiOverlayEntry!);
  }

  void _closeWifiPopup() {
    setState(() => _isWifiPopupOpen = false);
    _wifiOverlayEntry?.remove();
    _wifiOverlayEntry = null;
  }

  void _openLinkedIn() {
    // TODO: Implement LinkedIn URL launch
    print('Opening LinkedIn profile...');
  }

  void _togglePortfolioMenu() {
    if (_isPortfolioMenuOpen) {
      _closePortfolioMenu();
    } else {
      _openPortfolioMenu();
    }
  }

  void _openPortfolioMenu() {
    setState(() => _isPortfolioMenuOpen = true);

    _portfolioOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closePortfolioMenu,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 16, // Align with the portfolio title
                child: MacDropdownMenu(
                  onItemSelected: (action) {
                    _closePortfolioMenu();
                    _handlePortfolioAction(action);
                  },
                  menuItems: [
                    MenuItemData('View Source Code', CupertinoIcons.doc_text),
                    MenuItemData('Drop a Feedback', CupertinoIcons.chat_bubble),
                    MenuItemData('Lock Device', CupertinoIcons.lock),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_portfolioOverlayEntry!);
  }

  void _closePortfolioMenu() {
    setState(() => _isPortfolioMenuOpen = false);
    _portfolioOverlayEntry?.remove();
    _portfolioOverlayEntry = null;
  }

  void _handlePortfolioAction(String action) {
    switch (action) {
      case 'View Source Code':
        // TODO: Implement source code navigation
        print('Opening source code...');
        break;
      case 'Drop a Feedback':
        // TODO: Implement feedback form
        print('Opening feedback form...');
        break;
      case 'Lock Device':
        // TODO: Implement device lock
        print('Locking device...');
        break;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _wifiOverlayEntry?.remove();
    _portfolioOverlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);

    return Container(
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Apple logo and Portfolio title
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _togglePortfolioMenu,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isPortfolioMenuOpen
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.command,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Utsav\'s Portfolio',
                        style: AppDesign.menuBarText(),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),

            // File menu dropdown
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _toggleFileMenu,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isFileMenuOpen
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('File', style: AppDesign.menuBarText()),
                ),
              ),
            ),
            const Spacer(),
            // Right side menu items
            Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _toggleWifiPopup,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        CupertinoIcons.wifi,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.battery_full,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(formattedTime, style: AppDesign.menuBarTime()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MacDropdownMenu extends StatelessWidget {
  final Function(String) onItemSelected;
  final List<MenuItemData>? menuItems;

  const MacDropdownMenu({
    Key? key,
    required this.onItemSelected,
    this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items =
        menuItems ??
        [
          MenuItemData('Download Resume', CupertinoIcons.cloud_download),
          MenuItemData('Print Portfolio', CupertinoIcons.printer),
          MenuItemData('Share Portfolio', CupertinoIcons.share),
          MenuItemData('Export as PDF', CupertinoIcons.doc),
          MenuItemData('Settings', CupertinoIcons.gear),
        ];

    return Material(
      color: Colors.transparent,
      child: AppDesign.glassmorphicContainer(
        width: 180,
        borderRadius: 8.0,
        blurStrength: 15.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              MacMenuItem(
                item: items[i],
                onTap: () => onItemSelected(items[i].title),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.white.withOpacity(0.1),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class MacMenuItem extends StatefulWidget {
  final MenuItemData item;
  final VoidCallback onTap;

  const MacMenuItem({Key? key, required this.item, required this.onTap})
    : super(key: key);

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

class WifiConnectionPopup extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onLinkedInConnect;

  const WifiConnectionPopup({
    Key? key,
    required this.onClose,
    required this.onLinkedInConnect,
  }) : super(key: key);

  @override
  State<WifiConnectionPopup> createState() => _WifiConnectionPopupState();
}

class _WifiConnectionPopupState extends State<WifiConnectionPopup>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _closeWithAnimation() async {
    await _scaleController.reverse();
    await _fadeController.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: AppDesign.glassmorphicContainer(
            width: 400,
            padding: const EdgeInsets.all(24),
            borderRadius: 16.0,
            blurStrength: 20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // WiFi Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    CupertinoIcons.wifi,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text('WiFi Connection', style: AppDesign.popupTitle()),
                const SizedBox(height: 12),

                // Message
                Text(
                  'You\'re already connected to a WiFi network.\nWanna connect with me instead?',
                  textAlign: TextAlign.center,
                  style: AppDesign.popupBody(),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _closeWithAnimation,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Maybe Later',
                          style: AppDesign.buttonText(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onLinkedInConnect,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(
                            0xFF0077B5,
                          ), // LinkedIn blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Connect on LinkedIn',
                              style: AppDesign.buttonText().copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
