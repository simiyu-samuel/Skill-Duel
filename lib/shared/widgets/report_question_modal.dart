import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'app_buttons.dart';

class ReportQuestionModal extends StatelessWidget {
  final String questionId;

  const ReportQuestionModal({super.key, required this.questionId});

  static void show(BuildContext context, String questionId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReportQuestionModal(questionId: questionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'REPORT AN ISSUE',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help us improve by flagging errors in this question.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondary, fontSize: 12),
          ),
          const SizedBox(height: 32),
          _reportOption(context, 'Incorrect answer'),
          _reportOption(context, 'Spelling/Grammar error'),
          _reportOption(context, 'Inappropriate content'),
          _reportOption(context, 'Outdated information'),
          _reportOption(context, 'Something else'),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'SUBMIT REPORT',
            onPressed: () {
              // TODO: Log report to Analytics/Firestore
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you! Our moderators will review this.')),
              );
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _reportOption(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.1)),
      ),
      child: RadioListTile<String>(
        activeColor: AppColors.accent,
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        value: label,
        groupValue: null, // Stateless for now, in a real app this would be managed
        onChanged: (val) {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
