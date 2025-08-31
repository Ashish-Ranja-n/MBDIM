import 'package:flutter/material.dart';
import '../design_tokens.dart';

class MarketSummaryCard extends StatelessWidget {
  final int activeListings;
  final String todayVolume;
  final String totalFundRaised;
  final String avgYield;
  const MarketSummaryCard({
    super.key,
    required this.activeListings,
    required this.todayVolume,
    required this.totalFundRaised,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildKPI(
                  'Market Index',
                  avgYield,
                  AppColors.warning,
                  Icons.trending_up,
                ),
                _buildKPI(
                  'Active Listings',
                  activeListings.toString(),
                  AppColors.warning,
                  Icons.store,
                ),
                _buildKPI(
                  'Total Fund Raised',
                  totalFundRaised,
                  AppColors.warning,
                  Icons.savings,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildKPI(
                  'Today RSA',
                  todayVolume,
                  AppColors.warning,
                  Icons.home_repair_service_rounded,
                ),
              ],
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
              // emphasise KPI numbers using the highlight colour (matches designer reference)
              style: AppTypography.sectionHeading.copyWith(
                color: AppColors.warning,
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
