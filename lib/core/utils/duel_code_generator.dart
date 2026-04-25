import 'dart:math';

/// Generates duel invite codes in the canonical SD-XXXXXX format
/// as specified in Project Scope v2.0 — Section 4.2 (Direct Challenge).
class DuelCodeGenerator {
  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final Random _rng = Random.secure();

  /// Returns a new unique duel code e.g. "SD-K7MN2P"
  static String generate() {
    final code = List.generate(6, (_) => _chars[_rng.nextInt(_chars.length)]).join();
    return 'SD-$code';
  }

  /// Returns true if [code] matches the SD-XXXXXX pattern.
  static bool isValid(String code) {
    return RegExp(r'^SD-[A-Z2-9]{6}$').hasMatch(code.toUpperCase().trim());
  }
}
