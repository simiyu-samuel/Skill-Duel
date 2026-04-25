import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use listen to reactively navigate once the stream emits a value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupAuthListener();
    });
  }

  void _setupAuthListener() {
    // Artificial delay for branding
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      ref.listenManual(authStateProvider, (previous, next) {
        _navigate(next);
      }, fireImmediately: true);
    });
  }

  void _navigate(AsyncValue<User?> authState) {
    if (!mounted) return;
    
    authState.when(
      data: (user) {
        if (user == null) {
          context.goNamed(RouteNames.onboarding);
        } else {
          context.goNamed(RouteNames.home);
        }
      },
      loading: () => {}, // Stay on splash
      error: (e, s) {
        debugPrint('Auth Error: $e');
        context.goNamed(RouteNames.login);
      },
    );
  }

  // Remove the old _handleNavigation method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo - In a real app, use an SVG or Image
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.military_tech,
                color: Colors.white,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'SKILL DUEL',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '1V1 KNOWLEDGE BATTLE',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 2,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
