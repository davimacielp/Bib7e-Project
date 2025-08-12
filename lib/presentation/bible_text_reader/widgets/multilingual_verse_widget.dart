import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MultilingualVerseWidget extends StatelessWidget {
  final Map<String, dynamic> verse;
  final bool isSelected;
  final VoidCallback onTap;
  final double textSize;

  const MultilingualVerseWidget({
    Key? key,
    required this.verse,
    required this.isSelected,
    required this.onTap,
    required this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int verseNumber = verse['verseNumber'] as int;
    final List<Map<String, String>> blocks =
        List<Map<String, String>>.from(verse['blocks'] ?? []);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 2,
                )
              : Border.all(
                  color:
                      AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Verse Number
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Verso $verseNumber',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Verse blocks
            ...blocks.asMap().entries.map((entry) {
              final index = entry.key;
              final block = entry.value;
              final isLastBlock = index == blocks.length - 1;

              return Column(
                children: [
                  _buildVerseBlock(block),
                  if (!isLastBlock) ...[
                    SizedBox(height: 2.h),
                    Container(
                      height: 1,
                      width: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.dividerColor
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(0.5),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseBlock(Map<String, String> block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 📘 Original Greek
        if (block['original'] != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '📘 ',
                style: TextStyle(fontSize: (textSize + 2).sp),
              ),
              Expanded(
                child: SelectableText(
                  block['original']!,
                  style: GoogleFonts.crimsonText(
                    fontSize: (textSize + 4).sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B82F6), // Blue
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
        ],

        // 📗 Transliterated
        if (block['transliteration'] != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '📗 ',
                style: TextStyle(fontSize: (textSize + 2).sp),
              ),
              Expanded(
                child: SelectableText(
                  block['transliteration']!,
                  style: GoogleFonts.inter(
                    fontSize: (textSize + 2).sp,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFFA78BFA), // Purple
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
        ],

        // 📙 Portuguese Translation
        if (block['translation'] != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '📙 ',
                style: TextStyle(fontSize: (textSize + 2).sp),
              ),
              Expanded(
                child: SelectableText(
                  block['translation']!,
                  style: GoogleFonts.inter(
                    fontSize: (textSize + 2).sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFFFBBF24), // Golden
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
