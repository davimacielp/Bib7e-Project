import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:scripture_study/services/local_chapter_loader.dart';
import 'package:scripture_study/i18n/books.dart';

const DEBUG_HUD =
    bool.fromEnvironment('BIB7E_DEBUG', defaultValue: false) || false;

const FORCE_MOCK = false; // desativado por padrão

final titleFont = GoogleFonts.merriweather(); // fallback interno do package
final bodyFont = GoogleFonts.inter();
final originalFont = GoogleFonts.notoSerif();

class BibleTextReader extends StatefulWidget {
  const BibleTextReader({Key? key}) : super(key: key);

  @override
  State<BibleTextReader> createState() => _BibleTextReaderState();
}

class _BibleTextReaderState extends State<BibleTextReader> {
  late ChapterLoaderResult _loaderResult;
  String _bookSlug = 'joao';
  int _chapter = 1;

  @override
  void initState() {
    super.initState();
    _loaderResult =
        useChapterLoader(_bookSlug, _chapter, forceMock: FORCE_MOCK);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final newBookSlug = args['book_slug'] as String? ?? 'joao';
      final newChapter = args['chapter'] as int? ?? 1;

      if (newBookSlug != _bookSlug || newChapter != _chapter) {
        setState(() {
          _bookSlug = newBookSlug;
          _chapter = newChapter;
          _loaderResult =
              useChapterLoader(_bookSlug, _chapter, forceMock: FORCE_MOCK);
        });
      }
    }
  }

  void _navigateToChapter(int newChapter) {
    if (newChapter >= 1) {
      Navigator.pushReplacementNamed(
        context,
        '/bible-text-reader',
        arguments: {
          'book_slug': _bookSlug,
          'chapter': newChapter,
        },
      );
    }
  }

  void _retry() {
    setState(() {
      _loaderResult =
          useChapterLoader(_bookSlug, _chapter, forceMock: FORCE_MOCK);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${mapSlugToName(_bookSlug, "pt")} Capítulo $_chapter',
          style: GoogleFonts.merriweather(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _loaderResult.state.data != null
          ? ReaderFooter(
              currentChapter: _chapter,
              totalVerses: (_loaderResult.state.data!['verses'] as List).length,
              onPrevious:
                  _chapter > 1 ? () => _navigateToChapter(_chapter - 1) : null,
              onNext: () => _navigateToChapter(_chapter + 1),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_loaderResult.state.loading) {
      return _buildLoadingState();
    }

    if (_loaderResult.state.error) {
      return _buildErrorState();
    }

    if (_loaderResult.state.data == null) {
      return _buildErrorState();
    }

    return Column(
      children: [
        if (DEBUG_HUD && _loaderResult.state.data != null) _buildDebugHUD(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            children: (_loaderResult.state.data!['verses'] as List)
                .map<Widget>((v) => VerseCard(
                      n: v['n'],
                      original: v['original'],
                      translit: v['translit'],
                      pt: v['pt'],
                      rtl_original:
                          _loaderResult.state.data!['rtl_original'] == true,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugHUD() {
    final verseCount = (_loaderResult.state.data!['verses'] as List).length;
    final source = FORCE_MOCK ? "MOCK" : "JSON local";
    final targetPath = "/assets/bible/$_bookSlug/$_chapter.json";

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DEBUG HUD",
            style: GoogleFonts.inter(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Fonte: $source",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          Text(
            "Versos: $verseCount",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          Text(
            "Path alvo: $targetPath",
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
              3,
              (index) => Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1B2E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(51),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            height: 14,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: Colors.purple.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            height: 14,
                            width: 75.w,
                            decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withAlpha(51),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.withAlpha(204),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Capítulo não encontrado',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Este capítulo ainda não está disponível.',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tentar novamente',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerseCard extends StatelessWidget {
  final int n;
  final String original;
  final String translit;
  final String pt;
  final bool rtl_original;

  const VerseCard({
    Key? key,
    required this.n,
    required this.original,
    required this.translit,
    required this.pt,
    this.rtl_original = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121a2b),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verse number badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1d2742),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Verso $n',
              style: GoogleFonts.inter(
                color: const Color(0xFF93C5FD),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Original line (blue)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(top: 12, right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  original,
                  textDirection:
                      rtl_original ? TextDirection.rtl : TextDirection.ltr,
                  style: GoogleFonts.notoSerif(
                    color: const Color(0xFF93C5FD),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Transliteration line (violet, italic)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(top: 12, right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFA78BFA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  translit,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Portuguese line (amber)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(top: 12, right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCD34D),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  pt,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFCD34D),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReaderFooter extends StatelessWidget {
  final int currentChapter;
  final int totalVerses;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ReaderFooter({
    Key? key,
    required this.currentChapter,
    required this.totalVerses,
    this.onPrevious,
    this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        border: Border(
          top: BorderSide(
            color: Colors.white.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: onPrevious,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Prev'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onPrevious != null
                          ? const Color(0xFF3B82F6)
                          : Colors.grey.withAlpha(77),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Text(
                    '$totalVerses of N',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.bookmark_border, 'Bookmark', () {}),
                  _buildActionButton(Icons.share, 'Share', () {}),
                  _buildActionButton(Icons.volume_up, 'Audio', () {}),
                  _buildActionButton(Icons.auto_awesome, 'AI Study', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white60,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

