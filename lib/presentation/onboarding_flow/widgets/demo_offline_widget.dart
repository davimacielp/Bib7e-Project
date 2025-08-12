import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DemoOfflineWidget extends StatefulWidget {
  const DemoOfflineWidget({Key? key}) : super(key: key);

  @override
  State<DemoOfflineWidget> createState() => _DemoOfflineWidgetState();
}

class _DemoOfflineWidgetState extends State<DemoOfflineWidget> {
  bool _isOfflineMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Offline toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: _isOfflineMode ? 'cloud_off' : 'cloud_done',
                    color: _isOfflineMode
                        ? AppTheme.warningLight
                        : AppTheme.successLight,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    _isOfflineMode ? 'Offline Mode' : 'Online Mode',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: _isOfflineMode
                          ? AppTheme.warningLight
                          : AppTheme.successLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isOfflineMode,
                onChanged: (value) {
                  setState(() {
                    _isOfflineMode = value;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Status indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _isOfflineMode
                  ? AppTheme.warningLight.withValues(alpha: 0.1)
                  : AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOfflineMode
                      ? 'Downloaded Content Available'
                      : 'All Features Available',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: _isOfflineMode
                        ? AppTheme.warningLight
                        : AppTheme.successLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _isOfflineMode
                      ? 'Access your downloaded books and chapters without internet connection.'
                      : 'Full access to all books, AI assistance, and cloud synchronization.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Downloaded books indicator
          Row(
            children: [
              CustomIconWidget(
                iconName: 'download_done',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Genesis, Exodus, Matthew, John',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
