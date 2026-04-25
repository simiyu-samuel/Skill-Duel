import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../models/match.dart';
import '../../../models/question.dart';
import '../widgets/timer_circle.dart';
import '../providers/duel_provider.dart';

class ActiveQuestionScreen extends ConsumerStatefulWidget {
  final GameMatch match;

  const ActiveQuestionScreen({
    super.key,
    required this.match,
  });

  @override
  ConsumerState<ActiveQuestionScreen> createState() => _ActiveQuestionScreenState();
}

class _ActiveQuestionScreenState extends ConsumerState<ActiveQuestionScreen> {
  int? _selectedOptionIndex;
  bool _isLockedIn = false;
  int _lockInSeconds = 3;
  Timer? _lockInTimer;

  // Mock data — in production this comes from the active duel's Firestore document.
  final Question _currentQuestion = const Question(
    id: 'q1',
    question: 'Which player has scored the most goals in a single Premier League season?',
    options: ['Erling Haaland', 'Mohamed Salah', 'Alan Shearer', 'Andy Cole'],
    answer: 'Erling Haaland',
    category: 'football',
    subcategory: 'premier_league',
    difficulty: 2,
    explanation: 'Erling Haaland scored 36 Premier League goals in his debut 2022–23 season.',
    source: 'premierleague.com',
  );

  bool _timerWarningHapticsActive = false;

  @override
  void initState() {
    super.initState();
    // Seed the global DuelNotifier with this match the frame after the widget mounts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(duelProvider.notifier).initDuel(widget.match);
    });
  }

  void _handleOptionSelected(int index, DuelNotifier notifier) {
    if (_isLockedIn) return;
    HapticService.light(); // PRD: tactile confirmation on selection

    setState(() {
      _selectedOptionIndex = index;
      _isLockedIn = true;
      _lockInSeconds = 3;
    });

    HapticService.medium(); // PRD: lock-in bump

    _lockInTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lockInSeconds > 1) {
        setState(() => _lockInSeconds--);
      } else {
        _lockInTimer?.cancel();
        notifier.submitAnswer(index);
      }
    });
  }

  /// Called by TimerCircle / duel tick — triggers warning haptics at ≤5 s.
  void _onTimerTick(int secondsRemaining) {
    if (secondsRemaining <= 5 && !_timerWarningHapticsActive && !_isLockedIn) {
      _timerWarningHapticsActive = true;
      HapticService.medium();
    }
    if (secondsRemaining <= 5 && _timerWarningHapticsActive && !_isLockedIn) {
      // Pulse every second in the danger zone
      HapticService.medium();
    }
    if (secondsRemaining > 5) {
      _timerWarningHapticsActive = false;
    }
  }

  @override
  void dispose() {
    _lockInTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duelState = ref.watch(duelProvider);
    final notifier = ref.read(duelProvider.notifier);

    // Show spinner while the notifier initialises (first frame after mount).
    if (duelState == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    // Automatic navigation when game is over
    if (duelState.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(RouteNames.results, extra: duelState.match);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildTopBar(context, duelState.match),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildProgressBar(context),
              const SizedBox(height: 32),
              Builder(builder: (_) {
                // Wire up haptic warning on each frame the timer ticks
                if (!_isLockedIn) _onTimerTick(duelState.secondsRemaining);
                return TimerCircle(
                  progress: _isLockedIn ? _lockInSeconds / 3 : duelState.secondsRemaining / 20,
                  secondsRemaining: _isLockedIn ? _lockInSeconds : duelState.secondsRemaining,
                  label: _isLockedIn ? 'NEXT IN' : null,
                );
              }),
              const SizedBox(height: 32),
              _buildQuestionCard(context),
              const SizedBox(height: 24),
              _buildOptionsList(context, duelState, notifier),
              if (_isLockedIn) _buildSubmittingStatus(),
              const Spacer(),
              _buildFooterNote(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopBar(BuildContext context, GameMatch match) {
    final myUid = 'current_user_id';
    final opponentUid = match.playerIds.firstWhere((id) => id != myUid);

    return AppBar(
      toolbarHeight: 80,
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.flag_outlined, color: AppColors.secondary, size: 18),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question reported — thank you!')),
          ),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Opponent
          _buildPlayerInfo(
            '@rival_88',
            'ELO 1,190',
            const NetworkImage('https://via.placeholder.com/150'),
            isOpponent: true,
          ),
          
          // Category Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            ),
            child: const Text(
              'FOOTBALL',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // You
          _buildPlayerInfo(
            'YOU',
            'ELO 1,240',
            const NetworkImage('https://via.placeholder.com/150'),
            isUser: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(String name, String elo, ImageProvider avatar, {bool isOpponent = false, bool isUser = false}) {
    final color = isUser ? AppColors.accent : AppColors.secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isOpponent) _buildAvatar(avatar, color, isOpponent),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: isOpponent ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              elo,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (isUser) const SizedBox(width: 8),
        if (isUser) _buildAvatar(avatar, color, false),
      ],
    );
  }

  Widget _buildAvatar(ImageProvider avatar, Color color, bool isOpponent) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2),
            image: DecorationImage(image: avatar, fit: BoxFit.cover),
          ),
        ),
        if (isOpponent)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 2),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('MATCH PROGRESS', style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w900)),
            Text('4 / 10', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.4,
            minHeight: 6,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    // PRD: magenta bloom intensifies when timer ≤5 s
    final duelState = ref.watch(duelProvider);
    final isUrgent = !_isLockedIn && (duelState?.secondsRemaining ?? 20) <= 5;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          top: BorderSide(color: AppColors.accent, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          if (isUrgent)
            BoxShadow(
              color: AppColors.accent.withOpacity(0.45),
              blurRadius: 40,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Text(
        _currentQuestion.question,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context, DuelState state, DuelNotifier notifier) {
    return Column(
      children: List.generate(_currentQuestion.options.length, (index) {
        final option = _currentQuestion.options[index];
        final letter = String.fromCharCode(65 + index); // A, B, C, D
        final isSelected = _selectedOptionIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _handleOptionSelected(index, notifier),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.secondary.withOpacity(0.3),
                ),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 15)] : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? Colors.white : AppColors.secondary.withOpacity(0.5)),
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: isSelected ? AppColors.accent : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  if (isSelected) const Spacer(),
                  if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubmittingStatus() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'SUBMITTING',
            style: TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          const SizedBox(width: 8),
          const Row(
            children: [
              _DotAnimate(delay: 0),
              SizedBox(width: 4),
              _DotAnimate(delay: 150),
              SizedBox(width: 4),
              _DotAnimate(delay: 300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterNote() {
    return const Text(
      'Take your time — opponent sees results only after both submit.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0x99B0B8C8), // secondary at ~60% opacity
        fontSize: 10,
      ),
    );
  }
}

class _DotAnimate extends StatelessWidget {
  final int delay;
  const _DotAnimate({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
    ).animate(onPlay: (c) => c.repeat()).moveY(
      begin: 0,
      end: -4,
      duration: 300.ms,
      delay: delay.ms,
      curve: Curves.easeInOut,
    ).then().moveY(begin: -4, end: 0, duration: 300.ms);
  }
}
