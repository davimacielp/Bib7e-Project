import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final List<String>? verseReferences;
  final Function(String)? onVerseReferencePressed;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.onCopy,
    this.onShare,
    this.onSave,
    this.verseReferences,
    this.onVerseReferencePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 4.w,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: !isUser ? _showMessageOptions : null,
              child: Container(
                constraints: BoxConstraints(maxWidth: 75.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft:
                        isUser ? Radius.circular(4.w) : Radius.circular(1.w),
                    bottomRight:
                        isUser ? Radius.circular(1.w) : Radius.circular(4.w),
                  ),
                  border: !isUser
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(),
                    if (verseReferences != null &&
                        verseReferences!.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      _buildVerseReferences(),
                    ],
                    SizedBox(height: 0.5.h),
                    _buildTimestamp(),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    return SelectableText(
      message,
      style: TextStyle(
        color: isUser
            ? AppTheme.lightTheme.colorScheme.onPrimary
            : AppTheme.lightTheme.colorScheme.onSurface,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    );
  }

  Widget _buildVerseReferences() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: verseReferences!
          .map((reference) => GestureDetector(
                onTap: () => onVerseReferencePressed?.call(reference),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    reference,
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTimestamp() {
    final timeString =
        "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";

    return Text(
      timeString,
      style: TextStyle(
        color: isUser
            ? AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7)
            : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  void _showMessageOptions() {
    // This would typically show a bottom sheet with options
    // For now, we'll trigger the callbacks directly
    if (onCopy != null) {
      Clipboard.setData(ClipboardData(text: message));
    }
  }
}
