import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/elo_badge.dart';
import '../../../shared/widgets/avatar_circle.dart';

class ResultShareCard extends StatelessWidget {
  final bool isWin;
  final int myScore;
  final int opponentScore;
  final int eloChange;
  final String category;
  final String username;

  const ResultShareCard({
    super.key,
    required this.isWin,
    required this.myScore,
    required this.opponentScore,
    required this.eloChange,
    required this.category,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isWin ? AppColors.success : AppColors.error, width: 2),
        boxShadow: [
          BoxShadow(
            color: (isWin ? AppColors.success : AppColors.error).withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isWin ? 'VICTORY!' : 'DEFEAT',
            style: TextStyle(
              color: isWin ? AppColors.success : AppColors.error,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.toUpperCase(),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParticipant(username, 'D', myScore),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('VS', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              ),
              _buildParticipant('Opponent', 'B', opponentScore),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ELOBadge(elo: 1025),
                Text(
                  isWin ? '+$eloChange ELO' : '-${eloChange ~/ 2} ELO',
                  style: TextStyle(
                    color: isWin ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'CHALLENGE ME AT:',
            style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const Text(
            'skillduel.app/@duelist_442',
            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipant(String name, String letter, int score) {
    return Column(
      children: [
        AvatarCircle(fallbackLetter: letter, size: 48),
        const SizedBox(height: 8),
        Text(
          '$score',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        Text(
          name,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
