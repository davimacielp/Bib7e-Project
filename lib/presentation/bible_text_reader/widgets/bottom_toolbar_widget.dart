import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomToolbarWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShare;
  final VoidCallback onAudioPlay;
  final VoidCallback onAIChat;
  final bool isPlaying;
  final Map<String, dynamic>? selectedVerse;

  const BottomToolbarWidget({
    Key? key,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onShare,
    required this.onAudioPlay,
    required this.onAIChat,
    required this.isPlaying,
    this.selectedVerse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToolbarButton(
              icon: isBookmarked ? 'bookmark' : 'bookmark_border',
              label: 'Bookmark',
              onTap: () {
                HapticFeedback.lightImpact();
                onBookmarkToggle();
              },
              isActive: isBookmarked,
            ),
            _buildToolbarButton(
              icon: 'share',
              label: 'Share',
              onTap: () {
                HapticFeedback.lightImpact();
                onShare();
              },
            ),
            _buildToolbarButton(
              icon: isPlaying ? 'pause' : 'play_arrow',
              label: 'Audio',
              onTap: () {
                HapticFeedback.lightImpact();
                onAudioPlay();
              },
              isActive: isPlaying,
            ),
            _buildToolbarButton(
              icon: 'chat',
              label: 'AI Study',
              onTap: () {
                HapticFeedback.lightImpact();
                onAIChat();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
