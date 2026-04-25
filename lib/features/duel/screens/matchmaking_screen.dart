import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/avatar_circle.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../providers/matchmaking_provider.dart';
import '../../../models/match.dart';

class MatchmakingScreen extends ConsumerStatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen> {
  Timer? _elapsedTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchmakingProvider.notifier).findMatch('football');
    });
    // PRD: ±150 ELO bucket → ±300 after 30s → Open after 60s
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }

  String get _searchPhaseLabel {
    if (_elapsedSeconds < 30) return 'SCANNING WITHIN ±150 ELO';
    if (_elapsedSeconds < 60) return 'EXPANDING TO ±300 ELO...';
    return 'OPEN CHALLENGE MODE ACTIVE';
  }

  Color get _searchPhaseColor {
    if (_elapsedSeconds < 30) return AppColors.accent;
    if (_elapsedSeconds < 60) return const Color(0xFFF59E0B); // amber
    return AppColors.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchmakingProvider);
    final isMatched = state.match != null && state.match!.status == MatchStatus.active;

    if (isMatched) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          context.goNamed(RouteNames.activeQuestion, extra: state.match);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () {
            ref.read(matchmakingProvider.notifier).cancelSearch('football');
            context.pop();
          },
        ),
        title: Text(
          'FINDING OPPONENT',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMatchmakingVisual(state, isMatched),
                  const SizedBox(height: 48),
                  _buildStatusText(state, isMatched),
                ],
              ),
            ),
          ),
          _buildBottomActions(context),
          _buildBottomNavPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildMatchmakingVisual(MatchmakingState state, bool isMatched) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // YOU
        _buildPlayerSlot(
          label: 'YOU',
          name: '@kofi_duel',
          elo: '1,240',
          color: AppColors.tertiary,
          isUser: true,
        ),
        
        // CENTER SWORDS
        _buildSwordsCenter(isMatched),
        
        // OPPONENT
        _buildPlayerSlot(
          label: isMatched ? 'OPPONENT' : 'HIDDEN',
          name: isMatched ? '@rival_88' : 'Searching...',
          elo: isMatched ? '1,190' : '~1,200',
          color: isMatched ? AppColors.accent : AppColors.secondary,
          isSearching: !isMatched,
        ),
      ],
    );
  }

  Widget _buildPlayerSlot({
    required String label,
    required String name,
    required String elo,
    required Color color,
    bool isUser = false,
    bool isSearching = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.5)],
                ),
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.3), blurRadius: 15),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.surface,
                backgroundImage: isSearching ? null : const NetworkImage('https://via.placeholder.com/150'),
                child: isSearching ? const Icon(Icons.question_mark, size: 40, color: AppColors.secondary) : null,
              ),
            ),
            if (!isSearching)
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          elo,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSwordsCenter(bool isMatched) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!isMatched)
          ...List.generate(2, (index) => _buildPulseRing(index)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 30),
            ],
          ),
          child: const Icon(Icons.sports_esports, size: 32, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPulseRing(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
      ),
    )
    .animate(onPlay: (c) => c.repeat())
    .scale(duration: 1.5.seconds, begin: const Offset(1, 1), end: const Offset(2.5, 2.5))
    .fadeOut();
  }

  Widget _buildStatusText(MatchmakingState state, bool isMatched) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
          ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.seconds, delay: (index * 200).ms, begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2))),
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            children: [
              const TextSpan(text: 'Looking for an opponent in '),
              TextSpan(
                text: 'Football · Medium',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            _searchPhaseLabel,
            key: ValueKey(_searchPhaseLabel),
            style: TextStyle(
              color: _searchPhaseColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_elapsedSeconds}s elapsed',
          style: const TextStyle(color: AppColors.secondary, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.group_add, size: 20),
            label: const Text('Challenge a Friend Instead'),
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'CANCEL',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavPlaceholder() {
    return Container(
      height: 80,
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'HQ', false),
          _buildNavItem(Icons.sports_esports, 'ARENA', true),
          _buildNavItem(Icons.leaderboard, 'RANKS', false),
          _buildNavItem(Icons.person, 'PROFILE', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AppColors.accent : AppColors.secondary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ],
    );
  }
}
