import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/app_user.dart';
import '../../models/friendship.dart';

class SocialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of the top 50 users by ELO
  Stream<List<AppUser>> getGlobalLeaderboard() {
    return _firestore
        .collection('users')
        .orderBy('elo', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppUser.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream of a user's friends
  Stream<List<AppUser>> getFriends(String uid) {
    return _firestore
        .collection('friendships')
        .where('uids', arrayContains: uid)
        .where('status', isEqualTo: FriendshipStatus.accepted.name)
        .snapshots()
        .asyncMap((snapshot) async {
      final friendIds = snapshot.docs.map((doc) {
        final data = doc.data();
        final ids = List<String>.from(data['uids']);
        return ids.firstWhere((id) => id != uid);
      }).toList();

      if (friendIds.isEmpty) return [];

      final friendsSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();

      return friendsSnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> sendFriendRequest(String fromUid, String toUid) async {
    final uids = [fromUid, toUid]..sort();
    await _firestore.collection('friendships').add({
      'uids': uids,
      'status': FriendshipStatus.pending.name,
      'initiatedBy': fromUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFriendRequest(String friendshipId) async {
    await _firestore.collection('friendships').doc(friendshipId).update({
      'status': FriendshipStatus.accepted.name,
    });
  }

  // --- Challenges ---

  Future<String> sendChallenge(String fromUid, String toUid, String category) async {
    final doc = await _firestore.collection('challenges').add({
      'fromUid': fromUid,
      'toUid': toUid,
      'category': category,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<List<Map<String, dynamic>>> getIncomingChallenges(String uid) {
    return _firestore
        .collection('challenges')
        .where('toUid', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  Future<void> respondToChallenge(String challengeId, bool accept) async {
    await _firestore.collection('challenges').doc(challengeId).update({
      'status': accept ? 'accepted' : 'declined',
    });
  }
}

final socialServiceProvider = Provider((ref) => SocialService());
