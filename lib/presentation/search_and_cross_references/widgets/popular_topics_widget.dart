import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PopularTopicsWidget extends StatelessWidget {
  final Function(String) onTopicTap;

  const PopularTopicsWidget({
    Key? key,
    required this.onTopicTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> popularTopics = [
      {
        "title": "Love",
        "icon": "favorite",
        "description": "Verses about God's love and loving others",
        "verseCount": 312,
      },
      {
        "title": "Faith",
        "icon": "church",
        "description": "Building and strengthening faith",
        "verseCount": 245,
      },
      {
        "title": "Hope",
        "icon": "wb_sunny",
        "description": "Finding hope in difficult times",
        "verseCount": 189,
      },
      {
        "title": "Prayer",
        "icon": "hands",
        "description": "The power and practice of prayer",
        "verseCount": 167,
      },
      {
        "title": "Wisdom",
        "icon": "psychology",
        "description": "Seeking divine wisdom and understanding",
        "verseCount": 203,
      },
      {
        "title": "Peace",
        "icon": "spa",
        "description": "Finding peace through God",
        "verseCount": 156,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Study Topics',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: popularTopics.length,
            itemBuilder: (context, index) {
              final topic = popularTopics[index];
              return _buildTopicCard(topic);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onTopicTap(topic["title"] as String),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWidget(
                    iconName: topic["icon"] as String,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${topic["verseCount"]}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                topic["title"] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: Text(
                  topic["description"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
