import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/openai_client.dart';
import '../../services/openai_service.dart';
import './widgets/chat_message_widget.dart';
import './widgets/context_header_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/quick_suggestion_widget.dart';
import './widgets/typing_indicator_widget.dart';

class AiStudyAssistant extends StatefulWidget {
  const AiStudyAssistant({Key? key}) : super(key: key);

  @override
  State<AiStudyAssistant> createState() => _AiStudyAssistantState();
}

class _AiStudyAssistantState extends State<AiStudyAssistant>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isExpanded = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // OpenAI integration
  late OpenAIService _openAIService;
  late OpenAIClient _openAIClient;
  bool _openAIAvailable = false;

  // Mock data for current study context
  final String _currentVerse =
      "In the beginning was the Word, and the Word was with God, and the Word was God.";
  final String _bookChapter = "John 1:1";

  // Quick suggestions for common study questions
  final List<String> _quickSuggestions = [
    'Explain this passage',
    'Historical context',
    'Cross-references',
    'Original language',
    'Theological meaning',
    'Application today',
  ];

  // Mock AI responses with verse references (fallback)
  final List<Map<String, dynamic>> _mockResponses = [
    {
      "query": "explain this passage",
      "response":
          "This opening verse of John's Gospel establishes the divine nature of Jesus Christ. The Greek word 'Logos' (Word) was familiar to both Jewish and Greek audiences, representing God's creative power and wisdom. John declares that this Logos existed eternally with God and was fully divine.",
      "references": ["Genesis 1:1", "Colossians 1:16", "Hebrews 1:3"],
    },
    {
      "query": "historical context",
      "response":
          "John wrote his Gospel around 85-95 AD, addressing a community that included both Jewish Christians and Gentile converts. The prologue counters early Gnostic teachings that denied Christ's full divinity. The concept of 'Logos' bridges Jewish wisdom literature and Greek philosophy.",
      "references": ["Proverbs 8:22-31", "1 John 1:1", "Revelation 19:13"],
    },
    {
      "query": "cross-references",
      "response":
          "This verse connects to numerous passages about Christ's pre-existence and divinity. Genesis 1:1 parallels the 'beginning' theme. Colossians 1:15-17 describes Christ as the image of God through whom all things were created. Hebrews 1:1-3 presents Jesus as God's final revelation.",
      "references": [
        "Genesis 1:1",
        "Colossians 1:15-17",
        "Hebrews 1:1-3",
        "Philippians 2:6"
      ],
    },
    {
      "query": "original language",
      "response":
          "The Greek text uses 'Logos' (λόγος) for 'Word,' 'pros' (πρός) indicating intimate relationship 'with God,' and 'theos' (θεός) for 'God.' The structure 'kai theos ēn ho logos' emphasizes the Word's divine nature while maintaining distinction from the Father.",
      "references": ["John 1:14", "1 John 1:1", "Revelation 19:13"],
    },
    {
      "query": "theological meaning",
      "response":
          "This verse establishes the doctrine of the Trinity and Christ's dual nature. The Word's eternal existence with God shows the Son's distinct personhood, while 'the Word was God' affirms His full divinity. This foundation supports the Incarnation doctrine developed in verse 14.",
      "references": ["John 1:14", "John 8:58", "John 10:30", "John 17:5"],
    },
    {
      "query": "application today",
      "response":
          "Understanding Christ as the eternal Word transforms our relationship with Scripture and prayer. Jesus is God's complete revelation, making Him central to understanding God's character and will. This truth provides assurance of salvation and confidence in Christ's authority over all creation.",
      "references": [
        "Hebrews 1:1-2",
        "2 Timothy 3:16",
        "John 14:6",
        "Matthew 28:18"
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    // Initialize OpenAI service
    try {
      _openAIService = OpenAIService();
      _openAIClient = OpenAIClient(_openAIService.dio);
      _openAIAvailable = true;
    } catch (e) {
      _openAIAvailable = false;
      print('OpenAI service initialization failed: $e');
    }

    // Check for initial message from navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
      _handleNavigationArguments();
    });
  }

  void _handleNavigationArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final initialMessage = args['initialMessage'] as String?;
      final initialResponse = args['initialResponse'] as String?;

      if (initialMessage != null) {
        setState(() {
          _messages.add({
            'message': initialMessage,
            'isUser': true,
            'timestamp': DateTime.now(),
          });
        });

        if (initialResponse != null) {
          setState(() {
            _messages.add({
              'message': initialResponse,
              'isUser': false,
              'timestamp': DateTime.now(),
              'verseReferences': <String>[],
            });
          });
        }

        _scrollToBottom();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleMessageSent(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    _scrollToBottom();

    // Use OpenAI if available, otherwise fallback to mock responses
    if (_openAIAvailable) {
      _generateOpenAIResponse(message);
    } else {
      // Simulate AI processing delay
      Future.delayed(const Duration(seconds: 2), () {
        _generateMockResponse(message);
      });
    }
  }

  Future<void> _generateOpenAIResponse(String userMessage) async {
    try {
      // Create a contextual prompt for Bible study
      final contextualPrompt = '''
You are a knowledgeable Bible study assistant. The user is currently studying ${_bookChapter}: "${_currentVerse}"

The user has asked: "$userMessage"

Please provide a helpful, educational response about the Bible. If the question is about a specific verse or passage, provide:
1. The meaning and context
2. Historical background if relevant  
3. Cross-references to related passages (list them separately)
4. Practical application

Keep your response informative but concise (under 300 words). If you mention specific Bible verses, format them as "Book Chapter:Verse" (e.g., "John 3:16").
''';

      final messages = [
        Message(role: 'system', content: contextualPrompt),
        Message(role: 'user', content: userMessage),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.7, 'max_tokens': 400},
      );

      // Extract verse references from the response
      final verseReferences = _extractVerseReferences(response.text);

      setState(() {
        _messages.add({
          'message': response.text,
          'isUser': false,
          'timestamp': DateTime.now(),
          'verseReferences': verseReferences,
        });
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      // Fallback to mock response if OpenAI fails
      print('OpenAI request failed: $e');
      _generateMockResponse(userMessage);
    }
  }

  void _generateMockResponse(String userMessage) {
    final query = userMessage.toLowerCase();

    // Find matching response or use default
    Map<String, dynamic> responseData = _mockResponses.firstWhere(
      (response) => query.contains(response['query']),
      orElse: () => {
        "response":
            "I understand you're asking about this passage. Based on the context of ${_bookChapter}, this verse reveals important theological truths about the nature of Christ and God's revelation. Would you like me to explore any specific aspect in more detail?",
        "references": [_bookChapter],
      },
    );

    setState(() {
      _messages.add({
        'message': responseData['response'],
        'isUser': false,
        'timestamp': DateTime.now(),
        'verseReferences': responseData['references'],
      });
      _isLoading = false;
    });

    _scrollToBottom();
  }

  List<String> _extractVerseReferences(String text) {
    // Simple regex to extract Bible verse references
    final RegExp versePattern = RegExp(
      r'\b([1-3]?\s*[A-Za-z]+)\s+(\d+):(\d+)(?:-(\d+))?\b',
      caseSensitive: false,
    );

    final matches = versePattern.allMatches(text);
    final references = <String>{};

    for (final match in matches) {
      references.add(match.group(0)!);
    }

    return references.toList();
  }

  void _handleVoiceMessage(String voiceText) {
    _handleMessageSent("Voice input: $voiceText");
  }

  void _handleSuggestionPressed(String suggestion) {
    _handleMessageSent(suggestion);
  }

  void _handleVerseReferencePressed(String reference) {
    // Navigate back to text reader with specific verse
    Navigator.pushNamed(context, '/bible-text-reader');
    Fluttertoast.showToast(
      msg: "Opening $reference",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _minimizeAssistant() {
    _slideController.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    Fluttertoast.showToast(
      msg: "Conversation cleared",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    Fluttertoast.showToast(
      msg: "Message copied",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareMessage(String message) {
    // Implement share functionality
    Fluttertoast.showToast(
      msg: "Sharing message...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _saveMessage(String message) {
    // Navigate to personal study notes
    Navigator.pushNamed(context, '/personal-study-notes');
    Fluttertoast.showToast(
      msg: "Message saved to notes",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: GestureDetector(
        onTap: () => _minimizeAssistant(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SlideTransition(
            position: _slideAnimation,
            child: DraggableScrollableSheet(
              initialChildSize: _isExpanded ? 0.9 : 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.w),
                      topRight: Radius.circular(4.w),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        width: 12.w,
                        height: 1.h,
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(0.5.h),
                        ),
                      ),

                      // Header with context
                      ContextHeaderWidget(
                        currentVerse: _currentVerse,
                        bookChapter: _bookChapter,
                        onMinimize: _minimizeAssistant,
                        onClearChat: _clearChat,
                      ),

                      // AI Status indicator
                      if (!_openAIAvailable)
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2.w),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'Using offline mode. Set OPENAI_API_KEY to enable AI features.',
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Chat messages
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _clearChat();
                          },
                          child: _messages.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  itemCount:
                                      _messages.length + (_isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _messages.length &&
                                        _isLoading) {
                                      return const TypingIndicatorWidget();
                                    }

                                    final message = _messages[index];
                                    return ChatMessageWidget(
                                      message: message['message'],
                                      isUser: message['isUser'],
                                      timestamp: message['timestamp'],
                                      verseReferences:
                                          message['verseReferences'],
                                      onVerseReferencePressed:
                                          _handleVerseReferencePressed,
                                      onCopy: () =>
                                          _copyMessage(message['message']),
                                      onShare: () =>
                                          _shareMessage(message['message']),
                                      onSave: () =>
                                          _saveMessage(message['message']),
                                    );
                                  },
                                ),
                        ),
                      ),

                      // Quick suggestions
                      if (_messages.isEmpty)
                        QuickSuggestionWidget(
                          suggestions: _quickSuggestions,
                          onSuggestionPressed: _handleSuggestionPressed,
                        ),

                      // Message input
                      MessageInputWidget(
                        onMessageSent: _handleMessageSent,
                        onVoiceMessageSent: _handleVoiceMessage,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              _openAIAvailable
                  ? 'AI Study Assistant'
                  : 'Study Assistant (Offline)',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _openAIAvailable
                  ? 'Ask questions about ${_bookChapter} to deepen your understanding of Scripture.'
                  : 'Ask questions about ${_bookChapter} using our built-in study guides.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Try asking:',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
