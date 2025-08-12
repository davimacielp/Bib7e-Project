import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Bib7eToolsScreen extends StatelessWidget {
  const Bib7eToolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Bib7e Tools',
          style: GoogleFonts.crimsonText(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFF5F5DC), // Cream
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              // Header text
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                margin: EdgeInsets.only(bottom: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1B2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFB8860B).withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Enhance your scripture study with these sacred tools designed for contemplative learning',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF8B7355),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Tools list
              Expanded(
                child: ListView(
                  children: [
                    _buildToolTile(
                      context: context,
                      icon: Icons.note_add_outlined,
                      title: 'Personal Notes',
                      description: 'Create and organize your study notes',
                      onTap: () =>
                          Navigator.pushNamed(context, '/personal-study-notes'),
                    ),
                    _buildToolTile(
                      context: context,
                      icon: Icons.auto_stories_outlined,
                      title: 'Daily Devotionals',
                      description: 'Guided readings for spiritual growth',
                      onTap: () =>
                          _showComingSoon(context, 'Daily Devotionals'),
                    ),
                    _buildToolTile(
                      context: context,
                      icon: Icons.search,
                      title: 'Cross References',
                      description: 'Explore connections between passages',
                      onTap: () => Navigator.pushNamed(
                          context, '/search-and-cross-references'),
                    ),
                    _buildToolTile(
                      context: context,
                      icon: Icons.file_download_outlined,
                      title: 'Export Options',
                      description: 'Save your notes and highlights',
                      onTap: () => _showComingSoon(context, 'Export Options'),
                    ),
                    _buildToolTile(
                      context: context,
                      icon: Icons.psychology_outlined,
                      title: 'AI Study Assistant',
                      description: 'Get insights from ALTH.ai',
                      onTap: () =>
                          Navigator.pushNamed(context, '/ai-study-assistant'),
                    ),
                    _buildToolTile(
                      context: context,
                      icon: Icons.settings_outlined,
                      title: 'Preferences',
                      description: 'Customize your study experience',
                      onTap: () => Navigator.pushNamed(
                          context, '/settings-and-preferences'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFF1A1B2E),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFB8860B).withAlpha(26),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFB8860B).withAlpha(77),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFD4AF37), // Gold
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.crimsonText(
            fontSize: 18,
            color: const Color(0xFFF5F5DC), // Cream
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF8B7355), // Muted brown
              height: 1.4,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF8B7355),
          size: 16,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Coming Soon',
          style: GoogleFonts.crimsonText(
            fontSize: 20,
            color: const Color(0xFFF5F5DC),
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          '$feature will be available in a future update. Thank you for your patience!',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF8B7355),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
