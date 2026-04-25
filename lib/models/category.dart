import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int activeDuels;
  final bool isPremium;
  final bool isLive; // false = V2 placeholder (locked in UI)

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.activeDuels = 0,
    this.isPremium = false,
    this.isLive = true,
  });
}

/// Official categories aligned with Project Scope v2.0.
/// Football & Chess Tactics are live at launch.
/// COD/FPS & General Gaming are V2 placeholders (locked in UI).
/// Coding is live at launch as per user confirmation.
const mockCategories = [
  Category(
    id: 'football',
    name: 'Football',
    icon: Icons.sports_soccer,
    color: Color(0xFF22C55E),
    activeDuels: 124,
    isLive: true,
  ),
  Category(
    id: 'chess',
    name: 'Chess Tactics',
    icon: Icons.extension, // chess piece silhouette
    color: Color(0xFFF59E0B),
    activeDuels: 82,
    isLive: true,
  ),
  Category(
    id: 'coding',
    name: 'Coding',
    icon: Icons.terminal,
    color: Color(0xFF00D1FF),
    activeDuels: 156,
    isLive: true,
  ),
  Category(
    id: 'cod',
    name: 'COD/FPS',
    icon: Icons.gps_fixed,
    color: Color(0xFFFC536D),
    activeDuels: 0,
    isPremium: true,
    isLive: false,
  ),
  Category(
    id: 'gaming',
    name: 'General Gaming',
    icon: Icons.videogame_asset,
    color: Color(0xFF6366F1),
    activeDuels: 0,
    isPremium: true,
    isLive: false,
  ),
];
