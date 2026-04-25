import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/elo_badge.dart';
import '../../../shared/widgets/avatar_circle.dart';

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DAILY CHALLENGE',
          style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildGoldHeroCard(context),
            const SizedBox(height: 32),
            _buildLeaderboardSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          const Text(
            '7 DAY STREAK CHALLENGE',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete your daily session to keep the streak!',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),
          _buildStreakCircles(),
          const SizedBox(height: 32),
          _buildPrizeBubble(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFD97706),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('START TODAY\'S SESSION', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isCompleted = index < 3;
        final isCurrent = index == 3;
        final color = isCompleted || isCurrent ? Colors.white : Colors.white.withOpacity(0.3);

        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: isCompleted
                  ? const Icon(Icons.check, color: Color(0xFFD97706), size: 16)
                  : Text('${index + 1}', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            Text('DAY ${index + 1}', style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
          ],
        );
      }),
    );
  }

  Widget _buildPrizeBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('PRIZE: ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('100 COINS + 10 GEMS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          const Icon(Icons.wallet, color: Colors.white, size: 14),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TOP STREAKERS',
          style: TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildLeaderItem(1, 'FlameDuelist', '24 DAYS', true),
        _buildLeaderItem(2, 'StormRunner', '18 DAYS', false),
        _buildLeaderItem(3, 'QuizWizard', '15 DAYS', false),
      ],
    );
  }

  Widget _buildLeaderItem(int rank, String name, String streak, bool isTop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isTop ? Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          Text('$rank', style: TextStyle(color: isTop ? const Color(0xFFF59E0B) : AppColors.secondary, fontWeight: FontWeight.w900)),
          const SizedBox(width: 16),
          const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Text(streak, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }
}
