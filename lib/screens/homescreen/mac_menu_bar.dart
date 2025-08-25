import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/screens/homescreen/mac_dropdown_menu.dart';
import 'package:portfolio/screens/overlays/battery_status_overlay.dart';
import 'package:portfolio/screens/overlays/github_stats_overlay.dart';
import 'package:portfolio/screens/overlays/send_message_overlay.dart';
import 'package:portfolio/screens/overlays/wifi_connection_overlay.dart';

class MacMenuBar extends StatefulWidget {
  const MacMenuBar({super.key});

  @override
  State<MacMenuBar> createState() => _MacMenuBarState();
}

class _MacMenuBarState extends State<MacMenuBar> {
  bool _isFileMenuOpen = false;
  bool _isWifiPopupOpen = false;
  bool _isBatteryPopupOpen = false;
  bool _isPortfolioMenuOpen = false;
  bool _isGithubMenuOpen = false;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _wifiOverlayEntry;
  OverlayEntry? _batteryOverlayEntry;
  OverlayEntry? _portfolioOverlayEntry;
  OverlayEntry? _githubOverlayEntry;

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

  void _toggleBatteryStatusPopup() {
    if (_isBatteryPopupOpen) {
      _closeBatteryPopup();
    } else {
      _openBatteryPopup();
    }
  }

  void _closeBatteryPopup() {
    setState(() => _isBatteryPopupOpen = false);
    _batteryOverlayEntry?.remove();
    _batteryOverlayEntry = null;
  }

  void _openBatteryPopup() {
    setState(() {
      _isBatteryPopupOpen = true;
    });

    _batteryOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeBatteryPopup,
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Center(
            child: BatteryStatusOverlay(onClose: _closeBatteryPopup),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_batteryOverlayEntry!);
  }

  void _openWifiPopup() {
    setState(() => _isWifiPopupOpen = true);

    _wifiOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeWifiPopup,
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Center(child: WifiConnectionOverlay(onClose: _closeWifiPopup)),
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

  void _toggleGithubMenu() {
    if (_isGithubMenuOpen) {
      _closeGithubMenu();
    } else {
      _openGithubMenu();
    }
  }

  void _openGithubMenu() {
    setState(() => _isGithubMenuOpen = true);

    _githubOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeGithubMenu,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                right: 80, // Position to the right of the WiFi icon
                child: GithubStatsOverlay(),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_githubOverlayEntry!);
  }

  void _closeGithubMenu() {
    setState(() => _isGithubMenuOpen = false);
    _githubOverlayEntry?.remove();
    _githubOverlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _wifiOverlayEntry?.remove();
    _portfolioOverlayEntry?.remove();
    _githubOverlayEntry?.remove();
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
        color: Colors.black.withValues(alpha: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.command,
                        color: Colors.white,
                        size: 18,
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
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('File', style: AppDesign.menuBarText()),
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.transparent,
                    builder: (context) =>
                        SendMessageOverlay(title: "Drop a feedback!"),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isFileMenuOpen
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Drop a feedback',
                    style: AppDesign.menuBarText(),
                  ),
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
                    onTap: _toggleGithubMenu,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isGithubMenuOpen
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Bootstrap.github,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _toggleWifiPopup,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isWifiPopupOpen
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        CupertinoIcons.wifi,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _toggleBatteryStatusPopup,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isBatteryPopupOpen
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        CupertinoIcons.battery_full,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
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
