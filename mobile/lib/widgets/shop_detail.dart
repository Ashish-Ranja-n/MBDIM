import 'package:flutter/material.dart';
import 'shop_card.dart';

class ShopDetailPage extends StatelessWidget {
  final Shop shop;
  const ShopDetailPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1115),
      appBar: AppBar(
        title: Text(
          shop.name,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFFE6EEF3),
          ),
        ),
        backgroundColor: const Color(0xFF0F1720),
        foregroundColor: const Color(0xFFE6EEF3),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(shop.logoAsset),
                  backgroundColor: const Color(0xFF12171C),
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6EEF3),
                      ),
                    ),
                    Text(
                      '${shop.category} · ${shop.city}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: Color(0xFF9AA5AD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Avg UPI/day: ₹${shop.avgUpi}',
              style: const TextStyle(fontSize: 16, color: Color(0xFFB7C2C8)),
            ),
            Text(
              'Ticket: ₹${shop.ticket}',
              style: const TextStyle(fontSize: 16, color: Color(0xFFB7C2C8)),
            ),
            Text(
              'Est Return: ${shop.estReturn}x',
              style: const TextStyle(fontSize: 16, color: Color(0xFFB7C2C8)),
            ),
            Text(
              'Raised: ₹${shop.raised}',
              style: const TextStyle(fontSize: 16, color: Color(0xFFB7C2C8)),
            ),
            Text(
              'Target: ₹${shop.target}',
              style: const TextStyle(fontSize: 16, color: Color(0xFFB7C2C8)),
            ),
            const SizedBox(height: 22),
            LinearProgressIndicator(
              value: (shop.raised / shop.target).clamp(0, 1).toDouble(),
              minHeight: 8,
              backgroundColor: const Color(0xFF232A31),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1DB954),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'More details coming soon...',
              style: const TextStyle(fontSize: 16, color: Color(0xFF9AA5AD)),
            ),
          ],
        ),
      ),
    );
  }
}
