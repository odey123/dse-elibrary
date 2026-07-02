class PracticeQuestion {
  final String question;
  final String answer;
  final String explanation;

  PracticeQuestion({
    required this.question,
    required this.answer,
    required this.explanation,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      question: json['question'] as String,
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'explanation': explanation,
    };
  }
}

class AnswerCheckResult {
  final bool correct;
  final String feedback;
  final String? hint;
  final int? nextHintLevel;

  AnswerCheckResult({
    required this.correct,
    required this.feedback,
    this.hint,
    this.nextHintLevel,
  });

  factory AnswerCheckResult.fromJson(Map<String, dynamic> json) {
    return AnswerCheckResult(
      correct: json['correct'] as bool,
      feedback: json['feedback'] as String,
      hint: json['hint'] as String?,
      nextHintLevel: json['nextHintLevel'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correct': correct,
      'feedback': feedback,
      if (hint != null) 'hint': hint,
      if (nextHintLevel != null) 'nextHintLevel': nextHintLevel,
    };
  }
}
