/// Model class for audio summary API response.
/// audioUrl is a Firebase Storage download URL (served directly by the browser).
class AudioSummaryResult {
  final String audioUrl;
  final String summaryText;
  final int durationEstimate;
  final String timestamp;
  final bool fromCache;
  final int playCount;

  AudioSummaryResult({
    required this.audioUrl,
    required this.summaryText,
    required this.durationEstimate,
    required this.timestamp,
    this.fromCache = false,
    this.playCount = 0,
  });

  factory AudioSummaryResult.fromJson(Map<String, dynamic> json) {
    return AudioSummaryResult(
      audioUrl: json['audioUrl'] as String,
      summaryText: json['summaryText'] as String,
      durationEstimate: json['durationEstimate'] as int,
      timestamp: json['timestamp'] as String,
      fromCache: json['fromCache'] as bool? ?? false,
      playCount: json['playCount'] as int? ?? 0,
    );
  }
}
