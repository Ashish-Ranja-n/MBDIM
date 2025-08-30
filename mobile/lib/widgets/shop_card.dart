import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../design_tokens.dart';

class Shop {
  final String name;
  final String category;
  final String city;
  final String logoAsset;
  final double avgUpi;
  final double ticket;
  final double estReturn;
  final double raised;
  final double target;
  final bool trending;

  Shop({
    required this.name,
    required this.category,
    required this.city,
    required this.logoAsset,
    required this.avgUpi,
    required this.ticket,
    required this.estReturn,
    required this.raised,
    required this.target,
    this.trending = false,
  });
}

class ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback onInvest;
  final VoidCallback onDetails;
  const ShopCard({
    super.key,
    required this.shop,
    required this.onInvest,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (shop.raised / shop.target).clamp(0, 1).toDouble();
    final percentLabel = '${(percent * 100).toStringAsFixed(0)}%';
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      elevation: AppElevation.blur,
      shadowColor: AppElevation.color,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: shop.logoAsset,
              child: CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(shop.logoAsset),
                backgroundColor: AppColors.neutralLight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(shop.name, style: AppTypography.cardTitle),
                      if (shop.trending)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.trending_up,
                            color: AppColors.marketProgressFill,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${shop.category} · ${shop.city}',
                    style: AppTypography.small,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statChip('Avg UPI/day', currency.format(shop.avgUpi)),
                      const SizedBox(width: 6),
                      _statChip('Ticket', currency.format(shop.ticket)),
                      const SizedBox(width: 6),
                      _statChip('Est', '${shop.estReturn}x'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadii.small),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 8,
                            backgroundColor: AppColors.neutralLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.marketProgressFill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _percentBadge(percentLabel),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onInvest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.marketPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.button),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(
                      Icons.paid,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 44,
                  height: 36,
                  child: TextButton(
                    onPressed: onDetails,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.mutedText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.button),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Details',
                      style: AppTypography.small.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(AppRadii.small),
      ),
      child: Text(
        '$label: $value',
        style: AppTypography.small.copyWith(color: AppColors.primaryText),
      ),
    );
  }

  Widget _percentBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.marketPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(label, style: AppTypography.badge),
    );
  }
}
