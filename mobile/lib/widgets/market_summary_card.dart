import 'package:flutter/material.dart';
import '../design_tokens.dart';

class MarketSummaryCard extends StatelessWidget {
  final int activeListings;
  final String todayVolume;
  final String avgYield;
  const MarketSummaryCard({
    super.key,
    required this.activeListings,
    required this.todayVolume,
    required this.avgYield,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKPI(
              'Market Index',
              avgYield,
              AppColors.kpiHighlight,
              Icons.trending_up,
            ),
            _buildKPI(
              'Active Listings',
              activeListings.toString(),
              AppColors.accentGreen,
              Icons.store,
            ),
            _buildKPI(
              'Today Vol',
              todayVolume,
              AppColors.kpiHighlight,
              Icons.currency_rupee,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPI(String label, String value, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: AppTypography.sectionHeading.copyWith(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
