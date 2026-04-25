import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stub AdService — google_mobile_ads SDK not yet included in pubspec.
/// Wire the real SDK once the AdMob app ID is registered (see Ad Setup Guide).
/// All call sites remain unchanged — this stub silently no-ops.
class AdService {
  int _duelCountSinceLastAd = 0;
  static const int _adFrequency = 3;

  Future<void> initialize() async {
    // Real implementation: await MobileAds.instance.initialize();
  }

  Future<void> showInterstitialIfEligible(bool isPro) async {
    if (isPro) return;
    _duelCountSinceLastAd++;
    if (_duelCountSinceLastAd >= _adFrequency) {
      _duelCountSinceLastAd = 0;
      // Real implementation: show interstitial ad
    }
  }
}

final adServiceProvider = Provider<AdService>((ref) => AdService());
