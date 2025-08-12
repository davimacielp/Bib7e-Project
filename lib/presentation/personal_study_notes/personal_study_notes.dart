import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/note_editor_widget.dart';
import './widgets/search_bar_widget.dart';

class PersonalStudyNotes extends StatefulWidget {
  const PersonalStudyNotes({Key? key}) : super(key: key);

  @override
  State<PersonalStudyNotes> createState() => _PersonalStudyNotesState();
}

class _PersonalStudyNotesState extends State<PersonalStudyNotes>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSelectionMode = false;
  Set<int> _selectedNotes = {};
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _filteredNotes = [];

  final List<String> _categories = [
    'All',
    'Personal Study',
    'Sermons',
    'Cross-References',
    'AI Insights',
    'Prayer Notes',
    'Devotional',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMockData();
    _filterNotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    _notes = [
      {
        "id": 1,
        "title": "God's Love and Sacrifice",
        "content":
            "This verse beautifully captures the essence of God's love for humanity. The word 'so' in Greek (houtos) emphasizes the manner and extent of God's love. It's not just that God loved, but how He loved - with such intensity and completeness that He gave His only Son.",
        "verseReference": "John 3:16",
        "category": "Personal Study",
        "tags": ["love", "salvation", "sacrifice"],
        "createdDate": DateTime.now().subtract(Duration(days: 2)),
        "modifiedDate": DateTime.now().subtract(Duration(days: 1)),
      },
      {
        "id": 2,
        "title": "All Things Work Together",
        "content":
            "Paul's assurance that all things work together for good is not a promise that everything that happens is good, but that God can work through all circumstances for the ultimate good of those who love Him. The Greek word 'synergeo' suggests a cooperative working together.",
        "verseReference": "Romans 8:28",
        "category": "Sermons",
        "tags": ["providence", "hope", "trust"],
        "createdDate": DateTime.now().subtract(Duration(days: 5)),
        "modifiedDate": DateTime.now().subtract(Duration(days: 3)),
      },
      {
        "id": 3,
        "title": "Faith Without Works",
        "content":
            "James emphasizes that genuine faith naturally produces good works. This doesn't contradict Paul's teaching on salvation by grace through faith, but rather shows that true faith is evidenced by its fruits. Dead faith is faith that produces no spiritual life or growth.",
        "verseReference": "James 2:26",
        "category": "Cross-References",
        "tags": ["faith", "works", "evidence"],
        "createdDate": DateTime.now().subtract(Duration(days: 7)),
        "modifiedDate": DateTime.now().subtract(Duration(days: 4)),
      },
      {
        "id": 4,
        "title": "AI Insight: Hebrew Poetry Structure",
        "content":
            "The AI assistant helped me understand the parallelism in this Psalm. The Hebrew poetry uses synonymous parallelism where the second line reinforces the first. 'The Lord is my shepherd' parallels with 'I shall not want' - showing that having God as our shepherd means we lack nothing essential.",
        "verseReference": "Psalm 23:1",
        "category": "AI Insights",
        "tags": ["poetry", "hebrew", "parallelism"],
        "createdDate": DateTime.now().subtract(Duration(days: 1)),
        "modifiedDate": DateTime.now().subtract(Duration(hours: 12)),
      },
      {
        "id": 5,
        "title": "Prayer for Wisdom",
        "content":
            "Lord, as I study Your word, grant me wisdom to understand not just the words but the heart behind them. Help me to apply these truths to my daily life and to share them with others in love. May my study time draw me closer to You.",
        "verseReference": "James 1:5",
        "category": "Prayer Notes",
        "tags": ["prayer", "wisdom", "understanding"],
        "createdDate": DateTime.now().subtract(Duration(hours: 6)),
        "modifiedDate": DateTime.now().subtract(Duration(hours: 2)),
      },
      {
        "id": 6,
        "title": "Morning Reflection",
        "content":
            "This morning I was reminded that God's mercies are new every day. No matter what happened yesterday, today is a fresh start with God's grace. The Hebrew word 'chesed' for mercy implies loyal love and faithfulness - God's character never changes.",
        "verseReference": "Lamentations 3:22-23",
        "category": "Devotional",
        "tags": ["mercy", "grace", "morning"],
        "createdDate": DateTime.now().subtract(Duration(hours: 3)),
        "modifiedDate": DateTime.now().subtract(Duration(hours: 1)),
      },
    ];
  }

  void _filterNotes() {
    setState(() {
      _filteredNotes = _notes.where((note) {
        final matchesCategory =
            _selectedCategory == 'All' || note['category'] == _selectedCategory;

        final matchesSearch = _searchQuery.isEmpty ||
            note['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            note['content']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            note['verseReference']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (note['tags'] as List).any((tag) => tag
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()));

        return matchesCategory && matchesSearch;
      }).toList();

      // Sort by modified date (most recent first)
      _filteredNotes.sort((a, b) => (b['modifiedDate'] as DateTime)
          .compareTo(a['modifiedDate'] as DateTime));
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterNotes();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterNotes();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedNotes.clear();
      }
    });
  }

  void _toggleNoteSelection(int noteId) {
    setState(() {
      if (_selectedNotes.contains(noteId)) {
        _selectedNotes.remove(noteId);
      } else {
        _selectedNotes.add(noteId);
      }

      if (_selectedNotes.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _deleteSelectedNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Notes'),
        content: Text(
            'Are you sure you want to delete ${_selectedNotes.length} note(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes
                    .removeWhere((note) => _selectedNotes.contains(note['id']));
                _selectedNotes.clear();
                _isSelectionMode = false;
              });
              _filterNotes();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notes deleted successfully')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _shareNote(Map<String, dynamic> note) {
    final content = '''
${note['verseReference']}

${note['title']}

${note['content']}

Tags: ${(note['tags'] as List).join(', ')}
Category: ${note['category']}
    ''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note content copied to clipboard')),
    );
  }

  void _editNote(Map<String, dynamic> note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteEditorWidget(
        existingNote: note,
        onSave: (updatedNote) {
          setState(() {
            final index =
                _notes.indexWhere((n) => n['id'] == updatedNote['id']);
            if (index != -1) {
              _notes[index] = updatedNote;
            }
          });
          _filterNotes();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note updated successfully')),
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _deleteNote(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeWhere((n) => n['id'] == note['id']);
              });
              _filterNotes();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Note deleted successfully')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _createNewNote() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteEditorWidget(
        onSave: (newNote) {
          setState(() {
            _notes.add(newNote);
          });
          _filterNotes();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note created successfully')),
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  int _getCategoryCount(String category) {
    if (category == 'All') return _notes.length;
    return _notes.where((note) => note['category'] == category).length;
  }

  Future<void> _refreshNotes() async {
    // Simulate network refresh
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // In a real app, this would sync with cloud storage
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notes synced successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Study Notes',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              onPressed:
                  _selectedNotes.isNotEmpty ? _deleteSelectedNotes : null,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: _selectedNotes.isNotEmpty
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.3),
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings-and-preferences');
              },
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
        ],
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _toggleSelectionMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'All Notes'),
                Tab(text: 'Bookmarks'),
                Tab(text: 'History'),
                Tab(text: 'AI Chats'),
              ],
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
              indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              labelColor: AppTheme.lightTheme.colorScheme.primary,
              unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Notes Tab
                _buildNotesTab(),

                // Bookmarks Tab
                _buildBookmarksTab(),

                // History Tab
                _buildHistoryTab(),

                // AI Chats Tab
                _buildAIChatTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: _createNewNote,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        // Search Bar
        SearchBarWidget(
          onSearchChanged: _onSearchChanged,
          onFilterTap: () {
            // Show filter options
          },
        ),

        // Category Chips
        Container(
          height: 6.h,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryChipWidget(
                category: category,
                isSelected: _selectedCategory == category,
                onTap: () => _onCategorySelected(category),
                count: _getCategoryCount(category),
              );
            },
          ),
        ),

        // Notes List
        Expanded(
          child: _filteredNotes.isEmpty
              ? EmptyStateWidget(
                  title: _searchQuery.isNotEmpty
                      ? 'No matching notes found'
                      : 'No study notes yet',
                  subtitle: _searchQuery.isNotEmpty
                      ? 'Try adjusting your search terms or browse different categories'
                      : 'Start your spiritual journey by creating your first study note. Capture insights, reflections, and revelations as you dive deeper into Scripture.',
                  buttonText: 'Create First Note',
                  onButtonPressed: _createNewNote,
                )
              : RefreshIndicator(
                  onRefresh: _refreshNotes,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];
                      final noteId = note['id'] as int;

                      return NoteCardWidget(
                        note: note,
                        isSelected: _selectedNotes.contains(noteId),
                        onTap: _isSelectionMode
                            ? () => _toggleNoteSelection(noteId)
                            : () {
                                // Navigate to note detail view
                              },
                        onLongPress: () {
                          if (!_isSelectionMode) {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedNotes.add(noteId);
                            });
                          }
                        },
                        onEdit: () => _editNote(note),
                        onShare: () => _shareNote(note),
                        onDelete: () => _deleteNote(note),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildBookmarksTab() {
    final bookmarkedNotes = _notes
        .where((note) => (note['tags'] as List).contains('bookmark'))
        .toList();

    return bookmarkedNotes.isEmpty
        ? EmptyStateWidget(
            title: 'No bookmarked verses',
            subtitle:
                'Bookmark meaningful verses while reading to access them quickly here.',
            buttonText: 'Browse Scripture',
            onButtonPressed: () {
              Navigator.pushNamed(context, '/bible-text-reader');
            },
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 10.h),
            itemCount: bookmarkedNotes.length,
            itemBuilder: (context, index) {
              final note = bookmarkedNotes[index];
              return NoteCardWidget(
                note: note,
                onTap: () {
                  // Navigate to verse in reader
                  Navigator.pushNamed(context, '/bible-text-reader');
                },
                onEdit: () => _editNote(note),
                onShare: () => _shareNote(note),
                onDelete: () => _deleteNote(note),
              );
            },
          );
  }

  Widget _buildHistoryTab() {
    final studySessions = [
      {
        'date': DateTime.now().subtract(Duration(hours: 2)),
        'duration': '45 minutes',
        'chapters': ['John 3', 'Romans 8'],
        'notesCreated': 2,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 1)),
        'duration': '30 minutes',
        'chapters': ['Psalm 23', 'Psalm 91'],
        'notesCreated': 1,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 2)),
        'duration': '60 minutes',
        'chapters': ['James 2', 'James 3'],
        'notesCreated': 3,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: studySessions.length,
      itemBuilder: (context, index) {
        final session = studySessions[index];
        final date = session['date'] as DateTime;

        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'history',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      session['duration'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Chapters: ${(session['chapters'] as List).join(', ')}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${session['notesCreated']} notes created',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIChatTab() {
    final aiChats =
        _notes.where((note) => note['category'] == 'AI Insights').toList();

    return aiChats.isEmpty
        ? EmptyStateWidget(
            title: 'No AI conversations yet',
            subtitle:
                'Start a conversation with the AI study assistant to get insights and explanations about Scripture.',
            buttonText: 'Open AI Assistant',
            onButtonPressed: () {
              Navigator.pushNamed(context, '/ai-study-assistant');
            },
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 10.h),
            itemCount: aiChats.length,
            itemBuilder: (context, index) {
              final chat = aiChats[index];
              return NoteCardWidget(
                note: chat,
                onTap: () {
                  Navigator.pushNamed(context, '/ai-study-assistant');
                },
                onEdit: () => _editNote(chat),
                onShare: () => _shareNote(chat),
                onDelete: () => _deleteNote(chat),
              );
            },
          );
  }
}
