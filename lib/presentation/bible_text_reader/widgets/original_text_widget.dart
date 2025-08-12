import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OriginalTextWidget extends StatelessWidget {
  final Map<String, dynamic> verse;
  final bool isSelected;
  final VoidCallback onTap;
  final double textSize;

  const OriginalTextWidget({
    Key? key,
    required this.verse,
    required this.isSelected,
    required this.onTap,
    required this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String originalText = verse['originalText'] as String;
    final String language = verse['language'] as String;
    final int verseNumber = verse['verseNumber'] as int;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: language == 'Hebrew' || language == 'Aramaic'
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: language == 'Hebrew' || language == 'Aramaic'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    verseNumber.toString(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Directionality(
              textDirection: language == 'Hebrew' || language == 'Aramaic'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: SelectableText(
                originalText,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontSize: textSize.sp,
                  height: 1.8,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: language == 'Hebrew' || language == 'Aramaic'
                    ? TextAlign.right
                    : TextAlign.left,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              language,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
