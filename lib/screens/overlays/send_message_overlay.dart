import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../config/app_design.dart';

/// A glassmorphic overlay widget that appears in the center of the screen
/// Contains an avatar section on the left and a contact form on the right
class SendMessageOverlay extends StatefulWidget {
  final VoidCallback? onClose;
  final Function(String message)? onSendMessage;

  const SendMessageOverlay({super.key, this.onClose, this.onSendMessage});

  @override
  State<SendMessageOverlay> createState() => _SendMessageOverlayState();
}

class _SendMessageOverlayState extends State<SendMessageOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;
  bool _isLoading = false;
  String whereDoesTheMessageGo =
      "Don't worry, the messages actually reach me. The moment you hit send, I get a notification on my phone. Make sure you include your contact info if you wanna keep in touch though.";
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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.onSendMessage != null) {
        await widget.onSendMessage!(_messageController.text);
      }

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
        _closeOverlay();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send message. Please try again.',
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
                  width: 700,
                  height: 500,
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      // Close button in top left
                      Positioned(
                        top: 0,
                        left: 0,
                        child: GestureDetector(
                          onTap: _closeOverlay,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppDesign.glassmorphicBorder,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
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
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/memoji-message.png", width: 150),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Where does it even go?"),
              GestureDetector(
                onTap: _toggleExpanded,
                child: _isExpanded
                    ? Icon(Icons.keyboard_arrow_down_rounded)
                    : Icon(Icons.keyboard_arrow_up_rounded),
              ),
            ],
          ),
        ),
        if (_isExpanded) Text(whereDoesTheMessageGo),
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
            'Send a Message!',
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
          const SizedBox(height: 32),

          // Message Field
          Expanded(
            child: TextFormField(
              controller: _messageController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppDesign.body.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: AppDesign.body.copyWith(
                  color: Colors.white.withOpacity(0.5),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a message';
                }
                if (value.trim().length < 10) {
                  return 'Message must be at least 10 characters long';
                }
                return null;
              },
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
    Function(String message)? onSendMessage,
  }) {
    showDialog(
      context: this,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => SendMessageOverlay(
        onClose: onClose ?? () => Navigator.of(context).pop(),
        onSendMessage: onSendMessage,
      ),
    );
  }
}
