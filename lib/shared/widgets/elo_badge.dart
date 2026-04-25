import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ELOBadge extends StatelessWidget {
  final int elo;
  final double? fontSize;
  final EdgeInsets? padding;

  const ELOBadge({
    super.key,
    required this.elo,
    this.fontSize,
    this.padding,
  });

  Color _getTierColor() {
    if (elo >= 1200) return AppColors.eloMaster;
    if (elo >= 1100) return AppColors.eloGold;
    if (elo >= 1000) return AppColors.eloSilver;
    return AppColors.eloBronze;
  }

  String _getTierName() {
    if (elo >= 1200) return 'MASTER';
    if (elo >= 1100) return 'GOLD';
    if (elo >= 1000) return 'SILVER';
    return 'BRONZE';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTierColor();
    
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, color: color, size: (fontSize ?? 12) + 4),
          const SizedBox(width: 4),
          Text(
            '$elo',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: fontSize ?? 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
