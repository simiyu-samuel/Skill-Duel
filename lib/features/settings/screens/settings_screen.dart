import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SETTINGS',
          style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          _buildHeading('GAMEPLAY PREFERENCES'),
          _buildToggleTile('Sound Effects', true, (v) {}),
          _buildToggleTile('Music', false, (v) {}),
          _buildToggleTile('Push Notifications', true, (v) {}),
          _buildToggleTile('Haptic Feedback', true, (v) {}),
          
          const SizedBox(height: 32),
          _buildHeading('ACCOUNT CONFIGURATION'),
          _buildActionTile('Personal Information', Icons.person_outline, () {}),
          _buildActionTile('Linked Accounts', Icons.link, () {}),
          _buildActionTile('Security & Password', Icons.lock_outline, () {}),
          
          const SizedBox(height: 32),
          _buildHeading('SUPPORT & LEGAL'),
          _buildActionTile('Help Center', Icons.help_outline, () {}),
          _buildActionTile('Terms of Service', Icons.description, () {}),
          _buildActionTile('Privacy Policy', Icons.shield_outlined, () {}),

          const SizedBox(height: 48),
          _buildDangerZone(context, ref),
          const SizedBox(height: 40),
          Center(child: _buildVersionTag()),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(color: AppColors.secondary.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
        activeTrackColor: AppColors.accent.withOpacity(0.2),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.secondary, size: 20),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.secondary, size: 16),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.secondary.withOpacity(0.2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('LOG OUT', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => _showDelete(context, ref),
          child: const Text('DELETE ACCOUNT', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildVersionTag() {
    return Column(
      children: [
        const Text(
          'SKILL DUEL',
          style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3),
        ),
        Text(
          'VERSION 1.2.4',
          style: TextStyle(color: AppColors.secondary.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('PERMANENT DELETION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
        content: const Text(
          'This will permanently remove your rank, ELO, and purchase history. This cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL', style: TextStyle(color: AppColors.secondary))),
          TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              Navigator.pop(ctx);
            },
            child: const Text('DELETE FOREVER', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
