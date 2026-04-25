import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus { searching, active, finished }

class GameMatch {
  final String id;
  final String category;
  final List<String> playerIds;
  final Map<String, int> scores;
  final Map<String, List<int>> answers;
  final List<String> questionIds;
  final MatchStatus status;
  final DateTime createdAt;
  final String? winnerId;

  const GameMatch({
    required this.id,
    required this.category,
    required this.playerIds,
    required this.scores,
    required this.answers,
    required this.questionIds,
    required this.status,
    required this.createdAt,
    this.winnerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'playerIds': playerIds,
      'scores': scores,
      'answers': answers,
      'questionIds': questionIds,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'winnerId': winnerId,
    };
  }

  factory GameMatch.fromMap(Map<String, dynamic> map, String id) {
    return GameMatch(
      id: id,
      category: map['category'] ?? '',
      playerIds: List<String>.from(map['playerIds'] ?? []),
      scores: Map<String, int>.from(map['scores'] ?? {}),
      answers: (map['answers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<int>.from(value)),
      ),
      questionIds: List<String>.from(map['questionIds'] ?? []),
      status: MatchStatus.values.byName(map['status'] ?? 'searching'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      winnerId: map['winnerId'],
    );
  }

  GameMatch copyWith({
    MatchStatus? status,
    Map<String, int>? scores,
    String? winnerId,
  }) {
    return GameMatch(
      id: id,
      category: category,
      playerIds: playerIds,
      scores: scores ?? this.scores,
      answers: answers,
      questionIds: questionIds,
      status: status ?? this.status,
      createdAt: createdAt,
      winnerId: winnerId ?? this.winnerId,
    );
  }
}
