import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CrossReferencesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> crossReferences;
  final Function(Map<String, dynamic>) onReferenceTap;
  final Function(Map<String, dynamic>) onFavorite;

  const CrossReferencesWidget({
    Key? key,
    required this.crossReferences,
    required this.onReferenceTap,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (crossReferences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cross References',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          // Group references by type
          ..._buildGroupedReferences(),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedReferences() {
    final Map<String, List<Map<String, dynamic>>> groupedRefs = {};

    for (final ref in crossReferences) {
      final type = ref["connectionType"] as String;
      if (!groupedRefs.containsKey(type)) {
        groupedRefs[type] = [];
      }
      groupedRefs[type]!.add(ref);
    }

    final List<Widget> widgets = [];

    groupedRefs.forEach((type, refs) {
      widgets.add(_buildReferenceGroup(type, refs));
      widgets.add(SizedBox(height: 3.h));
    });

    return widgets;
  }

  Widget _buildReferenceGroup(
      String type, List<Map<String, dynamic>> references) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _getConnectionIcon(type),
            SizedBox(width: 2.w),
            Text(
              _getConnectionTitle(type),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ...references.map((ref) => _buildReferenceCard(ref)).toList(),
      ],
    );
  }

  Widget _buildReferenceCard(Map<String, dynamic> reference) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => onReferenceTap(reference),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${reference["book"]} ${reference["chapter"]}:${reference["verse"]}',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onFavorite(reference),
                      icon: CustomIconWidget(
                        iconName: reference["isFavorite"] == true
                            ? 'favorite'
                            : 'favorite_border',
                        color: reference["isFavorite"] == true
                            ? Colors.red
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                    ),
                  ],
                ),
                Text(
                  reference["text"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (reference["description"] != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    reference["description"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getConnectionIcon(String type) {
    String iconName;
    Color color = AppTheme.lightTheme.colorScheme.primary;

    switch (type) {
      case 'parallel':
        iconName = 'compare_arrows';
        break;
      case 'quotation':
        iconName = 'format_quote';
        break;
      case 'thematic':
        iconName = 'topic';
        break;
      case 'prophecy':
        iconName = 'auto_awesome';
        break;
      default:
        iconName = 'link';
    }

    return CustomIconWidget(
      iconName: iconName,
      color: color,
      size: 5.w,
    );
  }

  String _getConnectionTitle(String type) {
    switch (type) {
      case 'parallel':
        return 'Parallel Passages';
      case 'quotation':
        return 'Quotations & References';
      case 'thematic':
        return 'Thematic Connections';
      case 'prophecy':
        return 'Prophecy & Fulfillment';
      default:
        return 'Related Verses';
    }
  }
}
