import 'package:flutter/services.dart';

/// PRD Sensory Feedback Requirements — centralized haptic calls.
/// All haptic triggers must go through this class to allow
/// easy disabling via the Haptics toggle in Settings (Screen 36).
class HapticService {
  static bool _enabled = true;

  static void setEnabled(bool value) => _enabled = value;

  /// Light tick — answer option tap, navigation press.
  static Future<void> light() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Medium bump — timer warning (≤5 s), lock-in confirmation.
  static Future<void> medium() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Heavy thud — VICTORY / DEFEAT reveal, ELO change shown.
  static Future<void> heavy() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Error buzz — wrong answer revealed, connection lost alert.
  static Future<void> error() async {
    if (!_enabled) return;
    await HapticFeedback.vibrate();
  }

  /// Double-tap pattern — VICTORY celebration (heavy × 2).
  static Future<void> victory() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }
}
