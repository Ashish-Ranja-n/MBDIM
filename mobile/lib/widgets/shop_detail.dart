import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shop_card.dart';

class ShopDetailPage extends StatelessWidget {
  final Shop shop;
  const ShopDetailPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          shop.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(shop.logoAsset),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${shop.category} · ${shop.city}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Avg UPI/day: ₹${shop.avgUpi}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              'Ticket: ₹${shop.ticket}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              'Est Return: ${shop.estReturn}x',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              'Raised: ₹${shop.raised}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              'Target: ₹${shop.target}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: (shop.raised / shop.target).clamp(0, 1).toDouble(),
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            const SizedBox(height: 24),
            Text(
              'More details coming soon...',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
