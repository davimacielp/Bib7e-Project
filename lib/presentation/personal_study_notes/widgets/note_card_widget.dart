import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteCardWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final bool isSelected;
  final VoidCallback? onLongPress;

  const NoteCardWidget({
    Key? key,
    required this.note,
    this.onTap,
    this.onEdit,
    this.onShare,
    this.onDelete,
    this.isSelected = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = note['title'] ?? 'Untitled Note';
    final String verseReference = note['verseReference'] ?? '';
    final String preview = note['content'] ?? '';
    final DateTime createdDate = note['createdDate'] ?? DateTime.now();
    final List<String> tags = (note['tags'] as List?)?.cast<String>() ?? [];
    final String category = note['category'] ?? 'Personal Study';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with verse reference and date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        verseReference,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${createdDate.day}/${createdDate.month}/${createdDate.year}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                // Note title
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),

                // Note preview
                Text(
                  preview,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),

                // Category and tags
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (tags.isNotEmpty) ...[
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Wrap(
                          spacing: 1.w,
                          children: tags
                              .take(2)
                              .map((tag) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.5.w, vertical: 0.3.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '#$tag',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                ),

                // Action buttons (shown when not in selection mode)
                if (!isSelected) ...[
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8.w,
                          minHeight: 4.h,
                        ),
                      ),
                      IconButton(
                        onPressed: onShare,
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8.w,
                          minHeight: 4.h,
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 18,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8.w,
                          minHeight: 4.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
