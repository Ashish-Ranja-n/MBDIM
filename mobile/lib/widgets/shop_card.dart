import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    // avatar placeholder
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.small),
                      ),
                      child: Center(
                        child: Text(
                          shop.name[0],
                          style: GoogleFonts.inter(
                            color: AppColors.kpiHighlight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  shop.name,
                                  style: AppTypography.cardTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (shop.trending) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.trending_up,
                                  color: AppColors.kpiHighlight,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${shop.category}  ${shop.city}',
                            style: AppTypography.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          // allow chips to wrap to next line on narrow screens
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _statChip(
                                'Avg UPI',
                                currency.format(shop.avgUpi),
                              ),
                              _statChip('Ticket', currency.format(shop.ticket)),
                              _statChip('Est', '${shop.estReturn}x'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // progress with percent overlay on the right
                          // progress with percent badge aligned inside the bar to avoid overflow
                          Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadii.small,
                                ),
                                child: Container(
                                  height: 8,
                                  color: AppColors.surface.withAlpha(
                                    (0.9 * 255).round(),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: percent,
                                    child: Container(
                                      color: AppColors.accentGreen,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.kpiHighlight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      percentLabel,
                                      style: AppTypography.badge.copyWith(
                                        color: AppColors.surface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // actions column
                    Column(
                      children: [
                        SizedBox(
                          width: 76,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: onInvest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadii.button,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: const Size(76, 36),
                            ),
                            child: Text(
                              'Invest',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 76,
                          height: 28,
                          child: TextButton(
                            onPressed: onDetails,
                            child: const Text(
                              'Details',
                              style: TextStyle(color: Color(0xFFB7C2C8)),
                            ),
                          ),
                        ),
                      ],
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

  // percent badge is now rendered inline as positioned widget
}
