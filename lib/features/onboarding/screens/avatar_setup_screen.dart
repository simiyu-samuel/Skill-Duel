import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/avatar_circle.dart';

class AvatarSetupScreen extends ConsumerStatefulWidget {
  const AvatarSetupScreen({super.key});

  @override
  ConsumerState<AvatarSetupScreen> createState() => _AvatarSetupScreenState();
}

class _AvatarSetupScreenState extends ConsumerState<AvatarSetupScreen> {
  final _usernameController = TextEditingController();
  String _selectedLetter = 'A';
  final _formKey = GlobalKey<FormState>();

  final List<String> _letters = List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleComplete() async {
    if (_formKey.currentState!.validate()) {
      // In a real app, we'd update the Firestore user document here
      // For now, we'll just navigate to home
      context.goNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'SETUP PROFILE',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how others will see you',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                Center(
                  child: AvatarCircle(
                    fallbackLetter: _selectedLetter,
                    size: 100,
                    showBorder: true,
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Choose Username',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Username is required';
                    if (val.length < 3) return 'Username too short';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'SELECT YOUR INITIAL',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _letters.length,
                    itemBuilder: (ctx, i) {
                      final letter = _letters[i];
                      final isSelected = _selectedLetter == letter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedLetter = letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accent : AppColors.surface,
                            shape: BoxShape.circle,
                            border: isSelected 
                                ? null 
                                : Border.all(color: AppColors.secondary.withOpacity(0.3)),
                          ),
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'COMPLETE SETUP',
                  onPressed: _handleComplete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
