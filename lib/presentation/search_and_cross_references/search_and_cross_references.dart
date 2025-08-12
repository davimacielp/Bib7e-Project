import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cross_references_widget.dart';
import './widgets/popular_topics_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_filters_widget.dart';
import './widgets/search_results_widget.dart';

class SearchAndCrossReferences extends StatefulWidget {
  const SearchAndCrossReferences({Key? key}) : super(key: key);

  @override
  State<SearchAndCrossReferences> createState() =>
      _SearchAndCrossReferencesState();
}

class _SearchAndCrossReferencesState extends State<SearchAndCrossReferences>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  bool _isSearching = false;
  String _currentQuery = '';
  List<String> _recentSearches = [
    'love one another',
    'faith without works',
    'peace be with you',
    'forgiveness',
  ];

  Map<String, dynamic> _searchFilters = {
    'testament': 'all',
    'language': 'both',
    'searchMode': 'keyword',
    'books': <String>[],
  };

  // Mock search results data
  final List<Map<String, dynamic>> _mockSearchResults = [
    {
      "id": 1,
      "book": "John",
      "chapter": 13,
      "verse": 34,
      "text":
          "A new command I give you: Love one another. As I have loved you, so you must love one another.",
      "originalText": "ἐντολὴν καινὴν δίδωμι ὑμῖν, ἵνα ἀγαπᾶτε ἀλλήλους",
      "relevance": 0.95,
      "isFavorite": false,
    },
    {
      "id": 2,
      "book": "1 Corinthians",
      "chapter": 13,
      "verse": 4,
      "text":
          "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.",
      "originalText": "ἡ ἀγάπη μακροθυμεῖ, χρηστεύεται ἡ ἀγάπη",
      "relevance": 0.92,
      "isFavorite": true,
    },
    {
      "id": 3,
      "book": "Romans",
      "chapter": 8,
      "verse": 28,
      "text":
          "And we know that in all things God works for the good of those who love him, who have been called according to his purpose.",
      "originalText":
          "οἴδαμεν δὲ ὅτι τοῖς ἀγαπῶσιν τὸν θεὸν πάντα συνεργεῖ εἰς ἀγαθόν",
      "relevance": 0.88,
      "isFavorite": false,
    },
  ];

  // Mock cross references data
  final List<Map<String, dynamic>> _mockCrossReferences = [
    {
      "id": 1,
      "book": "1 John",
      "chapter": 4,
      "verse": 7,
      "text":
          "Dear friends, let us love one another, for love comes from God. Everyone who loves has been born of God and knows God.",
      "connectionType": "thematic",
      "description": "Thematic connection about loving one another",
      "isFavorite": false,
    },
    {
      "id": 2,
      "book": "Matthew",
      "chapter": 22,
      "verse": 39,
      "text": "And the second is like it: 'Love your neighbor as yourself.'",
      "connectionType": "parallel",
      "description": "Parallel teaching about love",
      "isFavorite": true,
    },
    {
      "id": 3,
      "book": "Galatians",
      "chapter": 5,
      "verse": 14,
      "text":
          "For the entire law is fulfilled in keeping this one command: 'Love your neighbor as yourself.'",
      "connectionType": "quotation",
      "description": "References the same commandment",
      "isFavorite": false,
    },
  ];

  List<Map<String, dynamic>> _filteredResults = [];
  List<Map<String, dynamic>> _filteredCrossReferences = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query != _currentQuery) {
      setState(() {
        _currentQuery = query;
        if (query.isNotEmpty) {
          _performSearch(query);
        } else {
          _filteredResults.clear();
          _filteredCrossReferences.clear();
        }
      });
    }
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _filteredResults = _mockSearchResults
              .where((result) => (result["text"] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();

          _filteredCrossReferences = _mockCrossReferences
              .where((ref) => (ref["text"] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        });

        // Add to recent searches if not already present
        if (query.isNotEmpty && !_recentSearches.contains(query)) {
          setState(() {
            _recentSearches.insert(0, query);
            if (_recentSearches.length > 10) {
              _recentSearches.removeLast();
            }
          });
        }
      }
    });
  }

  void _onVoiceSearch() {
    // Voice search implementation would go here
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchFiltersWidget(
        filters: _searchFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _searchFilters = filters;
          });
          // Re-perform search with new filters
          if (_currentQuery.isNotEmpty) {
            _performSearch(_currentQuery);
          }
        },
      ),
    );
  }

  void _onResultTap(Map<String, dynamic> result) {
    Navigator.pushNamed(
      context,
      '/bible-text-reader',
      arguments: {
        'book': result['book'],
        'chapter': result['chapter'],
        'verse': result['verse'],
        'highlightTerm': _currentQuery,
      },
    );
  }

  void _onFavorite(Map<String, dynamic> item) {
    setState(() {
      item['isFavorite'] = !(item['isFavorite'] ?? false);
    });

    final message = item['isFavorite'] == true
        ? 'Added to favorites'
        : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onShare(Map<String, dynamic> result) {
    final text =
        '${result["book"]} ${result["chapter"]}:${result["verse"]}\n\n"${result["text"]}"';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Sharing: ${result["book"]} ${result["chapter"]}:${result["verse"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  void _onRecentSearchRemove(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _onTopicTap(String topic) {
    _searchController.text = topic;
    _performSearch(topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Search & Cross-References',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-preferences'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 6.w,
            ),
          ),
        ],
        bottom: _currentQuery.isNotEmpty
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Search Results'),
                  Tab(text: 'Cross References'),
                ],
              )
            : null,
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) {}, // Handled by listener
            onSubmitted: _performSearch,
            onVoiceSearch: _onVoiceSearch,
            onFilterTap: _showFilters,
            isLoading: _isSearching,
          ),

          // Content
          Expanded(
            child: _currentQuery.isEmpty
                ? _buildEmptySearchState()
                : _buildSearchResultsState(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Recent Searches
          RecentSearchesWidget(
            recentSearches: _recentSearches,
            onSearchTap: _onRecentSearchTap,
            onSearchRemove: _onRecentSearchRemove,
          ),

          SizedBox(height: 4.h),

          // Popular Topics
          PopularTopicsWidget(
            onTopicTap: _onTopicTap,
          ),

          SizedBox(height: 4.h),

          // Search Tips
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Search Tips',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildTipItem(
                    'Use quotes for exact phrases: "love one another"'),
                _buildTipItem('Search original text with transliteration'),
                _buildTipItem('Use filters to narrow down results'),
                _buildTipItem('Try semantic search for related concepts'),
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsState() {
    return TabBarView(
      controller: _tabController,
      children: [
        // Search Results Tab
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              SearchResultsWidget(
                searchResults: _filteredResults,
                searchQuery: _currentQuery,
                onResultTap: _onResultTap,
                onFavorite: _onFavorite,
                onShare: _onShare,
                isLoading: _isSearching,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),

        // Cross References Tab
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              CrossReferencesWidget(
                crossReferences: _filteredCrossReferences,
                onReferenceTap: _onResultTap,
                onFavorite: _onFavorite,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ],
    );
  }
}
