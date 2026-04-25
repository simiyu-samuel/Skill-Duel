import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/duel_card.dart';

class DuelHistoryScreen extends StatelessWidget {
  const DuelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DUEL HISTORY'),
        backgroundColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: AppColors.accent,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(text: 'ALL'),
                Tab(text: 'WINS'),
                Tab(text: 'LOSSES'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHistoryList(context),
                  _buildHistoryList(context, filter: 'win'),
                  _buildHistoryList(context, filter: 'loss'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, {String? filter}) {
    // Mock data for history
    final history = [
      {'opponent': 'Sniper22', 'category': 'football', 'win': true, 'myScore': 8, 'oppScore': 4, 'elo': 25},
      {'opponent': 'QuizMaster', 'category': 'chess', 'win': false, 'myScore': 3, 'oppScore': 10, 'elo': -15},
      {'opponent': 'CodeNinja', 'category': 'coding', 'win': true, 'myScore': 12, 'oppScore': 9, 'elo': 20},
      {'opponent': 'ShadowDuelist', 'category': 'football', 'win': true, 'myScore': 7, 'oppScore': 6, 'elo': 18},
    ];

    final filteredData = filter == null 
        ? history 
        : history.where((e) => filter == 'win' ? e['win'] == true : e['win'] == false).toList();

    if (filteredData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text('No duels found in this category', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredData.length,
      itemBuilder: (ctx, i) {
        final item = filteredData[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DuelCard(
            title: 'vs. ${item['opponent']}',
            subtitle: item['win'] == true ? 'Complete Victory' : 'Duel Lost',
            category: item['category'] as String,
            myScore: item['myScore'] as int,
            opponentScore: item['oppScore'] as int,
            eloChange: item['elo'] as int,
            isWin: item['win'] as bool,
            onTap: () {}, // Could navigate to review
          ),
        );
      },
    );
  }
}
