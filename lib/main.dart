import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/firebase_options.dart';
import 'screens/homepage/homepage.dart';
import 'config/app_design.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Portfolio());
}

class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppleTheme(),
      home: const HomePage(),
      routes: {'/home': (context) => const HomePage()},
    );
  }

  ThemeData _buildAppleTheme() {
    return ThemeData(
      textTheme: TextTheme(
        displayLarge: AppDesign.largeTitle,
        displayMedium: AppDesign.title1,
        displaySmall: AppDesign.title2,
        headlineLarge: AppDesign.title3,
        headlineMedium: AppDesign.headline,
        headlineSmall: AppDesign.headline,
        titleLarge: AppDesign.headline,
        titleMedium: AppDesign.body,
        titleSmall: AppDesign.callout,
        bodyLarge: AppDesign.body,
        bodyMedium: AppDesign.callout,
        bodySmall: AppDesign.subhead,
        labelLarge: AppDesign.headline,
        labelMedium: AppDesign.footnote,
        labelSmall: AppDesign.caption2,
      ),

      // Use Cupertino color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppDesign.systemBlue,
        brightness: Brightness.dark,
      ),

      // Apple-style visual properties
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
