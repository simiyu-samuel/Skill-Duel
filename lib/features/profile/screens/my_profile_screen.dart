import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/avatar_circle.dart';
import '../../../shared/widgets/elo_badge.dart';
import '../../../shared/widgets/app_buttons.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () => context.pushNamed(RouteNames.settings),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            _buildProfileHero(context),
            const SizedBox(height: 48),
            _buildXpProgress(context),
            const SizedBox(height: 24),
            _buildStatsGrid(context),
            const SizedBox(height: 48),
            _buildRecentActivity(context),
            const SizedBox(height: 48),
            _buildProCta(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHero(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const AvatarCircle(fallbackLetter: 'D', size: 100),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: const Text('42', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'DUELIST #442',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        const Text(
          'ELITE MASTER TIER',
          style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialStat('1.2K', 'FOLLOWERS'),
            const SizedBox(width: 32),
            _socialStat('450', 'FOLLOWING'),
          ],
        ),
      ],
    );
  }

  Widget _socialStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: AppColors.secondary, fontSize: 8, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildXpProgress(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LEVEL PROGRESS', style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w900)),
              Text('2,450 / 3,000 XP', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.8,
              minHeight: 12,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _statCard('WIN RATE', '65%', AppColors.tertiary),
        _statCard('DUELS WON', '142', AppColors.accent),
        _statCard('AVG. ACCURACY', '82%', Colors.blue),
        _statCard('TOTAL TIME', '12h 45m', Colors.amber),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondary, fontSize: 9, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT DUELS',
          style: TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _activityTile('FOOTBALL', 'Sniper22', true),
        _activityTile('HISTORY', 'QuizWizard', false),
        _activityTile('SCIENCE', 'StormRunner', true),
      ],
    );
  }

  Widget _activityTile(String cat, String opp, bool won) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat, style: const TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w900)),
                Text(opp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Text(
            won ? '+24 ELO' : '-12 ELO',
            style: TextStyle(color: won ? AppColors.tertiary : AppColors.accent, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildProCta(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.accent, size: 40),
          const SizedBox(height: 16),
          const Text('UNLEASH THE PRO WITHIN', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          const Text('Remove ads, earn 2x rewards, and more.', style: TextStyle(color: AppColors.secondary, fontSize: 12)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.pushNamed(RouteNames.upgradePro),
              child: const Text('UPGRADE TO PRO', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
