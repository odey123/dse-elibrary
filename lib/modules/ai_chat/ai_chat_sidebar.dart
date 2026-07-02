import 'package:flutter/material.dart';
import '../../services/ai/ai_service.dart';
import '../../services/ai/models/chat_message.dart';
import '../../utils/constant.dart';

class AIChatSidebar extends StatefulWidget {
  final String? materialText;
  final String? courseId;
  final String? courseName;
  final Map<String, String>? materials; // Material name -> Firebase Storage URL
  final VoidCallback onClose;

  const AIChatSidebar({
    super.key,
    this.materialText,
    this.courseId,
    this.courseName,
    this.materials,
    required this.onClose,
  });

  @override
  State<AIChatSidebar> createState() => _AIChatSidebarState();
}

class _AIChatSidebarState extends State<AIChatSidebar>
    with SingleTickerProviderStateMixin {
  final AIService _aiService = AIService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _selectedMaterial; // Selected material name
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final question = _messageController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        role: 'user',
        content: question,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      String answer;
      
      // Use RAG if a material is selected
      if (_selectedMaterial != null && widget.materials != null) {
        final materialUrl = widget.materials![_selectedMaterial];
        if (materialUrl != null) {
          answer = await _aiService.askWithMaterial(
            question: question,
            materialUrl: materialUrl,
            courseId: widget.courseId,
          );
        } else {
          throw Exception('Material URL not found');
        }
      } else {
        // Fall back to general question
        answer = await _aiService.askQuestion(
          question: question,
          materialText: widget.materialText,
          courseId: widget.courseId,
        );
      }

      setState(() {
        _messages.add(ChatMessage(
          role: 'ai',
          content: answer,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          role: 'ai',
          content: 'Sorry, I encountered an error: ${e.toString()}',
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _close() async {
    await _animationController.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: 400,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kPrimaryWhite,
          boxShadow: [
            BoxShadow(
              color: kBlack.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(kRegularPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kPrimaryWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.smart_toy_rounded,
                          color: kPrimaryWhite, size: 24),
                    ),
                    const SizedBox(width: kSmallPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.courseName ?? 'AI Assistant',
                            style: textTheme.titleMedium!.copyWith(
                              color: kPrimaryWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Online',
                            style: textTheme.titleSmall!.copyWith(
                              color: kPrimaryWhite.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: kPrimaryWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: kPrimaryWhite, size: 20),
                        onPressed: _close,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Material selector (if materials are provided)
            if (widget.materials != null && widget.materials!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(kRegularPadding),
                decoration: BoxDecoration(
                  color: kPrimaryWhite,
                  border: Border(
                    bottom: BorderSide(
                      color: kGry300.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ask about a specific material:',
                      style: textTheme.titleSmall!.copyWith(
                        color: kGry800,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: kSmallPadding),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kSmallPadding + 2,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kGry300,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedMaterial != null
                              ? kPrimaryColor
                              : kGry400,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedMaterial,
                          isExpanded: true,
                          dropdownColor: kPrimaryWhite,
                          hint: Text(
                            'General questions (no material)',
                            style: textTheme.titleSmall!.copyWith(
                              color: kGry600,
                              fontSize: 13,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text(
                                'General questions',
                                style: textTheme.titleSmall!.copyWith(
                                  color: kBlack800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            ...widget.materials!.keys.map((materialName) {
                              return DropdownMenuItem<String?>(
                                value: materialName,
                                child: Text(
                                  materialName,
                                  style: textTheme.titleSmall!.copyWith(
                                    color: kBlack800,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedMaterial = value;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: kGry600,
                          ),
                        ),
                      ),
                    ),
                    if (_selectedMaterial != null)
                      Padding(
                        padding: const EdgeInsets.only(top: kSmallPadding),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.picture_as_pdf,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Asking about: $_selectedMaterial',
                                style: textTheme.titleSmall!.copyWith(
                                  color: kPrimaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            // Messages
            Expanded(
              child: Container(
                color: kLighterAsh,
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: kLightSkyeBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat_bubble_outline,
                                  size: 40, color: kPrimaryColor),
                            ),
                            const SizedBox(height: kMediumPadding),
                            Text(
                              'Ask me anything!',
                              style: textTheme.headlineMedium!.copyWith(
                                color: kBlack800,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: kSmallPadding),
                            Text(
                              'I can help you understand\nyour course materials',
                              textAlign: TextAlign.center,
                              style: textTheme.titleSmall!.copyWith(
                                color: kGry800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(kRegularPadding),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isUser = message.role == 'user';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: kRegularPadding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: kLightSkyeBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.smart_toy_rounded,
                                        size: 20, color: kPrimaryColor),
                                  ),
                                  const SizedBox(width: kSmallPadding),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(kSmallPadding + 2),
                                    decoration: BoxDecoration(
                                      color: isUser ? kPrimaryColor : kPrimaryWhite,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                                        bottomRight: Radius.circular(isUser ? 4 : 16),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kGry500.withOpacity(0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      message.content,
                                      style: textTheme.titleMedium!.copyWith(
                                        color: isUser ? kPrimaryWhite : kBlack800,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isUser) const SizedBox(width: 48),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Loading indicator
            if (_isLoading)
              Container(
                color: kLighterAsh,
                padding: const EdgeInsets.symmetric(
                  horizontal: kRegularPadding,
                  vertical: kSmallPadding,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: kLightSkyeBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.smart_toy_rounded,
                          size: 20, color: kPrimaryColor),
                    ),
                    const SizedBox(width: kSmallPadding),
                    Container(
                      padding: const EdgeInsets.all(kSmallPadding + 2),
                      decoration: BoxDecoration(
                        color: kPrimaryWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kGry500.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(width: kSmallPadding),
                          Text(
                            'Thinking...',
                            style: textTheme.titleSmall!.copyWith(
                              color: kGry800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Input
            Container(
              padding: const EdgeInsets.all(kRegularPadding),
              decoration: BoxDecoration(
                color: kPrimaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: kGry500.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kGry300,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          style: textTheme.titleMedium!.copyWith(
                            color: kBlack,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your question...',
                            hintStyle: textTheme.titleMedium!.copyWith(
                              color: kGry600,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kSmallPadding + 2,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                          enabled: !_isLoading,
                          maxLines: null,
                        ),
                      ),
                    ),
                    const SizedBox(width: kSmallPadding),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        icon: const Icon(Icons.send_rounded, size: 20),
                        color: kPrimaryWhite,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
