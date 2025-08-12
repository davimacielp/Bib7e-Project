import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SearchFiltersWidget extends StatefulWidget {
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const SearchFiltersWidget({
    Key? key,
    required this.filters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  late Map<String, dynamic> _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = Map.from(widget.filters);
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _currentFilters[key] = value;
    });
    widget.onFiltersChanged(_currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Title
          Text(
            'Search Filters',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 3.h),

          // Testament Selection
          Text(
            'Testament',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  'Old Testament',
                  _currentFilters['testament'] == 'old',
                  () => _updateFilter('testament',
                      _currentFilters['testament'] == 'old' ? 'all' : 'old'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildFilterChip(
                  'New Testament',
                  _currentFilters['testament'] == 'new',
                  () => _updateFilter('testament',
                      _currentFilters['testament'] == 'new' ? 'all' : 'new'),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Language Preference
          Text(
            'Language Preference',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildFilterChip(
                'Original Text',
                _currentFilters['language'] == 'original',
                () => _updateFilter('language', 'original'),
              ),
              _buildFilterChip(
                'Translation',
                _currentFilters['language'] == 'translation',
                () => _updateFilter('language', 'translation'),
              ),
              _buildFilterChip(
                'Both',
                _currentFilters['language'] == 'both',
                () => _updateFilter('language', 'both'),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Search Mode
          Text(
            'Search Mode',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Column(
            children: [
              _buildRadioTile(
                'Keyword Search',
                'keyword',
                _currentFilters['searchMode'],
                (value) => _updateFilter('searchMode', value),
              ),
              _buildRadioTile(
                'Semantic Search',
                'semantic',
                _currentFilters['searchMode'],
                (value) => _updateFilter('searchMode', value),
              ),
              _buildRadioTile(
                'Exact Match',
                'exact',
                _currentFilters['searchMode'],
                (value) => _updateFilter('searchMode', value),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentFilters = {
                        'testament': 'all',
                        'language': 'both',
                        'searchMode': 'keyword',
                        'books': <String>[],
                      };
                    });
                    widget.onFiltersChanged(_currentFilters);
                  },
                  child: const Text('Reset'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, String value, String groupValue,
      Function(String) onChanged) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
