import 'package:flutter/material.dart';
import '../presentation/ai_study_assistant/ai_study_assistant.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/bible_text_reader/bible_text_reader.dart';
import '../presentation/settings_and_preferences/settings_and_preferences.dart';
import '../presentation/personal_study_notes/personal_study_notes.dart';
import '../presentation/chapter_selector/chapter_selector.dart';
import '../presentation/search_and_cross_references/search_and_cross_references.dart';
import '../presentation/chapter_list/chapter_list_screen.dart';
import '../presentation/bib7e_tools/bib7e_tools_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String aiStudyAssistant = '/ai-study-assistant';
  static const String splash = '/splash-screen';
  static const String bibleTextReader = '/bible-text-reader';
  static const String settingsAndPreferences = '/settings-and-preferences';
  static const String personalStudyNotes = '/personal-study-notes';
  static const String chapterSelector = '/chapter-selector';
  static const String searchAndCrossReferences = '/search-and-cross-references';
  static const String chapterList = '/chapter-list';
  static const String bib7eTools = '/bib7e-tools';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    aiStudyAssistant: (context) => const AiStudyAssistant(),
    splash: (context) => const SplashScreen(),
    bibleTextReader: (context) => const BibleTextReader(),
    settingsAndPreferences: (context) => const SettingsAndPreferences(),
    personalStudyNotes: (context) => const PersonalStudyNotes(),
    chapterSelector: (context) => const ChapterSelector(),
    searchAndCrossReferences: (context) => const SearchAndCrossReferences(),
    chapterList: (context) => const ChapterListScreen(),
    bib7eTools: (context) => const Bib7eToolsScreen(),
    // TODO: Add your other routes here
  };
}
