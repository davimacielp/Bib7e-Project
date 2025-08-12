import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> chapterData;
  final VoidCallback onDownload;
  final VoidCallback onAddToFavorites;
  final VoidCallback onShare;
  final VoidCallback onClose;

  const ContextMenuWidget({
    Key? key,
    required this.chapterData,
    required this.onDownload,
    required this.onAddToFavorites,
    required this.onShare,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${chapterData['bookName']} ${chapterData['chapterNumber']}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            _buildMenuItem(
              icon: chapterData['isDownloaded'] == true
                  ? 'download_done'
                  : 'download',
              title: chapterData['isDownloaded'] == true
                  ? 'Downloaded'
                  : 'Download for Offline',
              onTap: chapterData['isDownloaded'] == true ? null : onDownload,
              isDisabled: chapterData['isDownloaded'] == true,
            ),
            _buildMenuItem(
              icon: 'favorite_border',
              title: 'Add to Favorites',
              onTap: onAddToFavorites,
            ),
            _buildMenuItem(
              icon: 'share',
              title: 'Share Chapter',
              onTap: onShare,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.dividerLight.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDisabled
                  ? AppTheme.textDisabledLight
                  : AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isDisabled
                      ? AppTheme.textDisabledLight
                      : AppTheme.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
