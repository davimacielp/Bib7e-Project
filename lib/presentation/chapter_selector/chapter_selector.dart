import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/openai_client.dart';
import '../../services/openai_service.dart';
import '../../routes/app_routes.dart';

class ChapterSelector extends StatefulWidget {
  const ChapterSelector({Key? key}) : super(key: key);

  @override
  State<ChapterSelector> createState() => _ChapterSelectorState();
}

class _ChapterSelectorState extends State<ChapterSelector>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  bool _isAiLoading = false;

  // OpenAI integration
  late OpenAIService _openAIService;
  late OpenAIClient _openAIClient;

  // Animation controller for blinking cursor
  late AnimationController _cursorAnimationController;
  late Animation<double> _cursorAnimation;

  // Bible books data with abbreviations and transliterations
  final List<Map<String, dynamic>> _bibleBooks = [
// Old Testament
    {
      "id": "genesis",
      "name": "Genesis",
      "transliteration": "Bereshit",
      "abbreviation": "Gn",
      "chapterCount": 50,
    },
    {
      "id": "exodus",
      "name": "Exodus",
      "transliteration": "Shemot",
      "abbreviation": "Ex",
      "chapterCount": 40,
    },
    {
      "id": "leviticus",
      "name": "Leviticus",
      "transliteration": "Vayikra",
      "abbreviation": "Lv",
      "chapterCount": 27,
    },
    {
      "id": "numbers",
      "name": "Numbers",
      "transliteration": "Bemidbar",
      "abbreviation": "Nm",
      "chapterCount": 36,
    },
    {
      "id": "deuteronomy",
      "name": "Deuteronomy",
      "transliteration": "Devarim",
      "abbreviation": "Dt",
      "chapterCount": 34,
    },
    {
      "id": "joshua",
      "name": "Joshua",
      "transliteration": "Yehoshua",
      "abbreviation": "Jos",
      "chapterCount": 24,
    },
    {
      "id": "judges",
      "name": "Judges",
      "transliteration": "Shoftim",
      "abbreviation": "Jdg",
      "chapterCount": 21,
    },
    {
      "id": "ruth",
      "name": "Ruth",
      "transliteration": "Ruth",
      "abbreviation": "Rt",
      "chapterCount": 4,
    },
    {
      "id": "1samuel",
      "name": "1 Samuel",
      "transliteration": "Shmuel Aleph",
      "abbreviation": "1Sm",
      "chapterCount": 31,
    },
    {
      "id": "2samuel",
      "name": "2 Samuel",
      "transliteration": "Shmuel Bet",
      "abbreviation": "2Sm",
      "chapterCount": 24,
    },
    {
      "id": "1kings",
      "name": "1 Kings",
      "transliteration": "Melachim Aleph",
      "abbreviation": "1Kgs",
      "chapterCount": 22,
    },
    {
      "id": "2kings",
      "name": "2 Kings",
      "transliteration": "Melachim Bet",
      "abbreviation": "2Kgs",
      "chapterCount": 25,
    },
    {
      "id": "1chronicles",
      "name": "1 Chronicles",
      "transliteration": "Divrei Hayamim Aleph",
      "abbreviation": "1Chr",
      "chapterCount": 29,
    },
    {
      "id": "2chronicles",
      "name": "2 Chronicles",
      "transliteration": "Divrei Hayamim Bet",
      "abbreviation": "2Chr",
      "chapterCount": 36,
    },
    {
      "id": "ezra",
      "name": "Ezra",
      "transliteration": "Ezra",
      "abbreviation": "Ezr",
      "chapterCount": 10,
    },
    {
      "id": "nehemiah",
      "name": "Nehemiah",
      "transliteration": "Nehemiah",
      "abbreviation": "Neh",
      "chapterCount": 13,
    },
    {
      "id": "esther",
      "name": "Esther",
      "transliteration": "Esther",
      "abbreviation": "Est",
      "chapterCount": 10,
    },
    {
      "id": "job",
      "name": "Job",
      "transliteration": "Iyov",
      "abbreviation": "Jb",
      "chapterCount": 42,
    },
    {
      "id": "psalms",
      "name": "Psalms",
      "transliteration": "Tehillim",
      "abbreviation": "Ps",
      "chapterCount": 150,
    },
    {
      "id": "proverbs",
      "name": "Proverbs",
      "transliteration": "Mishlei",
      "abbreviation": "Prv",
      "chapterCount": 31,
    },
    {
      "id": "ecclesiastes",
      "name": "Ecclesiastes",
      "transliteration": "Kohelet",
      "abbreviation": "Ecc",
      "chapterCount": 12,
    },
    {
      "id": "song",
      "name": "Song of Songs",
      "transliteration": "Shir HaShirim",
      "abbreviation": "Sg",
      "chapterCount": 8,
    },
    {
      "id": "isaiah",
      "name": "Isaiah",
      "transliteration": "Yeshayahu",
      "abbreviation": "Is",
      "chapterCount": 66,
    },
    {
      "id": "jeremiah",
      "name": "Jeremiah",
      "transliteration": "Yirmeyahu",
      "abbreviation": "Jer",
      "chapterCount": 52,
    },
    {
      "id": "lamentations",
      "name": "Lamentations",
      "transliteration": "Eichah",
      "abbreviation": "Lam",
      "chapterCount": 5,
    },
    {
      "id": "ezekiel",
      "name": "Ezekiel",
      "transliteration": "Yechezkel",
      "abbreviation": "Ez",
      "chapterCount": 48,
    },
    {
      "id": "daniel",
      "name": "Daniel",
      "transliteration": "Daniel",
      "abbreviation": "Dn",
      "chapterCount": 12,
    },
    {
      "id": "hosea",
      "name": "Hosea",
      "transliteration": "Hoshea",
      "abbreviation": "Hos",
      "chapterCount": 14,
    },
    {
      "id": "joel",
      "name": "Joel",
      "transliteration": "Yoel",
      "abbreviation": "Jl",
      "chapterCount": 3,
    },
    {
      "id": "amos",
      "name": "Amos",
      "transliteration": "Amos",
      "abbreviation": "Am",
      "chapterCount": 9,
    },
    {
      "id": "obadiah",
      "name": "Obadiah",
      "transliteration": "Ovadiah",
      "abbreviation": "Ob",
      "chapterCount": 1,
    },
    {
      "id": "jonah",
      "name": "Jonah",
      "transliteration": "Yonah",
      "abbreviation": "Jon",
      "chapterCount": 4,
    },
    {
      "id": "micah",
      "name": "Micah",
      "transliteration": "Michah",
      "abbreviation": "Mi",
      "chapterCount": 7,
    },
    {
      "id": "nahum",
      "name": "Nahum",
      "transliteration": "Nahum",
      "abbreviation": "Na",
      "chapterCount": 3,
    },
    {
      "id": "habakkuk",
      "name": "Habakkuk",
      "transliteration": "Habakkuk",
      "abbreviation": "Hab",
      "chapterCount": 3,
    },
    {
      "id": "zephaniah",
      "name": "Zephaniah",
      "transliteration": "Tzfanyah",
      "abbreviation": "Zep",
      "chapterCount": 3,
    },
    {
      "id": "haggai",
      "name": "Haggai",
      "transliteration": "Haggai",
      "abbreviation": "Hg",
      "chapterCount": 2,
    },
    {
      "id": "zechariah",
      "name": "Zechariah",
      "transliteration": "Zecharyah",
      "abbreviation": "Zec",
      "chapterCount": 14,
    },
    {
      "id": "malachi",
      "name": "Malachi",
      "transliteration": "Malachi",
      "abbreviation": "Mal",
      "chapterCount": 4,
    },
// New Testament
    {
      "id": "matthew",
      "name": "Matthew",
      "transliteration": "Matthaion",
      "abbreviation": "Mt",
      "chapterCount": 28,
    },
    {
      "id": "mark",
      "name": "Mark",
      "transliteration": "Markon",
      "abbreviation": "Mk",
      "chapterCount": 16,
    },
    {
      "id": "luke",
      "name": "Luke",
      "transliteration": "Loukan",
      "abbreviation": "Lk",
      "chapterCount": 24,
    },
    {
      "id": "john",
      "name": "John",
      "transliteration": "Ioannen",
      "abbreviation": "Jn",
      "chapterCount": 21,
    },
    {
      "id": "acts",
      "name": "Acts",
      "transliteration": "Praxeis Apostolon",
      "abbreviation": "Acts",
      "chapterCount": 28,
    },
    {
      "id": "romans",
      "name": "Romans",
      "transliteration": "Pros Romaious",
      "abbreviation": "Rom",
      "chapterCount": 16,
    },
    {
      "id": "1corinthians",
      "name": "1 Corinthians",
      "transliteration": "Pros Korinthious A",
      "abbreviation": "1Cor",
      "chapterCount": 16,
    },
    {
      "id": "2corinthians",
      "name": "2 Corinthians",
      "transliteration": "Pros Korinthious B",
      "abbreviation": "2Cor",
      "chapterCount": 13,
    },
    {
      "id": "galatians",
      "name": "Galatians",
      "transliteration": "Pros Galatas",
      "abbreviation": "Gal",
      "chapterCount": 6,
    },
    {
      "id": "ephesians",
      "name": "Ephesians",
      "transliteration": "Pros Ephesious",
      "abbreviation": "Eph",
      "chapterCount": 6,
    },
    {
      "id": "philippians",
      "name": "Philippians",
      "transliteration": "Pros Philippesious",
      "abbreviation": "Phil",
      "chapterCount": 4,
    },
    {
      "id": "colossians",
      "name": "Colossians",
      "transliteration": "Pros Kolossaeis",
      "abbreviation": "Col",
      "chapterCount": 4,
    },
    {
      "id": "1thessalonians",
      "name": "1 Thessalonians",
      "transliteration": "Pros Thessalonikeis A",
      "abbreviation": "1Th",
      "chapterCount": 5,
    },
    {
      "id": "2thessalonians",
      "name": "2 Thessalonians",
      "transliteration": "Pros Thessalonikeis B",
      "abbreviation": "2Th",
      "chapterCount": 3,
    },
    {
      "id": "1timothy",
      "name": "1 Timothy",
      "transliteration": "Pros Timotheon A",
      "abbreviation": "1Tm",
      "chapterCount": 6,
    },
    {
      "id": "2timothy",
      "name": "2 Timothy",
      "transliteration": "Pros Timotheon B",
      "abbreviation": "2Tm",
      "chapterCount": 4,
    },
    {
      "id": "titus",
      "name": "Titus",
      "transliteration": "Pros Titon",
      "abbreviation": "Ti",
      "chapterCount": 3,
    },
    {
      "id": "philemon",
      "name": "Philemon",
      "transliteration": "Pros Philemona",
      "abbreviation": "Phlm",
      "chapterCount": 1,
    },
    {
      "id": "hebrews",
      "name": "Hebrews",
      "transliteration": "Pros Ebraious",
      "abbreviation": "Heb",
      "chapterCount": 13,
    },
    {
      "id": "james",
      "name": "James",
      "transliteration": "Iakobou",
      "abbreviation": "Jas",
      "chapterCount": 5,
    },
    {
      "id": "1peter",
      "name": "1 Peter",
      "transliteration": "Petrou A",
      "abbreviation": "1Pt",
      "chapterCount": 5,
    },
    {
      "id": "2peter",
      "name": "2 Peter",
      "transliteration": "Petrou B",
      "abbreviation": "2Pt",
      "chapterCount": 3,
    },
    {
      "id": "1john",
      "name": "1 John",
      "transliteration": "Ioannou A",
      "abbreviation": "1Jn",
      "chapterCount": 5,
    },
    {
      "id": "2john",
      "name": "2 John",
      "transliteration": "Ioannou B",
      "abbreviation": "2Jn",
      "chapterCount": 1,
    },
    {
      "id": "3john",
      "name": "3 John",
      "transliteration": "Ioannou C",
      "abbreviation": "3Jn",
      "chapterCount": 1,
    },
    {
      "id": "jude",
      "name": "Jude",
      "transliteration": "Iouda",
      "abbreviation": "Jude",
      "chapterCount": 1,
    },
    {
      "id": "revelation",
      "name": "Revelation",
      "transliteration": "Apokalypsis Ioannou",
      "abbreviation": "Rev",
      "chapterCount": 22,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize OpenAI service
    try {
      _openAIService = OpenAIService();
      _openAIClient = OpenAIClient(_openAIService.dio);
    } catch (e) {
      print('OpenAI service initialization failed: $e');
    }

    // Initialize cursor animation
    _cursorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cursorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_cursorAnimationController);
    _cursorAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _cursorAnimationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredBooks {
    if (_searchQuery.isEmpty) return _bibleBooks;

    return _bibleBooks.where((book) {
      final bookName = (book['name'] as String).toLowerCase();
      final abbreviation = (book['abbreviation'] as String).toLowerCase();
      final transliteration = (book['transliteration'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return bookName.contains(query) ||
          abbreviation.contains(query) ||
          transliteration.contains(query);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _onBookTap(Map<String, dynamic> book) {
    Navigator.pushNamed(
      context,
      '/chapter-list',
      arguments: book,
    );
  }

  // AI Chat handling
  Future<void> _handleAiMessage(String message) async {
    setState(() {
      _isAiLoading = true;
    });

    try {
      final contextualPrompt = '''
You are ALTH.ai, a knowledgeable Bible study assistant. The user has asked: "$message"

Provide a helpful, educational response about the Bible. If about a specific verse or passage, provide:
1. The meaning and context
2. Historical background if relevant  
3. Cross-references to related passages
4. Practical application

Keep your response informative but concise.
''';

      final messages = [
        Message(role: 'system', content: contextualPrompt),
        Message(role: 'user', content: message),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.7, 'max_tokens': 500},
      );

      Navigator.pushNamed(
        context,
        '/ai-study-assistant',
        arguments: {
          'initialMessage': message,
          'initialResponse': response.text,
        },
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "AI service unavailable. Please check your internet connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isAiLoading = false;
      });
    }
  }

  void _navigateToTools() {
    Navigator.pushNamed(context, '/bib7e-tools');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Dark blue background
      body: SafeArea(
        child: Column(
          children: [
            // Updated logo section with increased size
            Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 3.h),
              child: Center(
                child: Image.asset(
                  'assets/images/ChatGPT_Image_7_de_ago._de_2025_16_13_26-1754594895540.png',
                  height:
                      140, // Increased from 110 to 140 for better visibility
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Redesigned ALTH.ai terminal block with enhanced interactive appearance
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.aiStudyAssistant);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A14)
                      .withAlpha(204), // Deep translucent navy background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFD4AF37)
                        .withAlpha(204), // Gold border with opacity
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withAlpha(30),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Terminal header - removed traffic light buttons
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF333333),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'ALTH.ai Terminal',
                            style: GoogleFonts.courierPrime(
                              fontSize: 12,
                              color: const Color(0xFF888888),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Terminal content with command prompt
                    Row(
                      children: [
                        Text(
                          '\$ initialize_spiritual_query.exe',
                          style: GoogleFonts.courierPrime(
                            fontSize: 14,
                            color: const Color(0xFFD4AF37), // Gold text color
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                        // Blinking cursor with better visibility
                        AnimatedBuilder(
                          animation: _cursorAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _cursorAnimation.value > 0.5 ? 1.0 : 0.0,
                              child: Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Text(
                                  '|',
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 14,
                                    color:
                                        const Color(0xFFD4AF37), // Gold cursor
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Interactive prompt message
                    Text(
                      '> What do you want to explore today?',
                      style: GoogleFonts.courierPrime(
                        fontSize: 13,
                        color: const Color(0xFFCCCCCC),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Text(
                      '> Ask ALTH.ai about any verse or concept',
                      style: GoogleFonts.courierPrime(
                        fontSize: 11,
                        color: const Color(0xFF888888),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1B2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B4513).withAlpha(51),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF5F5DC),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search books, abbreviations, or names...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF8B7355),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFD4AF37),
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: _clearSearch,
                            icon: const Icon(
                              Icons.clear,
                              color: Color(0xFF8B7355),
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                ),
              ),
            ),

            // Books list
            Expanded(
              child: _filteredBooks.isEmpty && _searchQuery.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: const Color(0xFF8B7355),
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No books found',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: const Color(0xFFF5F5DC),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Try searching with different keywords',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF8B7355),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          child: ListTile(
                            onTap: () => _onBookTap(book),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.5.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tileColor: const Color(0xFF1A1B2E),
                            title: Text(
                              book['name'] as String,
                              style: GoogleFonts.crimsonText(
                                fontSize: 18,
                                color: const Color(0xFFF5F5DC),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              '${book['transliteration']} • ${book['chapterCount']} chapters',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF8B7355),
                              ),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB8860B).withAlpha(26),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFFB8860B).withAlpha(77),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                book['abbreviation'] as String,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: const Color(0xFFD4AF37),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Refactored Bib7e Tools button with golden accent
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(6.w),
              child: ElevatedButton(
                onPressed: _navigateToTools,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFD4AF37), // Golden accent color
                  foregroundColor:
                      const Color(0xFF0D0D1A), // Dark text for contrast
                  padding:
                      EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 6.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                  ),
                  elevation: 2,
                  shadowColor: const Color(0xFFD4AF37).withAlpha(77),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.build_outlined, // Subtle tools icon
                      size: 20,
                      color: const Color(0xFF0D0D1A),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Bib7e Tools',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: const Color(0xFF0D0D1A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
