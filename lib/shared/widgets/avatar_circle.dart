import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

class AvatarCircle extends StatelessWidget {
  final String? imageUrl;
  final String fallbackLetter;
  final double size;
  final bool isOnline;
  final bool showBorder;

  const AvatarCircle({
    super.key,
    this.imageUrl,
    required this.fallbackLetter,
    this.size = 48,
    this.isOnline = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: showBorder 
                ? Border.all(color: AppColors.accent.withOpacity(0.5), width: 2)
                : null,
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildFallback(),
                    errorWidget: (context, url, error) => _buildFallback(),
                  )
                : _buildFallback(),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFallback() {
    // Generate a background color based on the letter to keep it consistent and colorful
    final colorIndex = fallbackLetter.hashCode % _avatarColors.length;
    final backgroundColor = _avatarColors[colorIndex];

    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(
        fallbackLetter.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.45,
        ),
      ),
    );
  }

  static const List<Color> _avatarColors = [
    Color(0xFFE94560),
    Color(0xFF4A4E8C),
    Color(0xFF0F3460),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFF9B59B6),
    Color(0xFF1ABC9C),
    Color(0xFF3498DB),
  ];
}
