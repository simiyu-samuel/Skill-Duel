import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/social_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../models/app_user.dart';

// ── Stream providers ──────────────────────────────────────────────────────────

final globalLeaderboardProvider = StreamProvider<List<AppUser>>((ref) {
  return ref.watch(socialServiceProvider).getGlobalLeaderboard();
});

final friendsListProvider = StreamProvider<List<AppUser>>((ref) {
  final uid = ref.watch(firebaseUserProvider).value?.uid ?? '';
  if (uid.isEmpty) return Stream.value([]);
  return ref.watch(socialServiceProvider).getFriends(uid);
});

final incomingChallengesProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final uid = ref.watch(firebaseUserProvider).value?.uid ?? '';
  if (uid.isEmpty) return Stream.value([]);
  return ref.watch(socialServiceProvider).getIncomingChallenges(uid);
});

// ── Social Action Notifier (Riverpod 3.x) ────────────────────────────────────

class SocialActionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> sendRequest(String fromUid, String toUid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(socialServiceProvider).sendFriendRequest(fromUid, toUid),
    );
  }

  Future<void> acceptRequest(String requestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(socialServiceProvider).acceptFriendRequest(requestId),
    );
  }

  Future<void> challengeFriend(
      String fromUid, String toUid, String category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(socialServiceProvider)
          .sendChallenge(fromUid, toUid, category),
    );
  }

  Future<void> respondToChallenge(String challengeId, bool accept) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(socialServiceProvider)
          .respondToChallenge(challengeId, accept),
    );
  }
}

final socialActionProvider =
    NotifierProvider<SocialActionNotifier, AsyncValue<void>>(
        SocialActionNotifier.new);
