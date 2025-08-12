import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/font_size_slider_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/storage_usage_widget.dart';

class SettingsAndPreferences extends StatefulWidget {
  const SettingsAndPreferences({Key? key}) : super(key: key);

  @override
  State<SettingsAndPreferences> createState() => _SettingsAndPreferencesState();
}

class _SettingsAndPreferencesState extends State<SettingsAndPreferences> {
  // Settings state variables
  double _fontSize = 16.0;
  String _selectedLanguage = 'hebrew';
  String _selectedTranslation = 'ESV';
  bool _rtlTextEnabled = true;
  bool _aiAssistantEnabled = true;
  bool _crossReferencesEnabled = true;
  bool _autoSyncEnabled = true;
  bool _analyticsEnabled = false;
  bool _highContrastMode = false;
  bool _reducedMotion = false;
  double _playbackSpeed = 1.0;
  String _selectedVoice = 'default';

  // Mock data for storage usage
  final List<Map<String, dynamic>> _storageBreakdown = [
    {
      'name': 'Bible Texts',
      'size': 45.6 *
          1024 *
          1024, // 45.6 MB 'color': AppTheme.lightTheme.colorScheme.primary,
    },
    {
      'name': 'Audio Files',
      'size': 23.2 * 1024 * 1024, // 23.2 MB 'color': AppTheme.secondaryLight,
    },
    {
      'name': 'Study Notes',
      'size': 8.4 * 1024 * 1024, // 8.4 MB 'color': AppTheme.successLight,
    },
    {
      'name': 'Cache',
      'size': 12.1 * 1024 * 1024, // 12.1 MB 'color': AppTheme.warningLight,
    },
  ];

  final List<String> _translations = [
    'ESV',
    'NIV',
    'NASB',
    'KJV',
    'NKJV',
    'CSB',
    'NLT',
    'MSG'
  ];

  final List<String> _voices = [
    'default',
    'male_1',
    'female_1',
    'male_2',
    'female_2'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'hebrew';
      _selectedTranslation = prefs.getString('selectedTranslation') ?? 'ESV';
      _rtlTextEnabled = prefs.getBool('rtlTextEnabled') ?? true;
      _aiAssistantEnabled = prefs.getBool('aiAssistantEnabled') ?? true;
      _crossReferencesEnabled = prefs.getBool('crossReferencesEnabled') ?? true;
      _autoSyncEnabled = prefs.getBool('autoSyncEnabled') ?? true;
      _analyticsEnabled = prefs.getBool('analyticsEnabled') ?? false;
      _highContrastMode = prefs.getBool('highContrastMode') ?? false;
      _reducedMotion = prefs.getBool('reducedMotion') ?? false;
      _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
      _selectedVoice = prefs.getString('selectedVoice') ?? 'default';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setString('selectedLanguage', _selectedLanguage);
    await prefs.setString('selectedTranslation', _selectedTranslation);
    await prefs.setBool('rtlTextEnabled', _rtlTextEnabled);
    await prefs.setBool('aiAssistantEnabled', _aiAssistantEnabled);
    await prefs.setBool('crossReferencesEnabled', _crossReferencesEnabled);
    await prefs.setBool('autoSyncEnabled', _autoSyncEnabled);
    await prefs.setBool('analyticsEnabled', _analyticsEnabled);
    await prefs.setBool('highContrastMode', _highContrastMode);
    await prefs.setBool('reducedMotion', _reducedMotion);
    await prefs.setDouble('playbackSpeed', _playbackSpeed);
    await prefs.setString('selectedVoice', _selectedVoice);
  }

