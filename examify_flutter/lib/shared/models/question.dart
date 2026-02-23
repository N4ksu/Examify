class Question {
  final int id;
  final int assessmentId;
  final String text;
  final String type; // 'mcq', 'short_answer'
  final List<String> options;
  final String? correctAnswer;
  final int points;

  Question({
    required this.id,
    required this.assessmentId,
    required this.text,
    required this.type,
    this.options = const [],
    this.correctAnswer,
    this.points = 1,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      assessmentId: json['assessment_id'] ?? 0,
      text: json['text'],
      type: json['type'] ?? 'mcq',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'],
      points: json['points'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_id': assessmentId,
      'text': text,
      'type': type,
      'options': options,
      'correct_answer': correctAnswer,
      'points': points,
    };
  }
}
