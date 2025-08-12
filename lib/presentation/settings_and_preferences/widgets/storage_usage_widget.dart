import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StorageUsageWidget extends StatelessWidget {
  final double usedStorage;
  final double totalStorage;
  final List<Map<String, dynamic>> storageBreakdown;

  const StorageUsageWidget({
    Key? key,
    required this.usedStorage,
    required this.totalStorage,
    required this.storageBreakdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usagePercentage = (usedStorage / totalStorage).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Storage Usage',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${(usedStorage / 1024 / 1024).toStringAsFixed(1)} MB / ${(totalStorage / 1024 / 1024).toStringAsFixed(0)} MB',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.dividerLight,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: usagePercentage,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: usagePercentage > 0.8
                      ? AppTheme.warningLight
                      : AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ...storageBreakdown.map((item) {
            final itemPercentage =
                ((item['size'] as double) / totalStorage).clamp(0.0, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      item['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${((item['size'] as double) / 1024 / 1024).toStringAsFixed(1)} MB',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showClearCacheDialog(context);
              },
              child: const Text('Clear Cache'),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear temporary files and cached content. Downloaded Bible texts will not be affected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
