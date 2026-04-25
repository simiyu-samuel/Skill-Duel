import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    // Router auto-redirects on success; show error if failed
    final state = ref.read(authNotifierProvider);
    if (state.hasError && mounted) {
      _showError(_friendlyError(state.error));
    }
  }

  Future<void> _handleGoogle() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    final state = ref.read(authNotifierProvider);
    if (state.hasError && mounted) {
      _showError(_friendlyError(state.error));
    }
  }

  Future<void> _handleGuest() async {
    await ref.read(authNotifierProvider.notifier).signInAnonymously();
    final state = ref.read(authNotifierProvider);
    if (state.hasError && mounted) {
      _showError(_friendlyError(state.error));
    }
  }

  String _friendlyError(Object? error) {
    final msg = error?.toString() ?? 'Something went wrong';
    if (msg.contains('user-not-found')) return 'No account found with this email.';
    if (msg.contains('wrong-password') || msg.contains('invalid-credential')) return 'Incorrect email or password.';
    if (msg.contains('too-many-requests')) return 'Too many attempts. Please try again later.';
    if (msg.contains('network-request-failed')) return 'No internet connection.';
    if (msg.contains('sign_in_cancelled')) return 'Google sign-in was cancelled.';
    if (msg.contains('operation-not-allowed')) return 'This sign-in method is not enabled. Enable it in Firebase Console.';
    return 'Sign-in failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.military_tech, color: Colors.white, size: 44),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'WELCOME BACK',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your duels',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 48),
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  validator: (val) =>
                      val != null && val.contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 16),
                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  enabled: !isLoading,
                  validator: (val) =>
                      val != null && val.length >= 6 ? null : 'Password too short',
                ),
                const SizedBox(height: 32),
                // Login button
                PrimaryButton(
                  label: 'LOG IN',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _handleLogin,
                ),
                const SizedBox(height: 16),
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.surface)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary)),
                    ),
                    const Expanded(child: Divider(color: AppColors.surface)),
                  ],
                ),
                const SizedBox(height: 16),
                // Google
                SecondaryButton(
                  label: 'CONTINUE WITH GOOGLE',
                  icon: Icons.g_mobiledata,
                  onPressed: isLoading ? null : _handleGoogle,
                ),
                const SizedBox(height: 24),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(color: AppColors.textSecondary)),
                    TextButton(
                      onPressed:
                          isLoading ? null : () => context.goNamed(RouteNames.signup),
                      child: const Text('SIGN UP',
                          style: TextStyle(
                              color: AppColors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // Guest
                TextButton(
                  onPressed: isLoading ? null : _handleGuest,
                  child: const Text(
                    'CONTINUE AS GUEST',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
