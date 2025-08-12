import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingMessage = '';

  // Specific phrases as requested
  final List<String> _loadingMessages = [
    'Consulting the manuscripts of the Most High…',
    'Synchronizing with scrolls... please stand by 🌀',
    'Deciphering divine code with Hebrew precision…',
    'Booting ALTH.ai. Prepare your soul.',
    'Yes, we speak Greek. And Aramaic. And memes.',
  ];

  @override
  void initState() {
    super.initState();
    _selectRandomMessage();
    _initializeApp();
  }

  void _selectRandomMessage() {
    final random = Random();
    setState(() {
      _loadingMessage =
          _loadingMessages[random.nextInt(_loadingMessages.length)];
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style for dark theme
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF0D0D1A),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Wait for 2-3 seconds as requested
      await Future.delayed(const Duration(milliseconds: 2500));

      // Navigate to chapter selector
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/chapter-selector');
      }
    } catch (e) {
      // Handle initialization errors gracefully
      await Future.delayed(const Duration(milliseconds: 3000));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/chapter-selector');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Solid dark blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Static Bib7e logo/text
            Text(
              'Bib7e',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),

            SizedBox(height: 6.h),

            // Rotating phrase below logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                _loadingMessage,
                style: GoogleFonts.inter(
                  color: Colors.white.withAlpha(230),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
