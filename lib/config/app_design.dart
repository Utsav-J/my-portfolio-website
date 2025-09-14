import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class AppDesign {
  AppDesign._();
  static TextStyle largeTitle = GoogleFonts.quicksand(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    height: 1.12,
  );

  static TextStyle title1 = GoogleFonts.quicksand(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.36,
    height: 1.14,
  );

  /// Title 2 text style
  static TextStyle title2 = GoogleFonts.quicksand(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.35,
    height: 1.18,
  );

  /// Title 3 text style
  static TextStyle title3 = GoogleFonts.quicksand(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.38,
    height: 1.20,
  );

  /// Headline text style
  static TextStyle headline = GoogleFonts.quicksand(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    // letterSpacing: -0.41.sp,
    height: 1.29.h,
  );

  /// Body text style
  static TextStyle body = GoogleFonts.quicksand(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    // // letterSpacing: -0.41,
    height: 1.29,
  );

  /// Callout text style
  static TextStyle callout = GoogleFonts.quicksand(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: -0.32,
    height: 1.31,
  );

  /// Subhead text style
  static TextStyle subhead = GoogleFonts.quicksand(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: -0.24,
    height: 1.33,
  );

  /// Footnote text style
  static TextStyle footnote = GoogleFonts.quicksand(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: -0.08,
    height: 1.38,
  );

  /// Caption 1 text style
  static TextStyle caption1 = GoogleFonts.quicksand(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.0,
    height: 1.33,
  );

  /// Caption 2 text style
  static TextStyle caption2 = GoogleFonts.quicksand(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.07,
    height: 1.36,
  );

  // MARK: - Specific Component Styles

  /// Menu bar text style
  static TextStyle menuBarText({Color color = Colors.white}) => headline
      .copyWith(color: color, fontSize: 14.sp, fontWeight: FontWeight.w600);

  /// Menu bar time text style
  static TextStyle menuBarTime({Color color = Colors.white}) => caption1
      .copyWith(color: color, fontSize: 14.sp, fontWeight: FontWeight.w500);

  /// App title text style
  static TextStyle appTitle({Color color = Colors.white}) => caption1.copyWith(
    color: color,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  /// Button text style
  static TextStyle buttonText({Color color = Colors.white}) =>
      callout.copyWith(color: color, fontWeight: FontWeight.w600);

  /// Popup title text style
  static TextStyle popupTitle({Color color = Colors.white}) =>
      title3.copyWith(color: color, fontWeight: FontWeight.w700);

  /// Popup body text style
  static TextStyle popupBody({Color color = Colors.white}) => body.copyWith(
    color: color.withValues(alpha: 0.8),
    fontSize: 14.sp,
    height: 1.4,
  );

  /// Menu item text style
  static TextStyle menuItem({Color color = Colors.white}) =>
      footnote.copyWith(color: color, fontWeight: FontWeight.w500);

  // MARK: - Color Palette (Apple-inspired)
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color amoled = Colors.black;
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemIndigo = Color(0xFF5856D6);
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemPink = Color(0xFFFF2D92);
  static const Color systemPurple = Color(0xFFAF52DE);
  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemTeal = Color(0xFF5AC8FA);
  static const Color systemYellow = Color(0xFFFFCC00);
  static const Color systemGray = Color(0xFF8E8E93);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSecondaryBackground = Color(0xFF1C1C1E);
  static const Color darkTertiaryBackground = Color(0xFF2C2C2E);

  // MARK: - Shadows and Effects
  static const List<BoxShadow> defaultShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10)),
  ];

  // MARK: - Glassmorphic Design
  /// Glassmorphic background color for dropdowns and popups
  static const Color glassmorphicBackground = Color(
    0x80000000,
  ); // 50% transparent black

  /// Glassmorphic border color
  static const Color glassmorphicBorder = Color(
    0x40FFFFFF,
  ); // 25% transparent white

  /// Glassmorphic shadow for elevated elements
  static const List<BoxShadow> glassmorphicShadow = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 48,
      offset: Offset(0, 32),
      spreadRadius: 0,
    ),
  ];

  /// Glassmorphic container decoration
  static BoxDecoration glassmorphicDecoration({
    double borderRadius = 12.0,
    Color? backgroundColor,
    Color? borderColor,
  }) => BoxDecoration(
    color: backgroundColor ?? glassmorphicBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: borderColor ?? glassmorphicBorder, width: 0.5),
    boxShadow: glassmorphicShadow,
  );

  /// Creates a glassmorphic container with blur effect
  static Widget glassmorphicContainer({
    required Widget child,
    double borderRadius = 12.0,
    Color? backgroundColor,
    Color? borderColor,
    double blurStrength = 10.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: glassmorphicDecoration(
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
          ),
          child: child,
        ),
      ),
    );
  }

  // MARK: - Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 20.0;
}
