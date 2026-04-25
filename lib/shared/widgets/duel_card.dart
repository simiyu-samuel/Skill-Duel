import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'elo_badge.dart';

class DuelCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String category;
  final int? myScore;
  final int? opponentScore;
  final int? eloChange;
  final VoidCallback onTap;
  final bool isWin;
  final bool isPremium;
  final bool isLocked;

  const DuelCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.category,
    this.myScore,
    this.opponentScore,
    this.eloChange,
    required this.onTap,
    this.isWin = false,
    this.isPremium = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Opacity(
        opacity: isLocked ? 0.7 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.surface.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildCategoryIcon(),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: isLocked ? AppColors.textSecondary : null,
                                ),
                          ),
                          if (subtitle != null)
                            Text(
                              isLocked ? 'UPGRADE TO UNLOCK' : subtitle!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isLocked
                                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                                        : null,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (isPremium && !isLocked)
                    _buildProBadge()
                  else if (isLocked)
                    const Icon(Icons.lock_outline,
                        color: AppColors.textSecondary, size: 20)
                  else if (myScore != null && opponentScore != null)
                    _buildScoreBoard()
                  else
                    const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                ],
              ),
              if (eloChange != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    ELOBadge(elo: 1000 + (eloChange ?? 0)),
                    const SizedBox(width: 8),
                    Text(
                      eloChange! >= 0 ? '+$eloChange' : '$eloChange',
                      style: TextStyle(
                        color: eloChange! >= 0
                            ? AppColors.success
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (myScore != null)
                      Text(
                        isWin ? 'VICTORY' : 'DEFEAT',
                        style: TextStyle(
                          color: isWin ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.eloGold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.eloGold.withValues(alpha: 0.5)),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: AppColors.eloGold,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData icon;
    Color color;
    switch (category.toLowerCase()) {
      case 'football':
        icon = Icons.sports_soccer;
        color = Colors.green;
        break;
      case 'chess':
        icon = Icons.extension;
        color = Colors.orange;
        break;
      case 'coding':
        icon = Icons.code;
        color = Colors.blue;
        break;
      default:
        icon = Icons.emoji_events;
        color = AppColors.accent;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$myScore - $opponentScore',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
