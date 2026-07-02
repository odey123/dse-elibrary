import 'package:flutter/material.dart';
import '../../services/ai/ai_service.dart';
import '../../services/ai/models/practice_question.dart';
import '../../utils/constant.dart';

class PracticeScreen extends StatefulWidget {
  final String? courseId;
  final String? courseName;

  const PracticeScreen({
    super.key,
    this.courseId,
    this.courseName,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  final AIService _aiService = AIService();
  final TextEditingController _topicController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedDifficulty = 'medium';
  int _numQuestions = 5;
  bool _isGenerating = false;
  List<PracticeQuestion> _questions = [];
  Map<int, String> _userAnswers = {};
  Map<int, AnswerCheckResult?> _answerResults = {};
  Map<int, int> _hintLevels = {};
  Map<int, bool> _isChecking = {};

  int get _correctCount =>
      _answerResults.values.where((r) => r != null && r.correct).length;

  @override
  void dispose() {
    _topicController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _generateQuestions() async {
    if (_topicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a topic'),
          backgroundColor: kPrimaryColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _questions = [];
      _userAnswers = {};
      _answerResults = {};
      _hintLevels = {};
      _isChecking = {};
    });

    try {
      final questions = await _aiService.generateQuestions(
        topic: _topicController.text.trim(),
        courseId: widget.courseId,
        difficulty: _selectedDifficulty,
        numQuestions: _numQuestions,
      );

      setState(() {
        _questions = questions;
      });

      // Scroll to questions after they load
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent * 0.4,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _checkAnswer(int index) async {
    final userAnswer = _userAnswers[index]?.trim() ?? '';
    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter an answer'),
          backgroundColor: kPrimaryColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isChecking[index] = true);

    try {
      final result = await _aiService.checkAnswer(
        question: _questions[index].question,
        userAnswer: userAnswer,
        correctAnswer: _questions[index].answer,
        hintLevel: _hintLevels[index] ?? 0,
      );

      setState(() {
        _answerResults[index] = result;
        if (!result.correct && result.nextHintLevel != null) {
          _hintLevels[index] = result.nextHintLevel!;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isChecking[index] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kPrimaryColor,
                    kPrimaryColor.withOpacity(0.85),
                    const Color(0xFF2980B9),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : kMediumPadding,
                    vertical: kMediumPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (Navigator.of(context).canPop())
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: kPrimaryWhite.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.arrow_back_rounded,
                                    color: kPrimaryWhite, size: 22),
                              ),
                            ),
                          if (Navigator.of(context).canPop())
                            const SizedBox(width: kSmallPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.courseName ?? 'Practice Questions',
                                  style: textTheme.headlineMedium!.copyWith(
                                    color: kPrimaryWhite,
                                    fontSize: isWide ? 24 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Test your knowledge with AI-generated questions',
                                  style: textTheme.titleSmall!.copyWith(
                                    color: kPrimaryWhite.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: kPrimaryWhite.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.school_rounded,
                                color: kPrimaryWhite, size: 26),
                          ),
                        ],
                      ),
                      if (_questions.isNotEmpty) ...[
                        const SizedBox(height: kRegularPadding),
                        _buildProgressBar(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Body content
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isWide ? 720 : double.infinity),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 0 : kRegularPadding,
                  vertical: kMediumPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Generation Card
                    _buildGenerationCard(isWide),

                    // Loading State
                    if (_isGenerating) ...[
                      const SizedBox(height: kMediumPadding),
                      _buildLoadingState(),
                    ],

                    // Questions
                    if (_questions.isNotEmpty && !_isGenerating) ...[
                      const SizedBox(height: kMacroPadding),
                      _buildQuestionsHeader(),
                      const SizedBox(height: kRegularPadding),
                      ...List.generate(_questions.length, (index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: kRegularPadding),
                          child: _buildQuestionCard(index),
                        );
                      }),
                    ],

                    const SizedBox(height: kLargePadding),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final total = _questions.length;
    final answered = _answerResults.length;
    final correct = _correctCount;
    final progress = total > 0 ? answered / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(kSmallPadding + 2),
      decoration: BoxDecoration(
        color: kPrimaryWhite.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$answered of $total answered',
                style: textTheme.titleSmall!.copyWith(
                  color: kPrimaryWhite.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Color(0xFF2ECC71), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '$correct correct',
                    style: textTheme.titleSmall!.copyWith(
                      color: kPrimaryWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: kPrimaryWhite.withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerationCard(bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: kBlack.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: BoxDecoration(
              color: kLightSkyeBlue.withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: kPrimaryWhite, size: 22),
                ),
                const SizedBox(width: kSmallPadding + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generate Questions',
                        style: textTheme.headlineMedium!.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: kBlack800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'AI-powered practice for any topic',
                        style: textTheme.titleSmall!.copyWith(
                          fontSize: 12,
                          color: kGry800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic input
                Text(
                  'Topic',
                  style: textTheme.titleMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kGry900,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _topicController,
                  style: textTheme.titleMedium!.copyWith(
                    color: kBlack800,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g., Linear Algebra, Data Structures...',
                    hintStyle: textTheme.titleMedium!.copyWith(
                      color: kGry600,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 1.5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: kRegularPadding,
                      vertical: kRegularPadding,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(Icons.search_rounded,
                          color: kGry600, size: 20),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 20, minHeight: 20),
                  ),
                ),
                const SizedBox(height: kMediumPadding),

                // Difficulty selector
                Text(
                  'Difficulty',
                  style: textTheme.titleMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kGry900,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildDifficultyChip(
                        'easy', 'Easy', const Color(0xFF27AE60)),
                    const SizedBox(width: kSmallPadding),
                    _buildDifficultyChip(
                        'medium', 'Medium', const Color(0xFFF39C12)),
                    const SizedBox(width: kSmallPadding),
                    _buildDifficultyChip(
                        'hard', 'Hard', const Color(0xFFE74C3C)),
                  ],
                ),
                const SizedBox(height: kMediumPadding),

                // Number of questions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Questions',
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kGry900,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_numQuestions',
                        style: textTheme.titleMedium!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: kPrimaryColor,
                    inactiveTrackColor: const Color(0xFFE8ECF0),
                    thumbColor: kPrimaryWhite,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayColor: kPrimaryColor.withOpacity(0.1),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 18),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _numQuestions.toDouble(),
                    min: 3,
                    max: 10,
                    divisions: 7,
                    onChanged: (value) {
                      setState(() {
                        _numQuestions = value.toInt();
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3',
                        style: textTheme.titleSmall!
                            .copyWith(color: kGry600, fontSize: 11)),
                    Text('10',
                        style: textTheme.titleSmall!
                            .copyWith(color: kGry600, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: kMediumPadding),

                // Generate button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _generateQuestions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kPrimaryWhite,
                      disabledBackgroundColor: kPrimaryColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isGenerating)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kPrimaryWhite,
                            ),
                          )
                        else
                          const Icon(Icons.auto_awesome_rounded, size: 20),
                        const SizedBox(width: kSmallPadding),
                        Text(
                          _isGenerating ? 'Generating...' : 'Generate Questions',
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(kLargePadding),
      decoration: BoxDecoration(
        color: kPrimaryWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: kMediumPadding),
          Text(
            'Generating your questions...',
            style: textTheme.titleMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kBlack800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: textTheme.titleSmall!.copyWith(
              fontSize: 13,
              color: kGry800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsHeader() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: kSmallPadding),
        Expanded(
          child: Text(
            'Your Questions',
            style: textTheme.headlineMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kBlack800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: kLightSkyeBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_questions.length} questions',
            style: textTheme.titleSmall!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    final result = _answerResults[index];
    final isCorrect = result?.correct ?? false;
    final hasResult = result != null;
    final checking = _isChecking[index] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: kPrimaryWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF27AE60).withOpacity(0.3)
              : hasResult && !isCorrect
                  ? const Color(0xFFF39C12).withOpacity(0.3)
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Container(
            padding: const EdgeInsets.all(kRegularPadding),
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF27AE60).withOpacity(0.05)
                  : const Color(0xFFF5F7FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isCorrect
                          ? [const Color(0xFF27AE60), const Color(0xFF2ECC71)]
                          : [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isCorrect
                        ? const Icon(Icons.check_rounded,
                            color: kPrimaryWhite, size: 18)
                        : Text(
                            '${index + 1}',
                            style: textTheme.titleMedium!.copyWith(
                              color: kPrimaryWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: kSmallPadding),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      question.question,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kBlack800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Answer section
          Padding(
            padding: const EdgeInsets.all(kRegularPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Answer input
                TextField(
                  style: textTheme.titleMedium!.copyWith(
                    color: kBlack800,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: isCorrect ? 'Answered correctly!' : 'Type your answer here...',
                    hintStyle: textTheme.titleMedium!.copyWith(
                      color: isCorrect ? const Color(0xFF27AE60) : kGry600,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: kPrimaryColor, width: 1.5),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isCorrect
                        ? const Color(0xFF27AE60).withOpacity(0.05)
                        : const Color(0xFFF5F7FA),
                    enabled: !isCorrect,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: kRegularPadding,
                      vertical: kSmallPadding + 2,
                    ),
                    suffixIcon: hasResult
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              isCorrect
                                  ? Icons.check_circle_rounded
                                  : Icons.info_outline_rounded,
                              color: isCorrect
                                  ? const Color(0xFF27AE60)
                                  : const Color(0xFFF39C12),
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    _userAnswers[index] = value;
                  },
                  onSubmitted: (_) {
                    if (!isCorrect) _checkAnswer(index);
                  },
                  enabled: !isCorrect,
                  maxLines: null,
                ),
                const SizedBox(height: kSmallPadding),

                // Check answer button
                if (!isCorrect)
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: checking ? null : () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: kPrimaryWhite,
                        disabledBackgroundColor: kPrimaryColor.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: checking
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kPrimaryWhite,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_rounded, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  hasResult ? 'Try Again' : 'Check Answer',
                                  style: textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryWhite,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                // Feedback
                if (hasResult) ...[
                  const SizedBox(height: kSmallPadding),
                  Container(
                    padding: const EdgeInsets.all(kSmallPadding + 2),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFF27AE60).withOpacity(0.08)
                          : const Color(0xFFF39C12).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? const Color(0xFF27AE60).withOpacity(0.15)
                                    : const Color(0xFFF39C12).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                isCorrect
                                    ? Icons.celebration_rounded
                                    : Icons.lightbulb_outline_rounded,
                                color: isCorrect
                                    ? const Color(0xFF27AE60)
                                    : const Color(0xFFF39C12),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                result.feedback,
                                style: textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isCorrect
                                      ? const Color(0xFF27AE60)
                                      : kBlack800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (result.hint != null) ...[
                          const SizedBox(height: kSmallPadding),
                          Container(
                            padding: const EdgeInsets.all(kSmallPadding),
                            decoration: BoxDecoration(
                              color: kPrimaryWhite,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hint ${_hintLevels[index] ?? 1} of 4',
                                  style: textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF39C12),
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  result.hint!,
                                  style: textTheme.titleSmall!.copyWith(
                                    color: kBlack800,
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Explanation when correct
                if (isCorrect) ...[
                  const SizedBox(height: kSmallPadding),
                  Container(
                    padding: const EdgeInsets.all(kSmallPadding + 2),
                    decoration: BoxDecoration(
                      color: kLightSkyeBlue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.school_rounded,
                                  color: kPrimaryColor, size: 14),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Explanation',
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          question.explanation,
                          style: textTheme.titleSmall!.copyWith(
                            color: kBlack800,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String value, String label, Color color) {
    final isSelected = _selectedDifficulty == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDifficulty = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.4) : const Color(0xFFE8ECF0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? color : kGry500,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: textTheme.titleSmall!.copyWith(
                  color: isSelected ? color : kGry800,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
