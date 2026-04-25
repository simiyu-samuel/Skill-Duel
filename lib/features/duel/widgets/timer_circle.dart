import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TimerCircle extends StatelessWidget {
  final double progress;
  final int secondsRemaining;
  final double size;
  final String? label;

  const TimerCircle({
    super.key,
    required this.progress,
    required this.secondsRemaining,
    this.size = 120,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = secondsRemaining <= 5 ? AppColors.error : AppColors.accent;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              colors: [color.withOpacity(0.5), color],
            ).createShader(rect),
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          // Glow effect
          Container(
            width: size - 10,
            height: size - 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label!.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              Text(
                '$secondsRemaining',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              if (label == null)
                const Text(
                  'SEC',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
