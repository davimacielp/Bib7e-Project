import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiChatWidget extends StatefulWidget {
  final Function(String) onMessageSent;
  final bool isLoading;

  const AiChatWidget({
    Key? key,
    required this.onMessageSent,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty && !widget.isLoading) {
      widget.onMessageSent(message);
      _controller.clear();
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.w),
                topRight: Radius.circular(3.w),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Study Assistant',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ask questions about Scripture',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _toggleExpanded,
                  icon: CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Input area
          if (_isExpanded)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Quick suggestions
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: [
                      'Explain passage',
                      'Historical context',
                      'Cross-references',
                      'Original language',
                    ]
                        .map((suggestion) => GestureDetector(
                              onTap: () => widget.onMessageSent(suggestion),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(5.w),
                                  border: Border.all(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  suggestion,
                                  style: TextStyle(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 2.h),

                  // Text input
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            minLines: 1,
                            enabled: !widget.isLoading,
                            decoration: InputDecoration(
                              hintText: 'Ask about Scripture...',
                              hintStyle: TextStyle(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(4.w),
                            ),
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontSize: 14.sp,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(1.w),
                          child: widget.isLoading
                              ? Container(
                                  width: 12.w,
                                  height: 12.w,
                                  padding: EdgeInsets.all(3.w),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: _sendMessage,
                                  icon: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'send',
                                      color: Colors.white,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
