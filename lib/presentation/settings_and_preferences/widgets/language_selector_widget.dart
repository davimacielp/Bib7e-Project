import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelectorWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  final List<Map<String, String>> _languages = [
    {
      'code': 'hebrew',
      'name': 'Hebrew (עברית)',
      'sample': 'בְּרֵאשִׁית בָּרָא אֱלֹהִים'
    },
    {
      'code': 'greek',
      'name': 'Greek (Ελληνικά)',
      'sample': 'Ἐν ἀρχῇ ἦν ὁ λόγος'
    },
    {
      'code': 'aramaic',
      'name': 'Aramaic (ארמית)',
      'sample': 'בְּרֵישִׁית בְּרָא אֱלָהָא'
    },
  ];

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Original Language Font',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: SizedBox(
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _languages.map((language) {
                final isSelected = language['code'] == widget.selectedLanguage;
                return ListTile(
                  title: Text(
                    language['name']!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    language['sample']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: language['code'] == 'hebrew' ||
                              language['code'] == 'aramaic'
                          ? 'Noto Sans Hebrew'
                          : 'Noto Serif',
                    ),
                    textDirection: language['code'] == 'hebrew' ||
                            language['code'] == 'aramaic'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  leading: Radio<String>(
                    value: language['code']!,
                    groupValue: widget.selectedLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        widget.onLanguageChanged(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  selected: isSelected,
                  onTap: () {
                    widget.onLanguageChanged(language['code']!);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLang = _languages.firstWhere(
      (lang) => lang['code'] == widget.selectedLanguage,
      orElse: () => _languages.first,
    );

    return InkWell(
      onTap: _showLanguageDialog,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Original Language Font',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    selectedLang['name']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    selectedLang['sample']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: widget.selectedLanguage == 'hebrew' ||
                              widget.selectedLanguage == 'aramaic'
                          ? 'Noto Sans Hebrew'
                          : 'Noto Serif',
                      color: AppTheme.textSecondaryLight,
                    ),
                    textDirection: widget.selectedLanguage == 'hebrew' ||
                            widget.selectedLanguage == 'aramaic'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.textSecondaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
