import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/question.dart';

class AnswerReviewScreen extends StatelessWidget {
  const AnswerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock review data
    final reviews = [
      {
        'question': 'Which country has won the most FIFA World Cups?',
        'correct': 'Brazil',
        'userAnswer': 'Germany',
        'explanation': 'Brazil has won a record five FIFA World Cup titles (1958, 1962, 1970, 1994, 2002). Germany follows closely with four titles.',
      },
      {
        'question': 'How many players are on a soccer field for one team?',
        'correct': '11',
        'userAnswer': '11',
        'explanation': 'Standard soccer rules mandate 11 players per team, including the goalkeeper.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ANSWER REVIEW'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: reviews.length,
        itemBuilder: (ctx, i) {
          final review = reviews[i];
          final isCorrect = review['correct'] == review['userAnswer'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCorrect ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QUESTION ${i + 1}',
                    style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review['question']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  _buildResultRow(
                    'YOUR ANSWER',
                    review['userAnswer']!,
                    isCorrect ? AppColors.success : AppColors.error,
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: 8),
                    _buildResultRow('CORRECT ANSWER', review['correct']!, AppColors.success),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                            SizedBox(width: 8),
                            Text('EXPLANATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amber)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review['explanation']!,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
