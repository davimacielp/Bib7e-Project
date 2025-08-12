import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';

// Typography constants
const TITLE_FONT =
    "'Merriweather','Noto Serif','Georgia','Times New Roman',serif";
const BODY_FONT =
    "'Inter','SF Pro Text','Roboto','Segoe UI',system-ui,sans-serif";
const ORIGINAL_FONT =
    "'Noto Serif','Merriweather','Georgia','Times New Roman',serif";

// Mock data for immediate display
const Map<String, dynamic> MOCK_JOAO_1 = {
  "book_slug": "joao",
  "chapter": 1,
  "rtl_original": false,
  "verses": [
    {
      "n": 1,
      "original": "Ἐν ἀρχῇ ἦν ὁ Λόγος",
      "translit": "En archē ēn ho Lógos",
      "pt": "No princípio era o Logos"
    },
    {
      "n": 2,
      "original": "οὗτος ἦν ἐν ἀρχῇ πρὸς τὸν Θεόν",
      "translit": "houtos ēn en archē pros ton Theón",
      "pt": "Ele estava no princípio com Deus"
    },
    {
      "n": 3,
      "original": "πάντα δι' αὐτοῦ ἐγένετο",
      "translit": "panta di' autou egeneto",
      "pt": "Todas as coisas foram feitas por meio dele"
    },
    {
      "n": 4,
      "original": "ἐν αὐτῷ ζωὴ ἦν",
      "translit": "en autō zōē ēn",
      "pt": "Nele estava a vida"
    },
    {
      "n": 5,
      "original": "καὶ ἡ σκοτία αὐτὸ οὐ κατέλαβεν",
      "translit": "kai hē skotia auto ou katelaben",
      "pt": "e as trevas não a venceram"
    }
  ]
};

const FORCE_MOCK = true;
const DEBUG_HUD = true;

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
    _loaderResult = useChapterLoader(_bookSlug, _chapter);
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
          _loaderResult = useChapterLoader(_bookSlug, _chapter);
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
      _loaderResult = useChapterLoader(_bookSlug, _chapter);
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

class ChapterLoaderState {
  bool loading;
  bool error;
  Map<String, dynamic>? data;

  ChapterLoaderState({
    this.loading = true,
    this.error = false,
    this.data,
  });
}

class ChapterLoaderResult {
  final ChapterLoaderState state;
  final Function() retry;
  final String bookSlug;
  final int chapter;

  ChapterLoaderResult({
    required this.state,
    required this.retry,
    required this.bookSlug,
    required this.chapter,
  });
}

Future<String?> safeFetchMulti(String bookSlug, int chapter) async {
  final candidates = [
    '/assets/bible/$bookSlug/$chapter.json',
    './assets/bible/$bookSlug/$chapter.json',
    'assets/bible/$bookSlug/$chapter.json'
  ];

  for (final candidate in candidates) {
    try {
      final jsonString = await rootBundle.loadString(candidate);
      if (jsonString.isNotEmpty) return jsonString;
    } catch (_) {}
  }
  return null;
}

ChapterLoaderResult useChapterLoader(String bookSlugParam, int chapterParam) {
  final bookSlug = (bookSlugParam.isNotEmpty) ? bookSlugParam : "joao";
  final chapterNum = chapterParam > 0 ? chapterParam : 1;

  final state = ChapterLoaderState();

  Future<void> load() async {
    if (FORCE_MOCK) {
      state.loading = false;
      state.error = false;
      state.data = MOCK_JOAO_1;
      return;
    }

    state.loading = true;
    state.error = false;
    state.data = null;

    final jsonString = await safeFetchMulti(bookSlug, chapterNum);
    Map<String, dynamic>? json;
    try {
      json = jsonString != null ? jsonDecode(jsonString) : null;
    } catch (_) {
      json = null;
    }

    if (json != null &&
        json['verses'] != null &&
        json['verses'] is List &&
        (json['verses'] as List).isNotEmpty) {
      state.data = json;
      state.loading = false;
      state.error = false;
      return;
    }

    if (bookSlug == "joao" && chapterNum == 1) {
      state.data = MOCK_JOAO_1;
      state.loading = false;
      state.error = false;
      return;
    }

    state.loading = false;
    state.error = true;
    state.data = null;
  }

  void retry() {
    load();
  }

  load();

  return ChapterLoaderResult(
    state: state,
    retry: retry,
    bookSlug: bookSlug,
    chapter: chapterNum,
  );
}

const List<String> BOOKS_CANON = [
  "genesis",
  "exodo",
  "levitico",
  "numeros",
  "deuteronomio",
  "josue",
  "juizes",
  "rute",
  "1samuel",
  "2samuel",
  "1reis",
  "2reis",
  "1cronicas",
  "2cronicas",
  "esdras",
  "neemias",
  "ester",
  "jo",
  "salmos",
  "proverbios",
  "eclesiastes",
  "cantares",
  "isaias",
  "jeremias",
  "lamentacoes",
  "ezequiel",
  "daniel",
  "oseias",
  "joel",
  "amos",
  "obadias",
  "jonas",
  "miqueias",
  "naum",
  "habacuque",
  "sofonias",
  "ageu",
  "zacarias",
  "malaquias",
  "mateus",
  "marcos",
  "lucas",
  "joao",
  "atos",
  "romanos",
  "1corintios",
  "2corintios",
  "galatas",
  "efesios",
  "filipenses",
  "colossenses",
  "1tessalonicenses",
  "2tessalonicenses",
  "1timoteo",
  "2timoteo",
  "tito",
  "filemom",
  "hebreus",
  "tiago",
  "1pedro",
  "2pedro",
  "1joao",
  "2joao",
  "3joao",
  "judas",
  "apocalipse"
];

