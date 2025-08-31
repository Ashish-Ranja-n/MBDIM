import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../design_tokens.dart';

class FundRequest {
  final String status;
  final double raised;
  final double target;
  final String title;
  FundRequest({
    required this.status,
    required this.raised,
    required this.target,
    required this.title,
  });
}

class FundRequestCard extends StatelessWidget {
  final FundRequest request;
  const FundRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final percent = (request.raised / request.target).clamp(0, 1).toDouble();
    final percentLabel = '${(percent * 100).toStringAsFixed(0)}%';
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    Color statusColor;
    switch (request.status) {
      case 'Active':
        statusColor = AppColors.accentGreen;
        break;
      case 'Completed':
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.warning;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _statusBadge(request.status, statusColor),
                const SizedBox(width: 12),
                Text(request.title, style: AppTypography.cardTitle),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Raised: ${currency.format(request.raised)}',
                  style: AppTypography.body,
                ),
                const SizedBox(width: 16),
                Text(
                  'Target: ${currency.format(request.target)}',
                  style: AppTypography.body,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.small),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _percentBadge(percentLabel, statusColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statusBadge(String label, Color color) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withAlpha((0.13 * 255).round()),
      borderRadius: BorderRadius.circular(AppRadii.small),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Text(label, style: AppTypography.badge.copyWith(color: color)),
  );
}

Widget _percentBadge(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
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
      style: AppTypography.badge.copyWith(color: AppColors.primaryText),
    ),
  );
}
