import 'dart:convert';
import 'package:flutter/services.dart';

// Mock data for immediate display
const Map<String, dynamic> MOCK_JOAO_1 = {
  'book_slug': 'joao',
  'chapter': 1,
  'rtl_original': false,
  'verses': [
    {
      'n': 1,
      'original': 'Ἐν ἀρχῇ ἦν ὁ Λόγος',
      'translit': 'En archē ēn ho Lógos',
      'pt': 'No princípio era o Logos'
    },
    {
      'n': 2,
      'original': 'οὗτος ἦν ἐν ἀρχῇ πρὸς τὸν Θεόν',
      'translit': 'houtos ēn en archē pros ton Theón',
      'pt': 'Ele estava no princípio com Deus'
    },
    {
      'n': 3,
      'original': "πάντα δι' αὐτοῦ ἐγένετο",
      'translit': "panta di' autou egeneto",
      'pt': 'Todas as coisas foram feitas por meio dele'
    },
    {
      'n': 4,
      'original': 'ἐν αὐτῷ ζωὴ ἦν',
      'translit': 'en autō zōē ēn',
      'pt': 'Nele estava a vida'
    },
    {
      'n': 5,
      'original': 'καὶ ἡ σκοτία αὐτὸ οὐ κατέλαβεν',
      'translit': 'kai hē skotia auto ou katelaben',
      'pt': 'e as trevas não a venceram'
    }
  ]
};

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
  final void Function() retry;
  final String bookSlug;
  final int chapter;

  ChapterLoaderResult({
    required this.state,
    required this.retry,
    required this.bookSlug,
    required this.chapter,
  });
}

Future<String?> _safeFetchMulti(String bookSlug, int chapter) async {
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

ChapterLoaderResult useChapterLoader(String bookSlugParam, int chapterParam,
    {bool forceMock = false}) {
  final bookSlug = (bookSlugParam.isNotEmpty) ? bookSlugParam : 'joao';
  final chapterNum = chapterParam > 0 ? chapterParam : 1;

  final state = ChapterLoaderState();

  Future<void> load() async {
    if (forceMock) {
      state.loading = false;
      state.error = false;
      state.data = MOCK_JOAO_1;
      return;
    }

    state.loading = true;
    state.error = false;
    state.data = null;

    final jsonString = await _safeFetchMulti(bookSlug, chapterNum);
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

    if (bookSlug == 'joao' && chapterNum == 1) {
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

