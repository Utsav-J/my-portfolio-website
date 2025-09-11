import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/utils/firebase_utils.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _selectedContactType = 'email';

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
  void dispose() {
    _messageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // Validation helpers (aligned with overlay logic)
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidLinkedInUrl(String url) {
    final linkedinRegex = RegExp(
      r'^(https?://)?(www\.)?linkedin\.com/in/[a-zA-Z0-9_-]+/?$',
    );
    return linkedinRegex.hasMatch(url);
  }

  bool _isValidWhatsAppNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final whatsappRegex = RegExp(r'^\+?[1-9]\d{7,14}$');
    return whatsappRegex.hasMatch(cleaned);
  }

  String? _validateContactInfo(String? value) {
    if (_selectedContactType == 'anonymous') return null;
    if (value == null || value.trim().isEmpty)
      return 'Please provide your contact information';
    final v = value.trim();
    switch (_selectedContactType) {
      case 'email':
        if (!_isValidEmail(v)) return 'Please enter a valid email address';
        break;
      case 'linkedin':
        if (!_isValidLinkedInUrl(v)) return 'Enter a valid LinkedIn URL';
        break;
      case 'whatsapp':
        if (!_isValidWhatsAppNumber(v))
          return 'Enter a valid phone number with country code';
        break;
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter a message';
    final trimmed = value.trim();
    if (trimmed.length < 10) return 'Message must be at least 10 characters';
    if (trimmed.split(RegExp(r'\s+')).length > 500)
      return 'Message must be 500 words or less';
    return null;
  }

  Future<void> _handleSend() async {
    final contactError = _validateContactInfo(_contactController.text);
    final messageError = _validateMessage(_messageController.text);
    if (contactError != null || messageError != null) {
      final errorText = contactError ?? messageError!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText),
          backgroundColor: AppDesign.systemRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseUtils.sendMessage({
        'message': _messageController.text.trim(),
        'contactType': _selectedContactType,
        'contactInfo': _contactController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Message sent successfully!',
            style: AppDesign.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppDesign.systemGreen,
        ),
      );
      _messageController.clear();
      _contactController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message'),
          backgroundColor: AppDesign.systemRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppDesign.amoled,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),
            Center(
              child: _selectedContactType == "anonymous"
                  ? Image.asset(
                      'assets/images/memoji-private-message.png',
                      width: 160.w,
                    )
                  : Image.asset(
                      'assets/images/memoji-message.png',
                      width: 160.w,
                    ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'Send a Message!',
                style: AppDesign.title1.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Center(
              child: Text(
                "I'd love to hear from you. Send me a message and I'll get back to you soon.",
                style: AppDesign.body.copyWith(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20.h),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How should I contact you back?',
                    style: AppDesign.subhead.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppDesign.mediumRadius,
                          ),
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
                          items: _contactTypes
                              .map(
                                (ct) => DropdownMenuItem<String>(
                                  value: ct['value'],
                                  child: Text(ct['label']!),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedContactType = value!;
                              if (value == 'anonymous')
                                _contactController.clear();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextFormField(
                          controller: _contactController,
                          enabled: _selectedContactType != 'anonymous',
                          style: AppDesign.body.copyWith(
                            fontSize: 14.sp,
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
                              fontSize: 12.sp,
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
                            contentPadding: EdgeInsets.all(16.w),
                          ),
                          validator: _validateContactInfo,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    'Your message',
                    style: AppDesign.subhead.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 150.h,
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppDesign.body.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message here... (max 500 words)',
                        hintStyle: AppDesign.body.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
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
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                      validator: _validateMessage,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppDesign.systemBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDesign.mediumRadius,
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Send',
                              style: AppDesign.body.copyWith(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}
