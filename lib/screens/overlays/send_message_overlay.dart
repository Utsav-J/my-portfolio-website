import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/app_design.dart';

/// A glassmorphic overlay widget that appears in the center of the screen
/// Contains an avatar section on the left and a contact form on the right
class SendMessageOverlay extends StatefulWidget {
  final String title;
  final VoidCallback? onClose;

  const SendMessageOverlay({super.key, this.onClose, required this.title});

  @override
  State<SendMessageOverlay> createState() => _SendMessageOverlayState();
}

class _SendMessageOverlayState extends State<SendMessageOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isExpanded = false;
  bool _isLoading = false;
  String _selectedContactType = 'email';

  String whereDoesTheMessageGo =
      "Don't worry, the messages actually reach me. The moment you hit send, I get a notification on my phone.\nMake sure you include your contact info if you wanna keep in touch though.";

  final List<Map<String, String>> _contactTypes = [
    {'value': 'email', 'label': 'Email', 'hint': 'your.email@example.com'},
    {
      'value': 'linkedin',
      'label': 'LinkedIn',
      'hint': 'linkedin.com/in/yourprofile',
    },
    {'value': 'whatsapp', 'label': 'WhatsApp', 'hint': '+1234567890'},
    {
      'value': 'anonymous',
      'label': 'Anonymous',
      'hint': 'No contact info needed',
    },
  ];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _animationController.reverse().then((_) {
      if (widget.onClose != null) {
        widget.onClose!();
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _handleSendMessage() async {
    // Validate all fields first
    if (!_validateAllFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create message data object
      final messageData = {
        'message': _messageController.text.trim(),
        'contactType': _selectedContactType,
        'contactInfo': _contactController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save message to Firestore
      await FirebaseFirestore.instance.collection('messages').add(messageData);

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Message sent successfully!',
              style: AppDesign.body.copyWith(color: Colors.white),
            ),
            backgroundColor: AppDesign.systemGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
            ),
          ),
        );

        _messageController.clear();
        _contactController.clear();
        _closeOverlay();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred during validation.',
              style: AppDesign.body.copyWith(color: Colors.white),
            ),
            backgroundColor: AppDesign.systemRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Validation methods
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidLinkedInUrl(String url) {
    // Accept both linkedin.com/in/username and www.linkedin.com/in/username
    final linkedinRegex = RegExp(
      r'^(https?://)?(www\.)?linkedin\.com/in/[a-zA-Z0-9_-]+/?$',
    );
    return linkedinRegex.hasMatch(url);
  }

  bool _isValidWhatsAppNumber(String number) {
    // Remove spaces, hyphens, and parentheses for normalization
    final cleaned = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    final whatsappRegex = RegExp(r'^\+?[1-9]\d{7,14}$');

    return whatsappRegex.hasMatch(cleaned);
  }

  String? _validateContactInfo(String? value) {
    if (_selectedContactType == 'anonymous') {
      return null; // No validation needed for anonymous
    }

    if (value == null || value.trim().isEmpty) {
      return 'Please provide your contact information';
    }

    final trimmedValue = value.trim();

    switch (_selectedContactType) {
      case 'email':
        if (!_isValidEmail(trimmedValue)) {
          return 'Please enter a valid email address';
        }
        break;
      case 'linkedin':
        if (!_isValidLinkedInUrl(trimmedValue)) {
          return 'Please enter a valid LinkedIn profile URL (e.g., linkedin.com/in/username)';
        }
        break;
      case 'whatsapp':
        if (!_isValidWhatsAppNumber(trimmedValue)) {
          return 'Please enter a valid phone number with country code (e.g., +1234567890)';
        }
        break;
    }

    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a message';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 10) {
      return 'Message must be at least 10 characters long';
    }

    // Check word count (roughly 500 words)
    final words = trimmedValue.split(RegExp(r'\s+'));
    if (words.length > 500) {
      return 'Message must be 500 words or less';
    }

    return null;
  }

  bool _validateAllFields() {
    // Validate contact info
    final contactValidation = _validateContactInfo(_contactController.text);
    if (contactValidation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(contactValidation),
          backgroundColor: AppDesign.systemRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
          ),
        ),
      );
      return false;
    }

    // Validate message
    final messageValidation = _validateMessage(_messageController.text);
    if (messageValidation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messageValidation),
          backgroundColor: AppDesign.systemRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
          ),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Background overlay that handles tap to close
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeOverlay,
                child: Container(color: Colors.black54),
              ),
            ),

            // Main content
            Center(
              child: GestureDetector(
                onTap:
                    () {}, // Prevent closing when tapping on the overlay content
                child: AppDesign.glassmorphicContainer(
                  width: 900.w,
                  height: null, // Allow height to grow based on content
                  padding: EdgeInsets.all(24.w),
                  child: IntrinsicHeight(
                    // This will make the container grow with content
                    child: Stack(
                      children: [
                        // Close button in top left
                        Positioned(
                          top: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: _closeOverlay,
                            child: Container(
                              width: 32.h,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppDesign.glassmorphicBorder,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),

                        // Main content
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Align items to top
                            children: [
                              // Left Section - Avatar
                              Expanded(flex: 2, child: _buildAvatarSection()),

                              // Divider
                              Container(
                                width: 1,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: AppDesign.glassmorphicBorder,
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),

                              // Right Section - Form
                              Expanded(flex: 3, child: _buildFormSection()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _selectedContactType == 'anonymous'
            ? Image.asset(
                "assets/images/memoji-private-message.png",
                width: 150,
              )
            : Image.asset("assets/images/memoji-message.png", width: 150),
        const SizedBox(height: 16),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Where does it even go?",
                  style: AppDesign.subhead.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          Text(
            whereDoesTheMessageGo,
            style: AppDesign.footnote.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ],
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            widget.title,
            style: AppDesign.title1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'I\'d love to hear from you! Send me a message and I\'ll get back to you soon.',
            style: AppDesign.body.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(height: 24),

          // Contact Type Dropdown and Contact Info Field (merged)
          Text(
            'How should I contact you back?',
            style: AppDesign.subhead.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              // Contact Type Dropdown (left side)
              Container(
                width: 150.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
                  border: Border.all(
                    color: AppDesign.glassmorphicBorder,
                    width: 1.sp,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedContactType,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.w,
                    ),
                    border: InputBorder.none,
                    hintText: 'Type',
                    hintStyle: AppDesign.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 16.sp,
                    ),
                  ),
                  dropdownColor: AppDesign.darkSecondaryBackground,
                  style: AppDesign.body.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 18.sp,
                  ),
                  items: _contactTypes.map((contactType) {
                    return DropdownMenuItem<String>(
                      value: contactType['value'],
                      child: Text(
                        contactType['label']!,
                        style: AppDesign.body.copyWith(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedContactType = value!;
                      if (value == 'anonymous') {
                        _contactController.clear();
                      }
                    });
                  },
                ),
              ),

              SizedBox(width: 12.w),

              // Contact Info Field (right side)
              Expanded(
                child: TextFormField(
                  controller: _contactController,
                  enabled: _selectedContactType != 'anonymous',
                  style: AppDesign.body.copyWith(
                    color: _selectedContactType != 'anonymous'
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                  decoration: InputDecoration(
                    hintText: _selectedContactType == 'anonymous'
                        ? 'No contact info needed'
                        : _contactTypes.firstWhere(
                            (ct) => ct['value'] == _selectedContactType,
                          )['hint'],
                    hintStyle: AppDesign.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: _selectedContactType != 'anonymous'
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDesign.mediumRadius,
                      ),
                      borderSide: BorderSide(
                        color: AppDesign.glassmorphicBorder,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDesign.mediumRadius,
                      ),
                      borderSide: BorderSide(
                        color: AppDesign.glassmorphicBorder,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDesign.mediumRadius,
                      ),
                      borderSide: BorderSide(
                        color: AppDesign.systemBlue,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: _validateContactInfo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Message Field (smaller size)
          Text(
            'Your message',
            style: AppDesign.subhead.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120, // Fixed height instead of expanded
            child: TextFormField(
              controller: _messageController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppDesign.body.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message here... (max 500 words)',
                hintStyle: AppDesign.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
                  borderSide: BorderSide(
                    color: AppDesign.glassmorphicBorder,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
                  borderSide: BorderSide(
                    color: AppDesign.glassmorphicBorder,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
                  borderSide: BorderSide(color: AppDesign.systemBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              validator: _validateMessage,
            ),
          ),

          const SizedBox(height: 24),

          // Send Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesign.systemBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.mediumRadius),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Send',
                      style: AppDesign.buttonText(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension to easily show the SendMessageOverlay from any widget
extension SendMessageOverlayExtension on BuildContext {
  /// Shows the SendMessageOverlay as a full-screen overlay
  void showSendMessageOverlay({
    VoidCallback? onClose,
    String title = "Send a Message!",
  }) {
    showDialog(
      context: this,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => SendMessageOverlay(
        title: title,
        onClose: onClose ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}
