import 'package:flutter/material.dart';
import '../ai_chat/ai_chat_sidebar.dart';
import '../../services/ai/ai_service.dart';
import '../../utils/constant.dart';

class AITestScreen extends StatefulWidget {
  const AITestScreen({super.key});

  @override
  State<AITestScreen> createState() => _AITestScreenState();
}

class _AITestScreenState extends State<AITestScreen> {
  final AIService _aiService = AIService();
  bool _isConnected = false;
  bool _isChecking = true;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() => _isChecking = true);
    final connected = await _aiService.testConnection();
    setState(() {
      _isConnected = connected;
      _isChecking = false;
    });
  }

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLighterAsh,
      appBar: AppBar(
        title: Text(
          'AI Assistant',
          style: textTheme.titleMedium!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kBlack,
          ),
        ),
        backgroundColor: kPrimaryWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kBlack),
      ),
      body: Stack(
        children: [
          // Main content
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(kMicroPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: kMacroPadding),
                    // Icon container
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _isConnected
                              ? [kPrimaryColor.withOpacity(0.1), kLightSkyeBlue]
                              : [kGry300, kGry500],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _isConnected
                                ? kPrimaryColor.withOpacity(0.2)
                                : kGry500,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.smart_toy_rounded,
                        size: 70,
                        color: _isConnected ? kPrimaryColor : kGry600,
                      ),
                    ),
                    const SizedBox(height: kLargePadding),

                    // Status text
                    Text(
                      _isChecking
                          ? 'Connecting...'
                          : _isConnected
                              ? 'AI Assistant Ready'
                              : 'AI Assistant Offline',
                      style: textTheme.headlineMedium!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kBlack800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kSmallPadding),

                    // Subtitle
                    Text(
                      _isConnected
                          ? 'Ask questions about your courses and get instant help!'
                          : 'Please make sure the backend server is running',
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 16,
                        color: kGry800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kLargePadding),

                    // Action buttons
                    if (_isConnected)
                      ElevatedButton(
                        onPressed: _toggleChat,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kLargePadding,
                            vertical: kRegularPadding,
                          ),
                          backgroundColor: kPrimaryColor,
                          foregroundColor: kPrimaryWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          shadowColor: kPrimaryColor.withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 24),
                            const SizedBox(width: kSmallPadding),
                            Text(
                              'Start Chat',
                              style: textTheme.titleMedium!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryWhite,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (!_isConnected && !_isChecking)
                      OutlinedButton.icon(
                        onPressed: _checkConnection,
                        icon: const Icon(Icons.refresh, color: kPrimaryColor),
                        label: Text(
                          'Retry Connection',
                          style: textTheme.titleMedium!.copyWith(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kMacroPadding,
                            vertical: kRegularPadding,
                          ),
                          side: const BorderSide(color: kPrimaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),

                    if (_isChecking)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),

                    // Features list
                    if (_isConnected) ...[
                      const SizedBox(height: kLargePadding),
                      Container(
                        padding: const EdgeInsets.all(kRegularPadding),
                        decoration: BoxDecoration(
                          color: kPrimaryWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: kGry500.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildFeatureItem(
                              Icons.question_answer_outlined,
                              'Ask Questions',
                              'Get answers about your course materials',
                            ),
                            const Divider(height: kMediumPadding),
                            _buildFeatureItem(
                              Icons.lightbulb_outline,
                              'Get Explanations',
                              'Understand complex concepts easily',
                            ),
                            const Divider(height: kMediumPadding),
                            _buildFeatureItem(
                              Icons.quiz_outlined,
                              'Practice Questions',
                              'Test your knowledge with AI-generated questions',
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: kMacroPadding),
                  ],
                ),
              ),
            ),
          ),

          // Sidebar chat
          if (_showChat)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AIChatSidebar(
                courseName: 'AI Assistant',
                onClose: _toggleChat,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: kLightSkyeBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kPrimaryColor, size: 24),
        ),
        const SizedBox(width: kSmallPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kBlack800,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.titleSmall!.copyWith(
                  fontSize: 13,
                  color: kGry800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
