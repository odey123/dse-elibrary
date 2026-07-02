import 'dart:math';

import 'package:flutter/material.dart';
import 'package:systems_app/services/ai/ai_service.dart';
import 'package:systems_app/services/ai/models/audio_summary_result.dart';
import 'package:systems_app/utils/constant.dart';
import 'dart:html' as html;

/// A beautiful, premium audio summary player widget.
/// Generates a NotebookLM-style audio overview of a course material PDF.
class AudioSummaryPlayer extends StatefulWidget {
  final String materialUrl;
  final String materialName;
  final String? courseName;
  final VoidCallback onClose;

  const AudioSummaryPlayer({
    super.key,
    required this.materialUrl,
    required this.materialName,
    this.courseName,
    required this.onClose,
  });

  @override
  State<AudioSummaryPlayer> createState() => _AudioSummaryPlayerState();
}

class _AudioSummaryPlayerState extends State<AudioSummaryPlayer>
    with TickerProviderStateMixin {
  final AIService _aiService = AIService();

  // State
  bool _isGenerating = false;
  bool _isPlaying = false;
  bool _hasGenerated = false;
  bool _showSummaryText = false;
  String? _errorMessage;
  String _statusMessage = '';
  AudioSummaryResult? _result;

  // Web audio
  html.AudioElement? _audioElement;
  double _currentPosition = 0;
  double _totalDuration = 0;

  // Animations
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _audioElement?.pause();
    _audioElement = null;
    _slideController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _generateAudio() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _statusMessage = 'Loading audio summary...';
    });

    // Show progress messages during fresh generation (ignored on cache hits
    // because _hasGenerated becomes true before these fire).
    _updateStatusAfterDelay(3, 'Extracting content from PDF...');
    _updateStatusAfterDelay(10, 'Generating conversational summary...');
    _updateStatusAfterDelay(25, 'Converting to audio...');

    try {
      final result = await _aiService.generateAudioSummary(
        materialUrl: widget.materialUrl,
        courseName: widget.courseName,
      );

      if (!mounted) return;

      setState(() {
        _result = result;
        _statusMessage = result.fromCache ? 'Loading from cache...' : 'Preparing audio player...';
      });

      _setupWebAudio(result.audioUrl);

      setState(() {
        _hasGenerated = true;
        _isGenerating = false;
        _totalDuration = result.durationEstimate.toDouble();
        _statusMessage = '';
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _statusMessage = '';
        });
      }
    }
  }

  void _updateStatusAfterDelay(int seconds, String message) {
    Future.delayed(Duration(seconds: seconds), () {
      if (mounted && _isGenerating && !_hasGenerated) {
        setState(() => _statusMessage = message);
      }
    });
  }

  void _setupWebAudio(String audioUrl) {
    _audioElement = html.AudioElement(audioUrl);

    _audioElement!.onLoadedMetadata.listen((_) {
      if (mounted) {
        setState(() {
          _totalDuration = _audioElement!.duration;
        });
      }
    });

    _audioElement!.onTimeUpdate.listen((_) {
      if (mounted) {
        setState(() {
          _currentPosition = _audioElement!.currentTime;
        });
      }
    });

    _audioElement!.onEnded.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = 0;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_audioElement == null) return;

    if (_isPlaying) {
      _audioElement!.pause();
    } else {
      _audioElement!.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekTo(double position) {
    if (_audioElement == null) return;
    _audioElement!.currentTime = position;
    setState(() {
      _currentPosition = position;
    });
  }

  String _formatDuration(double seconds) {
    if (seconds.isNaN || seconds.isInfinite) return '0:00';
    final mins = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _close() async {
    _audioElement?.pause();
    await _slideController.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(kRegularPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0f3460).withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),

            // Content
            if (!_hasGenerated && !_isGenerating) _buildGeneratePrompt(),
            if (_isGenerating) _buildGeneratingState(),
            if (_hasGenerated) _buildPlayer(),
            if (_errorMessage != null) _buildError(),

            // Summary text preview
            if (_hasGenerated && _result != null) _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kRegularPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Animated icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3498DB)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.headphones_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: kSmallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Audio Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'KumbhSans',
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.materialName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontFamily: 'KumbhSans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Close button
          GestureDetector(
            onTap: _close,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.close_rounded,
                color: Colors.white.withOpacity(0.6),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratePrompt() {
    return Padding(
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.2),
                  const Color(0xFF3498DB).withOpacity(0.2),
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF6C63FF),
              size: 32,
            ),
          ),
          const SizedBox(height: kRegularPadding),
          const Text(
            'Generate AI Audio Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'KumbhSans',
            ),
          ),
          const SizedBox(height: kSmallPadding),
          Text(
            'Get a NotebookLM-style audio overview\nof this material in minutes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
              fontFamily: 'KumbhSans',
              height: 1.5,
            ),
          ),
          const SizedBox(height: kMediumPadding),
          GestureDetector(
            onTap: _generateAudio,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kMacroPadding,
                vertical: kSmallPadding + 4,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF3498DB)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Generate Audio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'KumbhSans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingState() {
    return Padding(
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        children: [
          // Animated pulse ring
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6C63FF)
                        .withOpacity(_pulseAnimation.value * 0.5),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF3498DB)],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: kMediumPadding),
          const Text(
            'Generating Audio Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'KumbhSans',
            ),
          ),
          const SizedBox(height: kSmallPadding),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 0.4 + (_pulseAnimation.value * 0.4),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 13,
                    fontFamily: 'KumbhSans',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: kMediumPadding),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF6C63FF),
              ),
            ),
          ),
          const SizedBox(height: kSmallPadding),
          Text(
            'This may take 30-60 seconds...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 11,
              fontFamily: 'KumbhSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    return Padding(
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        children: [
          // Cache / play-count badge
          if (_result != null && _result!.fromCache)
            Padding(
              padding: const EdgeInsets.only(bottom: kSmallPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded,
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.8), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Instant · played ${_result!.playCount}×',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 11,
                            fontFamily: 'KumbhSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Waveform visualization
          SizedBox(
            height: 60,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 60),
                  painter: _WaveformPainter(
                    progress: _totalDuration > 0
                        ? _currentPosition / _totalDuration
                        : 0,
                    isPlaying: _isPlaying,
                    animationValue: _waveController.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: kSmallPadding),

          // Progress slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: const Color(0xFF6C63FF),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
            ),
            child: Slider(
              value: _currentPosition.clamp(0, _totalDuration),
              max: _totalDuration > 0 ? _totalDuration : 1,
              onChanged: _seekTo,
            ),
          ),

          // Time labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontFamily: 'KumbhSans',
                  ),
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontFamily: 'KumbhSans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSmallPadding),

          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10s
              GestureDetector(
                onTap: () => _seekTo((_currentPosition - 10).clamp(0, _totalDuration)),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.replay_10_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: kMediumPadding),

              // Play/Pause
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF3498DB)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(width: kMediumPadding),

              // Forward 10s
              GestureDetector(
                onTap: () => _seekTo((_currentPosition + 10).clamp(0, _totalDuration)),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.forward_10_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      children: [
        // Toggle summary text
        GestureDetector(
          onTap: () {
            setState(() => _showSummaryText = !_showSummaryText);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPadding,
              vertical: kSmallPadding,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _showSummaryText
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  _showSummaryText ? 'Hide Transcript' : 'Show Transcript',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    fontFamily: 'KumbhSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Summary text
        if (_showSummaryText)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            margin: const EdgeInsets.only(
              left: kMediumPadding,
              right: kMediumPadding,
              bottom: kMediumPadding,
            ),
            padding: const EdgeInsets.all(kRegularPadding),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: SingleChildScrollView(
              child: Text(
                _result?.summaryText ?? '',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                  fontFamily: 'KumbhSans',
                  height: 1.6,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kRed.withOpacity(0.15),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: kRed.withOpacity(0.8),
              size: 30,
            ),
          ),
          const SizedBox(height: kRegularPadding),
          Text(
            'Generation Failed',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'KumbhSans',
            ),
          ),
          const SizedBox(height: kSmallPadding),
          Text(
            _errorMessage ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontFamily: 'KumbhSans',
            ),
          ),
          const SizedBox(height: kRegularPadding),
          GestureDetector(
            onTap: _generateAudio,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kSmallPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'KumbhSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for animated audio waveform visualization
class _WaveformPainter extends CustomPainter {
  final double progress;
  final bool isPlaying;
  final double animationValue;

  _WaveformPainter({
    required this.progress,
    required this.isPlaying,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 3.0;
    final gap = 2.0;
    final totalBars = (size.width / (barWidth + gap)).floor();

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + gap);
      final normalizedI = i / totalBars;

      // Create varied bar heights using sine waves
      double height;
      if (isPlaying) {
        height = size.height *
            0.3 *
            (0.3 +
                0.7 *
                    sin(normalizedI * pi * 4 +
                        animationValue * pi * 2 +
                        i * 0.5)
                        .abs());
      } else {
        // Static bars (subtle pattern)
        height = size.height * 0.15 * (0.4 + 0.6 * sin(normalizedI * pi * 6).abs());
      }

      final isActive = normalizedI <= progress;

      final paint = Paint()
        ..color = isActive
            ? const Color(0xFF6C63FF).withOpacity(0.8)
            : Colors.white.withOpacity(0.12)
        ..style = PaintingStyle.fill;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, size.height / 2),
          width: barWidth,
          height: height,
        ),
        const Radius.circular(2),
      );

      canvas.drawRRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.animationValue != animationValue;
  }
}
