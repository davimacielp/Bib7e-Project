import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({Key? key}) : super(key: key);

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  @override
  Widget build(BuildContext context) {
    // Get book data from route arguments
    final Map<String, dynamic> book =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String bookName = book['name'] as String;
    final String bookId = book['id'] as String;
    final int chapterCount = book['chapterCount'] as int;
    final String transliteration = book['transliteration'] as String;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFD4AF37), // Gold
            size: 20,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookName,
              style: GoogleFonts.crimsonText(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFF5F5DC), // Cream
              ),
            ),
            Text(
              transliteration,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF8B7355), // Muted brown
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chapter count info
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(6.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1B2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFB8860B).withAlpha(51),
                  width: 1,
                ),
              ),
              child: Text(
                'Select a chapter to begin reading • $chapterCount chapters',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF8B7355),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Chapter grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: chapterCount,
                  itemBuilder: (context, index) {
                    final chapterNumber = index + 1;
                    return GestureDetector(
                      onTap: () => _navigateToReader(bookId, chapterNumber),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1B2E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF8B4513).withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            chapterNumber.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: const Color(0xFFF5F5DC),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToReader(String bookId, int chapterNumber) {
    // Map book IDs to appropriate book slugs for asset paths
    String bookSlug = _getBookSlug(bookId);

    Navigator.pushNamed(
      context,
      '/bible-text-reader',
      arguments: {
        'book_slug': bookSlug,
        'chapter': chapterNumber,
      },
    );
  }

  String _getBookSlug(String bookId) {
    // Map book IDs to the appropriate slugs for asset paths
    // For now, specifically handle John -> joao mapping as per requirements
    switch (bookId) {
      case 'john':
        return 'joao';
      case 'genesis':
        return 'genesis';
      case 'exodus':
        return 'exodus';
      case 'matthew':
        return 'mateus';
      case 'mark':
        return 'marcos';
      case 'luke':
        return 'lucas';
      // Add more mappings as needed when more assets are available
      default:
        return bookId; // Use the book ID as default if no specific mapping exists
    }
  }
}