  void _showTranslationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Translation',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: SizedBox(
            width: 80.w,
            height: 40.h,
            child: ListView.builder(
              itemCount: _translations.length,
              itemBuilder: (context, index) {
                final translation = _translations[index];
                final isSelected = translation == _selectedTranslation;
                return ListTile(
                  title: Text(translation),
                  leading: Radio<String>(
                    value: translation,
                    groupValue: _selectedTranslation,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedTranslation = value;
                        });
                        _saveSettings();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedTranslation = translation;
                    });
                    _saveSettings();
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showVoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Voice',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: SizedBox(
            width: 80.w,
            height: 30.h,
            child: ListView.builder(
              itemCount: _voices.length,
              itemBuilder: (context, index) {
                final voice = _voices[index];
                final isSelected = voice == _selectedVoice;
                return ListTile(
                  title: Text(voice.replaceAll('_', ' ').toUpperCase()),
                  leading: Radio<String>(
                    value: voice,
                    groupValue: _selectedVoice,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedVoice = value;
                        });
                        _saveSettings();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedVoice = voice;
                    });
                    _saveSettings();
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'This will reset all settings to their default values. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                setState(() {
                  _fontSize = 16.0;
                  _selectedLanguage = 'hebrew';
                  _selectedTranslation = 'ESV';
                  _rtlTextEnabled = true;
                  _aiAssistantEnabled = true;
                  _crossReferencesEnabled = true;
                  _autoSyncEnabled = true;
                  _analyticsEnabled = false;
                  _highContrastMode = false;
                  _reducedMotion = false;
                  _playbackSpeed = 1.0;
                  _selectedVoice = 'default';
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to defaults'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  double get _totalStorage => 128 * 1024 * 1024; // 128 MB
  double get _usedStorage => _storageBreakdown.fold(
      0.0, (sum, item) => sum + (item['size'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).appBarTheme.foregroundColor ??
                AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            children: [
              // Text Preferences Section
              SettingsSectionWidget(
                title: 'Text Preferences',
                children: [
                  FontSizeSliderWidget(
                    initialValue: _fontSize,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  LanguageSelectorWidget(
                    selectedLanguage: _selectedLanguage,
                    onLanguageChanged: (language) {
                      setState(() {
                        _selectedLanguage = language;
                      });
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Translation Version',
                    subtitle: _selectedTranslation,
                    leading: CustomIconWidget(
                      iconName: 'translate',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'keyboard_arrow_right',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    onTap: _showTranslationDialog,
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'RTL Text Display',
                    subtitle:
                        'Enable right-to-left text for Hebrew and Aramaic',
                    leading: CustomIconWidget(
                      iconName: 'format_textdirection_r_to_l',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _rtlTextEnabled,
                      onChanged: (value) {
                        setState(() {
                          _rtlTextEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                    isLast: true,
                  ),
                ],
              ),

              // Audio Settings Section
              SettingsSectionWidget(
                title: 'Audio Settings',
                children: [
                  SettingsItemWidget(
                    title: 'Playback Speed',
                    subtitle: '${_playbackSpeed}x',
                    leading: CustomIconWidget(
                      iconName: 'speed',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: SizedBox(
                      width: 30.w,
                      child: Slider(
                        value: _playbackSpeed,
                        min: 0.5,
                        max: 2.0,
                        divisions: 6,
                        onChanged: (value) {
                          setState(() {
                            _playbackSpeed = value;
                          });
                          _saveSettings();
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Voice Selection',
                    subtitle: _selectedVoice.replaceAll('_', ' ').toUpperCase(),
                    leading: CustomIconWidget(
                      iconName: 'record_voice_over',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'keyboard_arrow_right',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    onTap: _showVoiceDialog,
                    isLast: true,
                  ),
                ],
              ),

              // Study Preferences Section
              SettingsSectionWidget(
                title: 'Study Preferences',
                children: [
                  SettingsItemWidget(
                    title: 'AI Assistant',
                    subtitle: 'Enable AI-powered study assistance',
                    leading: CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _aiAssistantEnabled,
                      onChanged: (value) {
                        setState(() {
                          _aiAssistantEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Cross References',
                    subtitle: 'Show related verses and references',
                    leading: CustomIconWidget(
                      iconName: 'link',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _crossReferencesEnabled,
                      onChanged: (value) {
                        setState(() {
                          _crossReferencesEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                    isLast: true,
                  ),
                ],
              ),

              // Account & Sync Section
              SettingsSectionWidget(
                title: 'Account & Sync',
                children: [
                  SettingsItemWidget(
                    title: 'Cloud Sync',
                    subtitle: _autoSyncEnabled ? 'Enabled' : 'Disabled',
                    leading: CustomIconWidget(
                      iconName: 'cloud_sync',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _autoSyncEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoSyncEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Export Study Notes',
                    subtitle: 'Export your notes and bookmarks',
                    leading: CustomIconWidget(
                      iconName: 'file_download',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'keyboard_arrow_right',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Export feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),

              // Storage Management Section
              SettingsSectionWidget(
                title: 'Storage Management',
                children: [
                  StorageUsageWidget(
                    usedStorage: _usedStorage,
                    totalStorage: _totalStorage,
                    storageBreakdown: _storageBreakdown,
                  ),
                ],
              ),

              // Accessibility Section
              SettingsSectionWidget(
                title: 'Accessibility',
                children: [
                  SettingsItemWidget(
                    title: 'High Contrast Mode',
                    subtitle: 'Improve text visibility',
                    leading: CustomIconWidget(
                      iconName: 'contrast',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _highContrastMode,
                      onChanged: (value) {
                        setState(() {
                          _highContrastMode = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Reduced Motion',
                    subtitle: 'Minimize animations and transitions',
                    leading: CustomIconWidget(
                      iconName: 'accessibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _reducedMotion,
                      onChanged: (value) {
                        setState(() {
                          _reducedMotion = value;
                        });
                        _saveSettings();
                      },
                    ),
                    isLast: true,
                  ),
                ],
              ),

              // Privacy Section
              SettingsSectionWidget(
                title: 'Privacy',
                children: [
                  SettingsItemWidget(
                    title: 'Analytics',
                    subtitle: 'Help improve the app with usage data',
                    leading: CustomIconWidget(
                      iconName: 'analytics',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: Switch(
                      value: _analyticsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _analyticsEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy policy',
                    leading: CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening privacy policy...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),

              // About Section
              SettingsSectionWidget(
                title: 'About',
                children: [
                  SettingsItemWidget(
                    title: 'App Version',
                    subtitle: '1.0.0 (Build 2025080420)',
                    leading: CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Support',
                    subtitle: 'Get help and contact support',
                    leading: CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'keyboard_arrow_right',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening support page...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsItemWidget(
                    title: 'Reset Settings',
                    subtitle: 'Reset all settings to defaults',
                    leading: CustomIconWidget(
                      iconName: 'restore',
                      color: AppTheme.warningLight,
                      size: 20,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'keyboard_arrow_right',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    onTap: _showResetDialog,
                    isLast: true,
                  ),
                ],
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
