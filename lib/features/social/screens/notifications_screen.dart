import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/avatar_circle.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../social/providers/social_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, this would be a stream of notifications from Firestore
    final challengesAsync = ref.watch(incomingChallengesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          _buildTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: challengesAsync.when(
              data: (challenges) => _buildContent(context, ref, challenges),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<Map<String, dynamic>> challenges) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (challenges.isNotEmpty) ...[
          _buildSectionHeader('PENDING CHALLENGES'),
          const SizedBox(height: 16),
          ...challenges.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _challengeItem(
              context,
              ref,
              c['id'] ?? '',
              c['fromUid'] ?? 'Rival',
              c['category'] ?? 'General',
              'Just now',
            ),
          )),
          const SizedBox(height: 32),
        ],
        _buildSectionHeader('RECENT UPDATES'),
        const SizedBox(height: 16),
        _updateItem(
          context,
          'Level Up!',
          'You reached Level 12 and earned 500 Credits.',
          '1h ago',
          Icons.stars,
          Colors.amber,
        ),
        _updateItem(
          context,
          'Friend Request',
          'User_88 sent you a request.',
          '3h ago',
          Icons.person_add,
          AppColors.accent,
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _tab('ALL', true),
          const SizedBox(width: 12),
          _tab('ARENA', false),
          const SizedBox(width: 12),
          _tab('SOCIAL', false),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : AppColors.secondary,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.secondary.withOpacity(0.5),
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _challengeItem(BuildContext context, WidgetRef ref, String challengeId, String user, String cat, String time) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AvatarCircle(fallbackLetter: user.isNotEmpty ? user[0] : 'R', size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user == 'current_user_id' ? 'Self-Challenge' : 'Rival #88', // Mocking mapping for now
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Challenged you in ${cat.toUpperCase()}',
                      style: const TextStyle(color: AppColors.secondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(time, style: TextStyle(color: AppColors.secondary.withOpacity(0.5), fontSize: 10)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'DECLINE',
                  onPressed: () => ref.read(socialActionProvider.notifier).respondToChallenge(challengeId, false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'ACCEPT',
                  onPressed: () => ref.read(socialActionProvider.notifier).respondToChallenge(challengeId, true),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideX(begin: 0.1).fadeIn();
  }

  Widget _updateItem(BuildContext context, String title, String body, String time, IconData icon, Color color) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: TextStyle(color: AppColors.secondary.withOpacity(0.5), fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
