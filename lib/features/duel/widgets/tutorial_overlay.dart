import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({super.key, required this.onComplete});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _step = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'THE TIMER',
      content: 'You have 20 seconds to answer each question. Be fast to stay in the game!',
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 160),
    ),
    TutorialStep(
      title: 'CHOOSE WISELY',
      content: 'Tap an option to submit. Once selected, your answer is locked for this duel.',
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
    ),
    TutorialStep(
      title: 'ASYNC DUEL',
      content: 'Your opponent plays the same questions independently. Scores are revealed once both finish!',
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 120),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_step];

    return Material(
      color: Colors.black.withOpacity(0.85),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_step < _steps.length - 1) {
              _step++;
            } else {
              widget.onComplete();
            }
          });
        },
        child: Stack(
          children: [
            // Instruction Box
            Align(
              alignment: currentStep.alignment,
              child: Padding(
                padding: currentStep.padding.add(const EdgeInsets.all(40)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentStep.title,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentStep.content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      _step == _steps.length - 1 ? 'START DUEL' : 'TAP TO CONTINUE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Skip button
            Positioned(
              top: 60,
              right: 20,
              child: TextButton(
                onPressed: widget.onComplete,
                child: const Text(
                  'SKIP TUTORIAL',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String content;
  final Alignment alignment;
  final EdgeInsets padding;

  TutorialStep({
    required this.title,
    required this.content,
    required this.alignment,
    required this.padding,
  });
}
