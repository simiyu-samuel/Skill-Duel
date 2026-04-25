import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../shared/widgets/app_buttons.dart';

/// Screen 12/13 — Duel Results (PRD Section 3.2)
/// Displays win/loss outcome, score breakdown, ELO change,
/// and allows sharing the result card (Screen 18) via share_plus.
class ResultsScreen extends ConsumerStatefulWidget {
  final bool isWin;
  final int myScore;
  final int opponentScore;
  final int eloChange;

  const ResultsScreen({
    super.key,
    required this.isWin,
    required this.myScore,
    required this.opponentScore,
    this.eloChange = 24,
  });

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  // Key wrapping the shareable result card widget tree.
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    // PRD Sensory: heavy thud on result reveal
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 600));
      widget.isWin ? HapticService.victory() : HapticService.heavy();
    });
  }

  /// Captures [_shareCardKey]'s subtree as a PNG and invokes the OS share sheet.
  Future<void> _shareResultCard() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    HapticService.light();

    try {
      // Capture the RepaintBoundary as a raster image
      final boundary = _shareCardKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Write PNG to temp directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/skill_duel_result.png').writeAsBytes(bytes);

      // Share via OS share sheet
      await Share.shareXFiles(
        [XFile(file.path)],
        text: widget.isWin
            ? '🏆 I just beat my opponent ${widget.myScore}-${widget.opponentScore} in Skill Duel! +${widget.eloChange} ELO 🔥 Download Skill Duel and challenge me!'
            : '💪 ${widget.myScore}-${widget.opponentScore} — a tough match! My Skill Duel ELO journey continues. Download Skill Duel!',
        subject: 'Skill Duel — Duel Result',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not share result card. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DUEL RESULTS',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        actions: [
          // Share Result Card button (Screen 18 — PRD v2.0)
          _isSharing
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.ios_share, color: AppColors.secondary),
                  tooltip: 'Share result card',
                  onPressed: _shareResultCard,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // ── Shareable Result Card ──────────────────────────────────
            RepaintBoundary(
              key: _shareCardKey,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildResultBanner(context),
                    const SizedBox(height: 32),
                    _buildOverlappingScores(context),
                    const SizedBox(height: 32),
                    _buildEloChangeCard(context),
                    const SizedBox(height: 20),
                    _buildShareFooter(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildEarningsRow(context),
            const SizedBox(height: 48),
            _buildActionButtons(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildResultBanner(BuildContext context) {
    final title = widget.isWin ? 'VICTORY!' : 'DEFEAT';
    final subtitle = widget.isWin
        ? 'You outperformed your opponent.'
        : 'Better luck in the next arena.';
    final color = widget.isWin ? AppColors.accent : AppColors.secondary;

    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: color,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            shadows: [
              if (widget.isWin)
                Shadow(
                  color: AppColors.accent.withOpacity(0.5),
                  blurRadius: 30,
                ),
            ],
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 8),
        Text(
          subtitle.toUpperCase(),
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildOverlappingScores(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            child: _buildScoreCircle(
              score: '${widget.opponentScore}',
              label: 'OPPONENT',
              color: AppColors.secondary,
              size: 130,
              isSecondary: true,
            ),
          ),
          Positioned(
            left: 0,
            child: _buildScoreCircle(
              score: '${widget.myScore}',
              label: 'YOU',
              color: AppColors.accent,
              size: 160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCircle({
    required String score,
    required String label,
    required Color color,
    required double size,
    bool isSecondary = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 4),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 20),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    ).animate().scale(delay: (isSecondary ? 200 : 400).ms, duration: 400.ms);
  }

  Widget _buildEloChangeCard(BuildContext context) {
    final value = widget.isWin ? '+${widget.eloChange}' : '-${widget.eloChange ~/ 2}';
    final color = widget.isWin ? AppColors.accent : AppColors.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        boxShadow: widget.isWin
            ? [BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 30)]
            : null,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'ELO RATING CHANGE',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, duration: 400.ms);
  }

  /// Branding footer visible only on the shared image — not in the main UI.
  Widget _buildShareFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_esports, color: AppColors.accent, size: 14),
                SizedBox(width: 6),
                Text(
                  'SKILL DUEL',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'YOU EARNED ',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          '120',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(width: 4),
        Icon(Icons.monetization_on, color: Colors.amber, size: 16),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: AppColors.accent.withOpacity(0.5),
              elevation: 8,
            ),
            onPressed: () {
              HapticService.light();
              // TODO: trigger rematch flow via DirectChallengeScreen with same opponent
            },
            child: const Text(
              'REMATCH',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.history_edu_outlined, color: AppColors.secondary, size: 18),
            label: const Text(
              'REVIEW ANSWERS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            onPressed: () {
              HapticService.light();
              context.goNamed(RouteNames.answerReview);
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              HapticService.light();
              context.goNamed(RouteNames.home);
            },
            child: const Text(
              'BACK TO HQ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
