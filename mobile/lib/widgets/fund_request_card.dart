import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        statusColor = AppColors.raiseFundTealStart;
        break;
      case 'Completed':
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.warning;
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _statusBadge(request.status, statusColor),
                const SizedBox(width: 12),
                Text(
                  request.title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Raised: ${currency.format(request.raised)}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(width: 16),
                Text(
                  'Target: ${currency.format(request.target)}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: AppColors.neutralLight,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
                const SizedBox(width: 12),
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
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppRadii.small),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(label, style: AppTypography.badge.copyWith(color: color)),
  );
}

Widget _percentBadge(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color,
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
