import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/demo_ai_chat_widget.dart';
import './widgets/demo_offline_widget.dart';
import './widgets/demo_verse_widget.dart';
import './widgets/onboarding_button_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Study Original Languages",
      "description":
          "Explore Biblical texts in Hebrew, Aramaic, and Greek alongside modern translations for deeper understanding.",
      "image":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "buttonText": "Next",
      "showDemo": true,
      "demoType": "verse",
    },
    {
      "title": "AI-Powered Study Assistant",
      "description":
          "Get instant explanations of original language meanings, cultural context, and theological insights.",
      "image":
          "https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "buttonText": "Continue",
      "showDemo": true,
      "demoType": "ai",
    },
    {
      "title": "Study Anywhere, Anytime",
      "description":
          "Download chapters for offline study. Access your favorite verses and notes without internet connection.",
      "image":
          "https://images.pixabay.com/photo/2016/11/29/06/15/bible-1867195_1280.jpg",
      "buttonText": "Get Started",
      "showDemo": true,
      "demoType": "offline",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate setup process
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/chapter-selector');
    }
  }

  Widget _buildDemoWidget(String demoType) {
    switch (demoType) {
      case 'verse':
        return const DemoVerseWidget();
      case 'ai':
        return const DemoAiChatWidget();
      case 'offline':
        return const DemoOfflineWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                HapticFeedback.selectionClick();
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingPageWidget(
                  title: data["title"] as String,
                  description: data["description"] as String,
                  imagePath: data["image"] as String,
                  showSkip: index < _onboardingData.length - 1,
                  onSkip: _skipOnboarding,
                  demoWidget: (data["showDemo"] as bool)
                      ? _buildDemoWidget(data["demoType"] as String)
                      : null,
                );
              },
            ),
          ),

          // Bottom section with indicator and button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Page indicator
                PageIndicatorWidget(
                  currentPage: _currentPage,
                  totalPages: _onboardingData.length,
                ),

                SizedBox(height: 3.h),

                // Action button
                OnboardingButtonWidget(
                  text: _onboardingData[_currentPage]["buttonText"] as String,
                  onPressed: _nextPage,
                  isLoading:
                      _isLoading && _currentPage == _onboardingData.length - 1,
                ),

                // Additional info for final screen
                if (_currentPage == _onboardingData.length - 1) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
