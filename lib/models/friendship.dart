import 'package:cloud_firestore/cloud_firestore.dart';

enum FriendshipStatus { pending, accepted, blocked }

class Friendship {
  final String id;
  final List<String> uids; // Sorted alphabetically [uidA, uidB]
  final FriendshipStatus status;
  final String initiatedBy;
  final DateTime createdAt;

  const Friendship({
    required this.id,
    required this.uids,
    required this.status,
    required this.initiatedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uids': uids,
      'status': status.name,
      'initiatedBy': initiatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Friendship.fromMap(Map<String, dynamic> map, String id) {
    return Friendship(
      id: id,
      uids: List<String>.from(map['uids'] ?? []),
      status: FriendshipStatus.values.byName(map['status'] ?? 'pending'),
      initiatedBy: map['initiatedBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Friendship copyWith({
    FriendshipStatus? status,
  }) {
    return Friendship(
      id: id,
      uids: uids,
      status: status ?? this.status,
      initiatedBy: initiatedBy,
      createdAt: createdAt,
    );
  }
}
