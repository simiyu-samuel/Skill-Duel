import 'dart:math';

/// ELO rating calculator as defined in Project Scope v2.0 — Section 6.2.
///
/// Starting ELO: 1000 for all categories.
/// K-factor: 32 if rating < 1200 (vulnerable player), 16 if rating >= 1200 (established).
/// actual: 1.0 = win, 0.5 = draw, 0.0 = loss.
///
/// IMPORTANT: ELO is always calculated server-side in Cloud Functions.
/// This utility mirrors the logic for client-side preview only.
class EloCalculator {
  static const double _startingElo = 1000.0;
  static const int _kFactorLow = 32;
  static const int _kFactorHigh = 16;
  static const int _kThreshold = 1200;

  /// Returns the starting ELO for a new player in any category.
  static double get startingElo => _startingElo;

  /// Returns the K-factor based on the player's current rating.
  static int kFactor(double rating) =>
      rating < _kThreshold ? _kFactorLow : _kFactorHigh;

  /// Expected score for player A against player B.
  /// Returns a probability between 0.0 and 1.0.
  static double expectedScore(double ratingA, double ratingB) {
    return 1.0 / (1.0 + pow(10, (ratingB - ratingA) / 400));
  }

  /// Calculates the new rating for a player after a match.
  /// [actual] is 1.0 for a win, 0.5 for a draw, 0.0 for a loss.
  static double newRating({
    required double rating,
    required double opponentRating,
    required double actual,
  }) {
    final k = kFactor(rating);
    final expected = expectedScore(rating, opponentRating);
    return (rating + k * (actual - expected)).roundToDouble();
  }

  /// Convenience: calculates ELO change (delta) for display purposes.
  static int eloDelta({
    required double rating,
    required double opponentRating,
    required bool isWin,
  }) {
    final updated = newRating(
      rating: rating,
      opponentRating: opponentRating,
      actual: isWin ? 1.0 : 0.0,
    );
    return (updated - rating).round();
  }
}
