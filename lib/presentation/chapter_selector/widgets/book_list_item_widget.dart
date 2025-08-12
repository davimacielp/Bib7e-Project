import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookListItemWidget extends StatelessWidget {
  final Map<String, dynamic> book;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final Function(int) onChapterTap;
  final Function(Map<String, dynamic>) onLongPress;

  const BookListItemWidget({
    Key? key,
    required this.book,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.onChapterTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggleExpansion,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          book['originalName'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${book['chapterCount']} chapters',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (book['isDownloaded'] == true)
                        Container(
                          margin: EdgeInsets.only(right: 2.w),
                          child: CustomIconWidget(
                            iconName: 'offline_pin',
                            color: AppTheme.successLight,
                            size: 20,
                          ),
                        ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: AppTheme.textSecondaryLight,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) _buildChapterGrid(),
        ],
      ),
    );
  }

  Widget _buildChapterGrid() {
    final chapterCount = book['chapterCount'] as int;
    final chapters = List.generate(chapterCount, (index) => index + 1);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.2,
        ),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapterNumber = chapters[index];
          final isDownloaded = (book['downloadedChapters'] as List<int>?)
                  ?.contains(chapterNumber) ??
              false;

          return GestureDetector(
            onTap: () => onChapterTap(chapterNumber),
            onLongPress: () => onLongPress({
              'bookName': book['name'],
              'chapterNumber': chapterNumber,
              'isDownloaded': isDownloaded,
            }),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      chapterNumber.toString(),
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isDownloaded)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: CustomIconWidget(
                        iconName: 'download_done',
                        color: AppTheme.successLight,
                        size: 12,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
