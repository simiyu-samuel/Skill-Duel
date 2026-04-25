import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/duel_code_generator.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../shared/widgets/avatar_circle.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../models/category.dart';
import '../../social/providers/social_provider.dart';

class DirectChallengeScreen extends ConsumerStatefulWidget {
  final String friendId;
  final String friendUsername;

  const DirectChallengeScreen({
    super.key,
    required this.friendId,
    required this.friendUsername,
  });

  @override
  ConsumerState<DirectChallengeScreen> createState() => _DirectChallengeScreenState();
}

class _ActiveCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isLive;

  const _ActiveCategory(this.id, this.name, this.icon, this.color, this.isLive);
}

class _DirectChallengeScreenState extends ConsumerState<DirectChallengeScreen> {
  String? _selectedCategoryId;
  String? _generatedCode; // SD-XXXXXX code shown after challenge is sent
  bool _isSending = false;

  final List<_ActiveCategory> _categories = [
    const _ActiveCategory('football', 'FOOTBALL', Icons.sports_soccer, Color(0xFF22C55E), true),
    const _ActiveCategory('chess', 'CHESS TACTICS', Icons.extension, Color(0xFFF59E0B), true),
    const _ActiveCategory('coding', 'CODING', Icons.terminal, Color(0xFF00D1FF), true),
    const _ActiveCategory('cod', 'COD / FPS', Icons.gps_fixed, Color(0xFFFC536D), false),
    const _ActiveCategory('gaming', 'GENERAL GAMING', Icons.videogame_asset, Color(0xFF6366F1), false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('DIRECT CHALLENGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildFriendHero(),
            const SizedBox(height: 48),
            const Text(
              'SELECT CATEGORY',
              style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
            const SizedBox(height: 24),
            _buildCategoryGrid(),
            const SizedBox(height: 64),
            PrimaryButton(
              label: 'SEND CHALLENGE',
              isLoading: false,
              onPressed: _selectedCategoryId == null ? null : _handleSendChallenge,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendHero() {
    return Column(
      children: [
        const AvatarCircle(fallbackLetter: 'R', size: 100),
        const SizedBox(height: 16),
        Text(
          'CHALLENGE ${widget.friendUsername.toUpperCase()}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'The winner takes 25 ELO!',
          style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final isSelected = _selectedCategoryId == cat.id;
        final isLocked = !cat.isLive;

        return GestureDetector(
          onTap: isLocked
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This category launches in V2!')),
                  )
              : () => setState(() => _selectedCategoryId = cat.id),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accent
                        : isLocked
                            ? AppColors.secondary.withOpacity(0.1)
                            : cat.color.withOpacity(0.3),
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12)]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat.icon,
                      color: isSelected
                          ? Colors.white
                          : isLocked
                              ? AppColors.secondary.withOpacity(0.3)
                              : cat.color,
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isLocked
                                ? AppColors.secondary.withOpacity(0.4)
                                : AppColors.secondary,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLocked)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.lock_outline, color: AppColors.secondary, size: 10),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleSendChallenge() async {
    if (_isSending || _selectedCategoryId == null) return;
    setState(() => _isSending = true);
    HapticService.medium();

    // Generate a canonical duel code (SD-XXXXXX format — PRD Section 4.2)
    final code = DuelCodeGenerator.generate();
    setState(() {
      _generatedCode = code;
      _isSending = false;
    });
    HapticService.light();

    // Show duel code modal
    if (mounted) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.sports_esports, color: AppColors.accent, size: 36),
              const SizedBox(height: 12),
              const Text(
                'CHALLENGE SENT!',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Share this code with ${widget.friendUsername}',
                style: const TextStyle(color: AppColors.secondary, fontSize: 12),
              ),
              const SizedBox(height: 24),
              // SD-XXXXXX code chip
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code));
                  HapticService.light();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Duel code copied!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent, width: 2),
                    boxShadow: [
                      BoxShadow(color: AppColors.accent.withOpacity(0.25), blurRadius: 30),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.copy, color: AppColors.secondary, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap code to copy • Expires in 10 minutes',
                style: TextStyle(color: AppColors.secondary, fontSize: 10),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('DONE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (mounted) context.pop();
  }
}
