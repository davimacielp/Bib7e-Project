import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Widget? demoWidget;
  final bool showSkip;
  final VoidCallback? onSkip;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.demoWidget,
    this.showSkip = true,
    this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            showSkip ? _buildSkipButton() : SizedBox(height: 8.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),

                    // Main illustration
                    _buildMainIllustration(),

                    SizedBox(height: 6.h),

                    // Title
                    _buildTitle(),

                    SizedBox(height: 3.h),

                    // Description
                    _buildDescription(),

                    SizedBox(height: 4.h),

                    // Demo widget if provided
                    if (demoWidget != null) ...[
                      demoWidget!,
                      SizedBox(height: 4.h),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: Text(
              'Skip',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIllustration() {
    return Container(
      width: 70.w,
      height: 35.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomImageWidget(
          imageUrl: imagePath,
          width: 70.w,
          height: 35.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        height: 1.6,
      ),
    );
  }
}
