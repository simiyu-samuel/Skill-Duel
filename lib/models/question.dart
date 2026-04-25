/// Question model aligned with Project Scope v2.0 — Section 6.3.
///
/// Firestore path: questions/{id}
class Question {
  final String id;

  /// The question text displayed to the player.
  final String question;

  /// Category ID: football | chess | coding | cod | gaming
  final String category;

  /// Subcategory for filtering — e.g. premier_league, openings, algorithms
  final String subcategory;

  /// 1 = Easy, 2 = Medium, 3 = Hard
  final int difficulty;

  /// Four answer options shown to the player.
  final List<String> options;

  /// The correct answer — must match one of [options] exactly.
  final String answer;

  /// Shown on the Answer Review screen (Screen 17) post-duel.
  final String explanation;

  /// Source URL or publication for fact verification.
  final String source;

  /// False for V2 categories (cod, gaming) at MVP launch.
  final bool isActive;

  /// Auto-incremented by the Report Question system (Screen 33).
  final int reportedCount;

  const Question({
    required this.id,
    required this.question,
    required this.category,
    required this.subcategory,
    required this.difficulty,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.source,
    this.isActive = true,
    this.reportedCount = 0,
  });

  factory Question.fromFirestore(Map<String, dynamic> data, String docId) {
    return Question(
      id: docId,
      question: data['question'] as String,
      category: data['category'] as String,
      subcategory: data['subcategory'] as String? ?? '',
      difficulty: data['difficulty'] as int? ?? 2,
      options: List<String>.from(data['options'] as List),
      answer: data['answer'] as String,
      explanation: data['explanation'] as String? ?? '',
      source: data['source'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
      reportedCount: data['reportedCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'question': question,
    'category': category,
    'subcategory': subcategory,
    'difficulty': difficulty,
    'options': options,
    'answer': answer,
    'explanation': explanation,
    'source': source,
    'isActive': isActive,
    'reportedCount': reportedCount,
  };

  /// Returns the index of the correct answer in [options], -1 if not found.
  int get correctOptionIndex => options.indexOf(answer);
}
