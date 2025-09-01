import 'package:flutter/material.dart';
import '../design_tokens.dart';

class MarketSummaryCard extends StatelessWidget {
  final int activeListings;
  final String? todayVolume; // INR formatted string or null
  final String totalFundRaised; // already formatted (INR)
  const MarketSummaryCard({
    super.key,
    required this.activeListings,
    this.todayVolume,
    required this.totalFundRaised,
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Active listings
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.store, color: AppColors.accentGreen, size: 18),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeListings.toString(),
                          style: AppTypography.kpiNumber.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 2),
                        Text('Active', style: AppTypography.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Total raised (accent orange)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.savings, color: AppColors.accentOrange, size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalFundRaised.isNotEmpty ? totalFundRaised : 'N/A',
                        style: AppTypography.kpiNumber.copyWith(
                          fontSize: 18,
                          color: AppColors.accentOrange,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Total Raised', style: AppTypography.caption),
                    ],
                  ),
                ],
              ),
            ),

            // Today volume
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.show_chart, color: AppColors.mutedText, size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        todayVolume ?? 'N/A',
                        style: AppTypography.kpiNumber.copyWith(
                          fontSize: 16,
                          color: todayVolume == null
                              ? AppColors.mutedText
                              : AppColors.kpiHighlight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('Today', style: AppTypography.caption),
                          if (todayVolume == null) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: AppColors.accentOrange,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
