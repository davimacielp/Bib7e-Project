import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>?> loadChapterJson(String slug, int chapter) async {
  final candidates = [
    'assets/bible/$slug/$chapter.json',
    'assets/bible/$slug/$chapter.JSON',
  ];
  for (final path in candidates) {
    try {
      final s = await rootBundle.loadString(path);
      final json = jsonDecode(s) as Map<String, dynamic>;
      final verses = json['verses'];
      if (verses is List && verses.isNotEmpty) return json;
    } catch (_) {}
  }
  return null;
}
