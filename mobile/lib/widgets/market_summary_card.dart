import 'package:flutter/material.dart';
import '../design_tokens.dart';

class MarketSummaryCard extends StatelessWidget {
  final int activeListings;
  final String todayVolume;
  final String avgYield;
  const MarketSummaryCard({
    Key? key,
    required this.activeListings,
    required this.todayVolume,
    required this.avgYield,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      elevation: AppElevation.blur,
      shadowColor: AppElevation.color,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildColumn('Active', activeListings.toString(), Icons.store),
            _buildColumn('Today Vol', todayVolume, Icons.currency_rupee),
            _buildColumn('Avg Yield', avgYield, Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.marketPrimary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.cardTitle),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.small),
      ],
    );
  }
}
