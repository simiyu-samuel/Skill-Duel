import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../core/services/iap_service.dart';

class UpgradeProScreen extends ConsumerWidget {
  const UpgradeProScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ).animate().fadeIn(duration: 1.seconds),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 48),
                  _buildHero(context),
                  const SizedBox(height: 32),
                  _buildBenefitsGrid(context),
                  const SizedBox(height: 64),
                  _buildPricingOptions(context),
                  const SizedBox(height: 32),
                  _buildUpgradeButton(context, ref),
                  const SizedBox(height: 24),
                  _buildFooter(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'PRO UPGRADE',
          style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondary, size: 24),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.2, 1.2), duration: 2.seconds),
            const Icon(Icons.workspace_premium, color: AppColors.accent, size: 80),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'UNLEASH THE PRO',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        const SizedBox(height: 8),
        const Text(
          'Unlock the ultimate dueling experience',
          style: TextStyle(color: AppColors.secondary, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBenefitsGrid(BuildContext context) {
    return Column(
      children: [
        _benefitRow(Icons.block, 'No More Ads', 'Focus on 100% dueling'),
        const SizedBox(height: 16),
        _benefitRow(Icons.bolt, '2x ELO Rewards', 'Rank up twice as fast'),
        const SizedBox(height: 16),
        _benefitRow(Icons.auto_awesome, 'AI Explanations', 'Learn from every mistake'),
        const SizedBox(height: 16),
        _benefitRow(Icons.verified_user, 'Pro Badge', 'Stand out in the arena'),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _benefitRow(IconData icon, String title, String desc) {
    return Container(
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
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: AppColors.secondary, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.tertiary, size: 20),
        ],
      ),
    );
  }

  Widget _buildPricingOptions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _pricingCard('MONTHLY', r'$4.99', false)),
        const SizedBox(width: 16),
        Expanded(child: _pricingCard('ANNUAL', r'$39.99', true)),
      ],
    );
  }

  Widget _pricingCard(String period, String price, bool highlight) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: highlight ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? AppColors.accent : AppColors.secondary.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: highlight ? [
          BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 15),
        ] : [],
      ),
      child: Column(
        children: [
          if (highlight)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
              child: const Text('SAVE 33%', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
            ),
          const SizedBox(height: 8),
          Text(period, style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          Text(period == 'ANNUAL' ? '/ YEAR' : '/ MONTH', style: const TextStyle(color: AppColors.secondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          shadowColor: AppColors.accent.withOpacity(0.5),
        ),
        onPressed: () => _handleUpgrade(context, ref),
        child: const Text(
          'UPGRADE TO PRO NOW',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: const Text('RESTORE PURCHASES', style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        const Text(
          'Terms of Service • Privacy Policy',
          style: TextStyle(color: AppColors.secondary, fontSize: 10),
        ),
      ],
    );
  }

  Future<void> _handleUpgrade(BuildContext context, WidgetRef ref) async {
    final iap = ref.read(iapServiceProvider);
    await iap.purchasePro('current_user_id');
    if (context.mounted) {
      context.pushNamed(RouteNames.purchaseSuccess);
    }
  }
}
