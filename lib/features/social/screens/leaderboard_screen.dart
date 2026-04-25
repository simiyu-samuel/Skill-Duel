import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/avatar_circle.dart';
import '../../../shared/widgets/elo_badge.dart';
import '../providers/social_provider.dart';
import '../../../models/app_user.dart';


class _LeaderboardToggleNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int v) => state = v;
}

final leaderboardToggleProvider =
    NotifierProvider<_LeaderboardToggleNotifier, int>(_LeaderboardToggleNotifier.new);


class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleIndex = ref.watch(leaderboardToggleProvider);
    final leaderboardAsync = toggleIndex == 0 
        ? ref.watch(globalLeaderboardProvider)
        : ref.watch(friendsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'LEADERBOARD',
          style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          _buildToggle(ref),
          const SizedBox(height: 24),
          Expanded(
            child: leaderboardAsync.when(
              data: (users) {
                if (users.isEmpty) return const Center(child: Text('No data available.', style: TextStyle(color: AppColors.secondary)));
                
                final top3 = users.take(3).toList();
                final others = users.skip(3).toList();

                return ListView(
                  children: [
                    _buildPodium(context, top3),
                    const SizedBox(height: 48),
                    _buildRankList(context, others),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
          _buildMyRankBanner(context),
        ],
      ),
    );
  }

  Widget _buildToggle(WidgetRef ref) {
    final index = ref.watch(leaderboardToggleProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _toggleItem(ref, 'GLOBAL', 0, index == 0),
          _toggleItem(ref, 'FRIENDS', 1, index == 1),
        ],
      ),
    );
  }

  Widget _toggleItem(WidgetRef ref, String label, int i, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(leaderboardToggleProvider.notifier).state = i,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : AppColors.secondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<AppUser> top) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (top.length > 1) _podiumAvatar(top[1], AppColors.eloSilver, '2', 80),
        const SizedBox(width: 12),
        if (top.isNotEmpty) _podiumAvatar(top[0], AppColors.eloGold, '1', 110, isWinner: true),
        const SizedBox(width: 12),
        if (top.length > 2) _podiumAvatar(top[2], AppColors.eloBronze, '3', 80),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }

  Widget _podiumAvatar(AppUser user, Color color, String rank, double size, {bool isWinner = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.3), blurRadius: 20),
                ],
              ),
            ),
            AvatarCircle(fallbackLetter: user.username[0], size: size - 12),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rank,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.username,
          style: TextStyle(color: Colors.white, fontSize: isWinner ? 14 : 12, fontWeight: FontWeight.w900),
        ),
        Text(
          '${user.elo}',
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRankList(BuildContext context, List<AppUser> others) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: others.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final user = others[index];
          return _buildRankTile(index + 4, user);
        },
      ),
    );
  }

  Widget _buildRankTile(int rank, AppUser user) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$rank',
            style: const TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 12),
        AvatarCircle(fallbackLetter: user.username[0], size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            user.username,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        ELOBadge(elo: user.elo, fontSize: 10),
      ],
    );
  }

  Widget _buildMyRankBanner(BuildContext context) {
    return Container(
      color: AppColors.accent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Text(
              '#1,245',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
            ),
            const SizedBox(width: 16),
            const AvatarCircle(fallbackLetter: 'D', size: 36),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                  Text('Gold League', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const ELOBadge(elo: 1045, fontSize: 12),
          ],
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: 400.ms);
  }
}
