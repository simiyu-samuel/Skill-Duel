import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/avatar_circle.dart';
import '../../../shared/widgets/elo_badge.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../models/app_user.dart';
import '../providers/social_provider.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'FRIENDS',
          style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 16),
          _buildRequestsBanner(context),
          Expanded(
            child: friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) return _buildEmptyState(context);
                return _buildFriendsList(context, friends, ref);
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search friends...',
            hintStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
            icon: Icon(Icons.search, color: AppColors.secondary, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.people_outline, color: AppColors.accent, size: 20),
          SizedBox(width: 12),
          Text('3 pending requests', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          Spacer(),
          Icon(Icons.chevron_right, color: AppColors.accent, size: 16),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildFriendsList(BuildContext context, List<AppUser> friends, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: friends.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final friend = friends[index];
        return _buildFriendTile(context, friend, ref);
      },
    );
  }

  Widget _buildFriendTile(BuildContext context, AppUser friend, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              AvatarCircle(fallbackLetter: friend.username[0], size: 48),
              if (friend.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(
                  friend.isOnline ? 'Active Now' : 'Last seen 2h ago',
                  style: const TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               IconButton(
                icon: const Icon(Icons.flash_on, color: AppColors.accent, size: 18),
                onPressed: () => context.pushNamed(
                  RouteNames.directChallenge,
                  extra: {
                    'friendId': friend.uid,
                    'friendUsername': friend.username,
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: AppColors.secondary, size: 18),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt_outlined, color: AppColors.secondary.withOpacity(0.3), size: 80),
          const SizedBox(height: 24),
          const Text('FIND YOUR RIVALS', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Search for friends to start dueling!', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: PrimaryButton(
              label: 'EXPLORE USERS',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
