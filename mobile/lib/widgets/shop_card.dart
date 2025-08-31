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
    // tighter, denser row (target ~120-140dp)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Material(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(AppRadii.card),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.card),
          onTap: onDetails,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // removed profile avatar to save horizontal space (shops do not need profile pictures)
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  shop.name,
                                  style: AppTypography.cardTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (shop.trending)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Icon(
                                    Icons.trending_up,
                                    color: AppColors.kpiHighlight,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${shop.category} \u00b7 ${shop.city}',
                            style: AppTypography.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _statChip(
                                'Avg UPI',
                                currency.format(shop.avgUpi),
                              ),
                              const SizedBox(width: 6),
                              _statChip('Ticket', currency.format(shop.ticket)),
                              const SizedBox(width: 6),
                              _statChip('Est', '${shop.estReturn}x'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // progress + percent label laid out in a row to avoid overflow and keep measurements stable
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.small,
                                  ),
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    minHeight: 8,
                                    backgroundColor: AppColors.surface
                                        .withAlpha((0.9 * 255).round()),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.accentGreenLight,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // percent pill reserved to the right of the progress bar and will not overflow
                              _percentBadge(percentLabel),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // removed trailing floating actions; actions moved below progress for better layout
                    const SizedBox(width: 6),
                  ],
                ),
                // action row placed beneath the main row content to avoid right-side congestion
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: onInvest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(84, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: Center(
                        child: Text(
                          'Subscribe',
                          style: AppTypography.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(
                          Icons.more_horiz,
                          color: AppColors.primaryText,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha((0.85 * 255).round()),
        borderRadius: BorderRadius.circular(AppRadii.small),
      ),
      child: Text(
        '$label: $value',
        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _percentBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.kpiHighlight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTypography.badge.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
