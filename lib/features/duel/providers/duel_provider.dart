import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/match.dart';
import '../../../core/services/duel_service.dart';

// ── State ────────────────────────────────────────────────────────────────────

class DuelState {
  final GameMatch match;
  final int currentQuestionIndex;
  final int secondsRemaining;
  final bool isGameOver;

  DuelState({
    required this.match,
    this.currentQuestionIndex = 0,
    this.secondsRemaining = 20,
    this.isGameOver = false,
  });

  DuelState copyWith({
    GameMatch? match,
    int? currentQuestionIndex,
    int? secondsRemaining,
    bool? isGameOver,
  }) {
    return DuelState(
      match: match ?? this.match,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

// ── Notifier (Riverpod 3.x Notifier — no code gen required) ─────────────────
// Family requires code gen in Riverpod 3.x. 
// Pattern: single active duel stored globally; screen passes match via initDuel().

class DuelNotifier extends Notifier<DuelState?> {
  Timer? _timer;
  DuelService? _service;

  @override
  DuelState? build() {
    _service = ref.read(duelServiceProvider);
    ref.onDispose(() => _timer?.cancel());
    return null; // no active duel initially
  }

  /// Called by ActiveQuestionScreen.initState() to start tracking a match.
  void initDuel(GameMatch match) {
    _timer?.cancel();
    state = DuelState(match: match);
    _listenToMatchUpdates(match.id);
    _startTimer();
  }

  void _listenToMatchUpdates(String matchId) {
    _service!.listenToMatch(matchId).listen((updated) {
      if (updated != null && state != null) {
        state = state!.copyWith(match: updated);
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = state;
      if (s == null) return;
      if (s.secondsRemaining > 0) {
        state = s.copyWith(secondsRemaining: s.secondsRemaining - 1);
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _timer?.cancel();
    _nextQuestion();
  }

  Future<void> submitAnswer(int optionIndex) async {
    final s = state;
    if (s == null) return;
    const myUid = 'current_user_id';
    final currentScore = s.match.scores[myUid] ?? 0;
    if (optionIndex == 0) {
      await _service!.updateScore(s.match.id, myUid, currentScore + 1);
    }
    if (s.match.playerIds.contains('bot_007')) {
      _simulateBotAnswer();
    }
    _nextQuestion();
  }

  void _simulateBotAnswer() async {
    final s = state;
    if (s == null) return;
    const opponentUid = 'bot_007';
    final currentScore = s.match.scores[opponentUid] ?? 0;
    if ((DateTime.now().millisecond % 100) < 80) {
      await _service!.updateScore(s.match.id, opponentUid, currentScore + 1);
    }
  }

  void _nextQuestion() {
    final s = state;
    if (s == null) return;
    if (s.currentQuestionIndex < s.match.questionIds.length - 1) {
      state = s.copyWith(
        currentQuestionIndex: s.currentQuestionIndex + 1,
        secondsRemaining: 20,
      );
      _startTimer();
    } else {
      _finishMatch();
    }
  }

  Future<void> _finishMatch() async {
    _timer?.cancel();
    final s = state;
    if (s == null) return;
    const myUid = 'current_user_id';
    await _service!.submitDuel(s.match.id, myUid);

    const opponentUid = 'bot_007';
    final myScore = s.match.scores[myUid] ?? 0;
    final opponentScore = s.match.scores[opponentUid] ?? 0;
    String? winnerId;
    if (myScore > opponentScore) winnerId = myUid;
    else if (opponentScore > myScore) winnerId = opponentUid;

    state = s.copyWith(
      isGameOver: true,
      match: s.match.copyWith(status: MatchStatus.finished, winnerId: winnerId),
    );
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final duelProvider = NotifierProvider<DuelNotifier, DuelState?>(DuelNotifier.new);
