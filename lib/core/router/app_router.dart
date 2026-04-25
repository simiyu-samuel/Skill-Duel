import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/onboarding/screens/onboarding_carousel_screen.dart';
import '../../features/onboarding/screens/avatar_setup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/duel/screens/category_detail_screen.dart';
import '../../features/duel/screens/matchmaking_screen.dart';
import '../../features/duel/screens/active_question_screen.dart';
import '../../features/results/screens/results_screen.dart';
import '../../features/results/screens/answer_review_screen.dart';
import '../../features/social/screens/leaderboard_screen.dart';
import '../../features/social/screens/duel_history_screen.dart';
import '../../features/profile/screens/my_profile_screen.dart';
import '../../features/profile/screens/upgrade_pro_screen.dart';
import '../../features/profile/screens/purchase_success_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/daily/screens/daily_challenge_screen.dart';
import '../../features/social/screens/friends_screen.dart';
import '../../features/duel/screens/direct_challenge_screen.dart';
import '../../features/social/screens/notifications_screen.dart';
import '../../../models/match.dart';
import '../../shared/widgets/bottom_nav_shell.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(title)));
}

const _publicRoutes = ['/splash', '/onboarding', '/login', '/signup'];

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshStream =
      _GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());
  ref.onDispose(refreshStream.dispose);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isPublicRoute = _publicRoutes.contains(state.matchedLocation);

      if (isLoggedIn && isPublicRoute && state.matchedLocation != '/splash') {
        return '/home';
      }
      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }
      return null;
    },
    routes: [
      // ── Public routes (no shell / bottom nav) ─────────────────────────
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingCarouselScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/avatar-setup',
        name: RouteNames.avatarSetup,
        builder: (_, __) => const AvatarSetupScreen(),
      ),

      // ── Full-screen overlays (no bottom nav) ──────────────────────────
      GoRoute(
        path: '/active-question',
        name: RouteNames.activeQuestion,
        builder: (context, state) {
          final match = state.extra as GameMatch;
          return ActiveQuestionScreen(match: match);
        },
      ),
      GoRoute(
        path: '/results',
        name: RouteNames.results,
        builder: (context, state) {
          final match = state.extra as GameMatch;
          return ResultsScreen(
            isWin: match.scores['current_user_id']! >=
                (match.scores['bot_007'] ?? 0),
            myScore: match.scores['current_user_id']!,
            opponentScore: match.scores['bot_007'] ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/answer-review',
        name: RouteNames.answerReview,
        builder: (_, __) => const AnswerReviewScreen(),
      ),
      GoRoute(
        path: '/direct-challenge',
        name: RouteNames.directChallenge,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DirectChallengeScreen(
            friendId: extra?['friendId'] ?? 'unknown',
            friendUsername: extra?['friendUsername'] ?? 'Rival',
          );
        },
      ),
      GoRoute(
        path: '/share-result',
        name: RouteNames.shareResult,
        builder: (_, __) => const PlaceholderScreen('Share Result'),
      ),
      GoRoute(
        path: '/add-friend',
        name: RouteNames.addFriend,
        builder: (_, __) => const PlaceholderScreen('Add Friend'),
      ),
      GoRoute(
        path: '/purchase-success',
        name: RouteNames.purchaseSuccess,
        builder: (_, __) => const PurchaseSuccessScreen(),
      ),

      // ── Main app shell with persistent bottom navigation ───────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => BottomNavShell(shell: shell),
        branches: [
          // Branch 0 — HQ (Home)
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              name: RouteNames.home,
              builder: (_, __) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'category',
                  name: RouteNames.categoryDetail,
                  builder: (_, __) => const CategoryDetailScreen(),
                ),
                GoRoute(
                  path: 'daily',
                  name: RouteNames.daily,
                  builder: (_, __) => const DailyChallengeScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  name: RouteNames.notifications,
                  builder: (_, __) => const NotificationsScreen(),
                ),
              ],
            ),
          ]),

          // Branch 1 — ARENA (Matchmaking)
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/matchmaking',
              name: RouteNames.matchmaking,
              builder: (_, __) => const MatchmakingScreen(),
            ),
          ]),

          // Branch 2 — RANKS (Leaderboard)
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/leaderboard',
              name: RouteNames.leaderboard,
              builder: (_, __) => const LeaderboardScreen(),
              routes: [
                GoRoute(
                  path: 'history',
                  name: RouteNames.duelHistory,
                  builder: (_, __) => const DuelHistoryScreen(),
                ),
              ],
            ),
          ]),

          // Branch 3 — ME (Profile)
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/my-profile',
              name: RouteNames.myProfile,
              builder: (_, __) => const MyProfileScreen(),
              routes: [
                GoRoute(
                  path: 'settings',
                  name: RouteNames.settings,
                  builder: (_, __) => const SettingsScreen(),
                ),
                GoRoute(
                  path: 'upgrade',
                  name: RouteNames.upgradePro,
                  builder: (_, __) => const UpgradeProScreen(),
                ),
                GoRoute(
                  path: 'friends',
                  name: RouteNames.friends,
                  builder: (_, __) => const FriendsScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