const Map<String, String> NAMES_PT = {
  "genesis": "Gênesis",
  "exodo": "Êxodo",
  "levitico": "Levítico",
  "numeros": "Números",
  "deuteronomio": "Deuteronômio",
  "josue": "Josué",
  "juizes": "Juízes",
  "rute": "Rute",
  "1samuel": "1 Samuel",
  "2samuel": "2 Samuel",
  "1reis": "1 Reis",
  "2reis": "2 Reis",
  "1cronicas": "1 Crônicas",
  "2cronicas": "2 Crônicas",
  "esdras": "Esdras",
  "neemias": "Neemias",
  "ester": "Ester",
  "jo": "Jó",
  "salmos": "Salmos",
  "proverbios": "Provérbios",
  "eclesiastes": "Eclesiastes",
  "cantares": "Cânticos",
  "isaias": "Isaías",
  "jeremias": "Jeremias",
  "lamentacoes": "Lamentações",
  "ezequiel": "Ezequiel",
  "daniel": "Daniel",
  "oseias": "Oséias",
  "joel": "Joel",
  "amos": "Amós",
  "obadias": "Obadias",
  "jonas": "Jonas",
  "miqueias": "Miquéias",
  "naum": "Naum",
  "habacuque": "Habacuque",
  "sofonias": "Sofonias",
  "ageu": "Ageu",
  "zacarias": "Zacarias",
  "malaquias": "Malaquias",
  "mateus": "Mateus",
  "marcos": "Marcos",
  "lucas": "Lucas",
  "joao": "João",
  "atos": "Atos",
  "romanos": "Romanos",
  "1corintios": "1 Coríntios",
  "2corintios": "2 Coríntios",
  "galatas": "Gálatas",
  "efesios": "Efésios",
  "filipenses": "Filipenses",
  "colossenses": "Colossenses",
  "1tessalonicenses": "1 Tessalonicenses",
  "2tessalonicenses": "2 Tessalonicenses",
  "1timoteo": "1 Timóteo",
  "2timoteo": "2 Timóteo",
  "tito": "Tito",
  "filemom": "Filemom",
  "hebreus": "Hebreus",
  "tiago": "Tiago",
  "1pedro": "1 Pedro",
  "2pedro": "2 Pedro",
  "1joao": "1 João",
  "2joao": "2 João",
  "3joao": "3 João",
  "judas": "Judas",
  "apocalipse": "Apocalipse"
};

const Map<String, String> NAMES_EN = {
  "genesis": "Genesis",
  "exodo": "Exodus",
  "levitico": "Leviticus",
  "numeros": "Numbers",
  "deuteronomio": "Deuteronomy",
  "josue": "Joshua",
  "juizes": "Judges",
  "rute": "Ruth",
  "1samuel": "1 Samuel",
  "2samuel": "2 Samuel",
  "1reis": "1 Kings",
  "2reis": "2 Kings",
  "1cronicas": "1 Chronicles",
  "2cronicas": "2 Chronicles",
  "esdras": "Ezra",
  "neemias": "Nehemiah",
  "ester": "Esther",
  "jo": "Job",
  "salmos": "Psalms",
  "proverbios": "Proverbs",
  "eclesiastes": "Ecclesiastes",
  "cantares": "Song of Songs",
  "isaias": "Isaiah",
  "jeremias": "Jeremiah",
  "lamentacoes": "Lamentations",
  "ezequiel": "Ezekiel",
  "daniel": "Daniel",
  "oseias": "Hosea",
  "joel": "Joel",
  "amos": "Amos",
  "obadias": "Obadiah",
  "jonas": "Jonah",
  "miqueias": "Micah",
  "naum": "Nahum",
  "habacuque": "Habakkuk",
  "sofonias": "Zephaniah",
  "ageu": "Haggai",
  "zacarias": "Zechariah",
  "malaquias": "Malachi",
  "mateus": "Matthew",
  "marcos": "Mark",
  "lucas": "Luke",
  "joao": "John",
  "atos": "Acts",
  "romanos": "Romans",
  "1corintios": "1 Corinthians",
  "2corintios": "2 Corinthians",
  "galatas": "Galatians",
  "efesios": "Ephesians",
  "filipenses": "Philippians",
  "colossenses": "Colossians",
  "1tessalonicenses": "1 Thessalonians",
  "2tessalonicenses": "2 Thessalonians",
  "1timoteo": "1 Timothy",
  "2timoteo": "2 Timothy",
  "tito": "Titus",
  "filemom": "Philemon",
  "hebreus": "Hebrews",
  "tiago": "James",
  "1pedro": "1 Peter",
  "2pedro": "2 Peter",
  "1joao": "1 John",
  "2joao": "2 John",
  "3joao": "3 John",
  "judas": "Jude",
  "apocalipse": "Revelation"
};

String mapSlugToName(String slug, [String lang = "pt"]) {
  final s = (slug).toLowerCase();
  const dictionaries = {"pt": NAMES_PT, "en": NAMES_EN};
  final dict = dictionaries[lang] ?? NAMES_PT;

  final fromDict = dict[s];
  if (fromDict != null) return fromDict;

  if (lang != "pt" && NAMES_PT[s] != null) return NAMES_PT[s]!;

  return s
      .replaceAllMapped(RegExp(r'(\d)([a-z])'),
          (match) => '${match.group(1)} ${match.group(2)}')
      .replaceAll('-', ' ')
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1)}'
          : word)
      .join(' ');
}
