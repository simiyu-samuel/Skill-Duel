import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/match.dart';

class DuelService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Listen to a specific match in real-time (RTDB)
  Stream<GameMatch?> listenToMatch(String matchId) {
    return _db.ref('duels/$matchId').onValue.map((event) {
      if (event.snapshot.value == null) return null;
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return GameMatch.fromMap(data, matchId);
    });
  }

  // Add user to matchmaking queue in RTDB
  Future<void> joinQueue(String category, String uid, double elo) async {
    final entry = {
      'uid': uid,
      'elo': elo,
      'timestamp': ServerValue.timestamp,
    };
    
    await _db.ref('matchmaking/$category/queue/$uid').set(entry);
  }

  // Remove from queue
  Future<void> leaveQueue(String category, String uid) async {
    await _db.ref('matchmaking/$category/queue/$uid').remove();
  }

  // Update scores in RTDB
  Future<void> updateScore(String matchId, String uid, int score) async {
    await _db.ref('duels/$matchId/scores/$uid').set(score);
  }

  // Submit completion
  Future<void> submitDuel(String matchId, String uid) async {
    await _db.ref('duels/$matchId/submitted/$uid').set(true);
  }
}

final duelServiceProvider = Provider((ref) => DuelService());
