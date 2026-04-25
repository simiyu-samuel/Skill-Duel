import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/match.dart';
import '../../../core/services/duel_service.dart';
import '../../auth/providers/auth_provider.dart';

// ── State ────────────────────────────────────────────────────────────────────

class MatchmakingState {
  final bool isSearching;
  final GameMatch? match;
  final String? error;
  final int secondsSearching;

  MatchmakingState({
    this.isSearching = false,
    this.match,
    this.error,
    this.secondsSearching = 0,
  });

  MatchmakingState copyWith({
    bool? isSearching,
    GameMatch? match,
    String? error,
    int? secondsSearching,
  }) {
    return MatchmakingState(
      isSearching: isSearching ?? this.isSearching,
      match: match ?? this.match,
      error: error ?? this.error,
      secondsSearching: secondsSearching ?? this.secondsSearching,
    );
  }
}

// ── Notifier (Riverpod 3.x) ──────────────────────────────────────────────────

class MatchmakingNotifier extends Notifier<MatchmakingState> {
  Timer? _timer;
  StreamSubscription? _matchSubscription;
  DuelService? _service;

  @override
  MatchmakingState build() {
    _service = ref.read(duelServiceProvider);
    ref.onDispose(() {
      _timer?.cancel();
      _matchSubscription?.cancel();
    });
    return MatchmakingState();
  }

  Future<void> findMatch(String category) async {
    state = state.copyWith(isSearching: true, secondsSearching: 0, error: null);

    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = state.copyWith(isSearching: false, error: 'User not authenticated');
      return;
    }

    await _service!.joinQueue(category, user.uid, user.elo.toDouble());

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(secondsSearching: state.secondsSearching + 1);
      if (state.secondsSearching >= 15) {
        _stopSearch();
        _startBotMatch(category);
      }
    });
  }

  void _startBotMatch(String category) {
    final botMatch = GameMatch(
      id: 'bot_match_${DateTime.now().millisecondsSinceEpoch}',
      category: category,
      playerIds: ['current_user_id', 'bot_007'],
      scores: {'current_user_id': 0, 'bot_007': 0},
      answers: {'current_user_id': [], 'bot_007': []},
      questionIds: ['q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7', 'q8', 'q9', 'q10'],
      status: MatchStatus.active,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(isSearching: false, match: botMatch);
  }

  Future<void> cancelSearch(String category) async {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      await _service!.leaveQueue(category, user.uid);
    }
    _stopSearch();
  }

  void _stopSearch() {
    _timer?.cancel();
    _matchSubscription?.cancel();
    state = state.copyWith(isSearching: false);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final matchmakingProvider =
    NotifierProvider<MatchmakingNotifier, MatchmakingState>(MatchmakingNotifier.new);
