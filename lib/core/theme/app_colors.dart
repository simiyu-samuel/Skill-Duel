import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds (Synchronized with Stitch HTML/CSS)
  static const background = Color(0xFF0F172A); // Dark slate from Stitch headers
  static const surface = Color(0xFF16213E);    // Glass/Card surface
  static const surfaceAlt = Color(0xFF1E293B); 

  // Brand Colors
  static const accent = Color(0xFFFC536D);     // Vibrant Magenta/Pink from Stitch
  static const secondary = Color(0xFF4A4E8C);  // Muted indigo
  static const tertiary = Color(0xFF67DC9F);   // Success Green from results

  // Text Colors
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA0A0B0);
  static const textMuted = Color(0xFF4A4E8C);

  // Semantic Colors
  static const success = Color(0xFF67DC9F);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFFC536D);

  // ELO Tier Colors (Standard RPG/Lobby tiers)
  static const eloBronze = Color(0xFFCD7F32);
  static const eloSilver = Color(0xFFC0C0C0);
  static const eloGold = Color(0xFFFFD700);
  static const eloMaster = Color(0xFF9B59B6);

  // Gradients
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFF950740)],
  );

  static const surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, background],
  );
}
